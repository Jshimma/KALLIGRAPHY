import 'package:file_picker/file_picker.dart';

import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../services/api/api_config.dart';
import '../../services/api/gallery_api_service.dart';
import '../../services/auth/auth_session.dart';

class StudioGalleryManagerScreen extends StatefulWidget {
  const StudioGalleryManagerScreen({
    super.key,
    required this.session,
    required this.galleryId,
  });

  final AuthSession session;
  final int galleryId;

  @override
  State<StudioGalleryManagerScreen> createState() =>
      _StudioGalleryManagerScreenState();
}

class _StudioGalleryManagerScreenState
    extends State<StudioGalleryManagerScreen> {
  final GalleryApiService _api = GalleryApiService();

  Gallery? _gallery;
  List<PortfolioPhoto> _photos = [];

  bool _isLoading = true;
  bool _isUploading = false;
  bool _isSaving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final gallery = await _api.fetchGallery(
        session: widget.session,
        galleryId: widget.galleryId,
      );

      final photos = await _api.fetchGalleryPhotos(
        session: widget.session,
        galleryId: widget.galleryId,
      );

      if (!mounted) return;

      setState(() {
        _gallery = gallery;
        _photos = photos;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = error.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadPhotos() async {
    final files = await FilePicker.pickFiles(type: FileType.image);

    if (files.isEmpty || !mounted) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      await _api.uploadPhotos(
        session: widget.session,
        galleryId: widget.galleryId,
        files: files,
      );

      await _load();

      if (!mounted) return;

      _showMessage('Photographs added to the gallery.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _removePhoto(PortfolioPhoto photo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.ivory,
          title: const Text('REMOVE PHOTOGRAPH'),
          content: Text(
            'Remove "${photo.title}" from this client gallery?\n\n'
            'The master photograph will remain safely in KALLYGRAPHY.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('KEEP'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('REMOVE'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _api.removePhoto(
        session: widget.session,
        galleryId: widget.galleryId,
        photoId: photo.id,
      );

      if (!mounted) return;

      setState(() {
        _photos.removeWhere((item) => item.id == photo.id);
      });

      _showMessage('Photograph removed from the gallery.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    }
  }

  Future<void> _setCover(PortfolioPhoto photo) async {
    if (_gallery?.coverPhotoId == photo.id) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await _api.setCoverPhoto(
        session: widget.session,
        galleryId: widget.galleryId,
        photoId: photo.id,
      );

      if (!mounted) return;

      await _load();

      if (!mounted) return;
      _showMessage('Cover photograph updated.');
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _reorderPhotos(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final updated = List<PortfolioPhoto>.from(_photos);
    final photo = updated.removeAt(oldIndex);
    updated.insert(newIndex, photo);

    setState(() {
      _photos = updated;
      _isSaving = true;
    });

    try {
      await _api.reorderPhotos(
        session: widget.session,
        galleryId: widget.galleryId,
        photos: updated,
      );
    } catch (error) {
      if (!mounted) return;

      _showMessage(error.toString());
      await _load();
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _togglePublished() async {
    final gallery = _gallery;

    if (gallery == null) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final updated = await _api.updateGallery(
        session: widget.session,
        galleryId: gallery.id,
        status: gallery.status == 'published' ? 'draft' : 'published',
      );

      if (!mounted) return;

      setState(() {
        _gallery = updated;
      });

      _showMessage(
        updated.status == 'published'
            ? 'Gallery published.'
            : 'Gallery moved back to draft.',
      );
    } catch (error) {
      if (!mounted) return;
      _showMessage(error.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null || _gallery == null) {
      return _ErrorState(
        message: _error ?? 'Gallery not found.',
        onRetry: _load,
      );
    }

    return ColoredBox(
      color: AppColors.cream,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 760;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 20 : 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1380),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ManagerHeader(
                      gallery: _gallery!,
                      photoCount: _photos.length,
                      isSaving: _isSaving,
                      onPublishToggle: _togglePublished,
                    ),
                    const SizedBox(height: 42),
                    _PhotoSection(
                      photos: _photos,
                      gallery: _gallery!,
                      session: widget.session,
                      isMobile: isMobile,
                      isUploading: _isUploading,
                      onUpload: _uploadPhotos,
                      onRemove: _removePhoto,
                      onSetCover: _setCover,
                      onReorder: _reorderPhotos,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ManagerHeader extends StatelessWidget {
  const _ManagerHeader({
    required this.gallery,
    required this.photoCount,
    required this.isSaving,
    required this.onPublishToggle,
  });

  final Gallery gallery;
  final int photoCount;
  final bool isSaving;
  final VoidCallback onPublishToggle;

  @override
  Widget build(BuildContext context) {
    final published = gallery.status == 'published';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CLIENT GALLERY',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.mocha,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gallery.name.toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppColors.darkBrown,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$photoCount PHOTOGRAPHS · ${gallery.status.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.muted, letterSpacing: 1),
                  ),
                ],
              ),
            ),
            if (MediaQuery.sizeOf(context).width >= 700)
              FilledButton(
                onPressed: isSaving ? null : onPublishToggle,
                child: Text(published ? 'UNPUBLISH' : 'PUBLISH GALLERY'),
              ),
          ],
        ),
        if (MediaQuery.sizeOf(context).width < 700) ...[
          const SizedBox(height: 20),
          FilledButton(
            onPressed: isSaving ? null : onPublishToggle,
            child: Text(published ? 'UNPUBLISH' : 'PUBLISH GALLERY'),
          ),
        ],
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: AppColors.ivory,
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.lock_outline_rounded, color: AppColors.mocha),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'This is a private client gallery. '
                  'Only people with the shared gallery link can view it.',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: AppColors.brown, height: 1.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.darkBrown),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('TRY AGAIN')),
          ],
        ),
      ),
    );
  }
}

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photos,
    required this.gallery,
    required this.session,
    required this.isMobile,
    required this.isUploading,
    required this.onUpload,
    required this.onRemove,
    required this.onSetCover,
    required this.onReorder,
  });

  final List<PortfolioPhoto> photos;
  final Gallery gallery;
  final AuthSession session;
  final bool isMobile;
  final bool isUploading;
  final VoidCallback onUpload;
  final Future<void> Function(PortfolioPhoto photo) onRemove;
  final Future<void> Function(PortfolioPhoto photo) onSetCover;
  final Future<void> Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'PHOTOGRAPHS',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppColors.darkBrown,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: isUploading ? null : onUpload,
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(isUploading ? 'UPLOADING...' : 'ADD PHOTOS'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Drag photographs into the order you want your client to experience them.',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.muted),
        ),
        const SizedBox(height: 26),
        if (photos.isEmpty)
          _EmptyPhotos(onUpload: onUpload)
        else
          ReorderableWrap(
            photos: photos,
            gallery: gallery,
            session: session,
            isMobile: isMobile,
            onRemove: onRemove,
            onSetCover: onSetCover,
            onReorder: onReorder,
          ),
      ],
    );
  }
}

class _EmptyPhotos extends StatelessWidget {
  const _EmptyPhotos({required this.onUpload});

  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 42,
            color: AppColors.muted,
          ),
          const SizedBox(height: 16),
          Text(
            'NO PHOTOGRAPHS YET',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload the photographs you want this client to receive.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: 22),
          OutlinedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.add_photo_alternate_outlined),
            label: const Text('ADD PHOTOS'),
          ),
        ],
      ),
    );
  }
}

class ReorderableWrap extends StatefulWidget {
  const ReorderableWrap({
    super.key,
    required this.photos,
    required this.gallery,
    required this.session,
    required this.isMobile,
    required this.onRemove,
    required this.onSetCover,
    required this.onReorder,
  });

  final List<PortfolioPhoto> photos;
  final Gallery gallery;
  final AuthSession session;
  final bool isMobile;
  final Future<void> Function(PortfolioPhoto photo) onRemove;
  final Future<void> Function(PortfolioPhoto photo) onSetCover;
  final Future<void> Function(int oldIndex, int newIndex) onReorder;

  @override
  State<ReorderableWrap> createState() => _ReorderableWrapState();
}

class _ReorderableWrapState extends State<ReorderableWrap> {
  int? _draggingIndex;
  int? _hoveredIndex;

  void _dropOn(int targetIndex) {
    final oldIndex = _draggingIndex;

    setState(() {
      _draggingIndex = null;
      _hoveredIndex = null;
    });

    if (oldIndex == null || oldIndex == targetIndex) {
      return;
    }

    var newIndex = targetIndex;

    if (oldIndex < targetIndex) {
      newIndex -= 1;
    }

    widget.onReorder(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    final columns = widget.isMobile
        ? 2
        : width >= 1500
        ? 4
        : width >= 1050
        ? 3
        : 2;

    const gap = 16.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth =
            (constraints.maxWidth - (gap * (columns - 1))) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (var index = 0; index < widget.photos.length; index++)
              SizedBox(
                width: cardWidth,
                child: DragTarget<int>(
                  onWillAcceptWithDetails: (details) {
                    if (details.data == index) {
                      return false;
                    }

                    setState(() {
                      _hoveredIndex = index;
                    });

                    return true;
                  },
                  onLeave: (_) {
                    if (_hoveredIndex == index) {
                      setState(() {
                        _hoveredIndex = null;
                      });
                    }
                  },
                  onAcceptWithDetails: (details) {
                    _draggingIndex = details.data;
                    _dropOn(index);
                  },
                  builder: (context, candidateData, rejectedData) {
                    final photo = widget.photos[index];
                    final isCover = widget.gallery.coverPhotoId == photo.id;
                    final isDragging = _draggingIndex == index;
                    final isHovered = _hoveredIndex == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      decoration: BoxDecoration(
                        color: AppColors.ivory,
                        border: Border.all(
                          color: isHovered || isCover
                              ? AppColors.mocha
                              : AppColors.border,
                          width: isHovered || isCover ? 1.5 : 1,
                        ),
                      ),
                      child: Opacity(
                        opacity: isDragging ? 0.35 : 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AspectRatio(
                              aspectRatio: 1,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  _PhotoImage(
                                    photo: photo,
                                    session: widget.session,
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 9,
                                        vertical: 6,
                                      ),
                                      color: AppColors.espresso.withValues(
                                        alpha: 0.88,
                                      ),
                                      child: Text(
                                        '${index + 1}'.padLeft(2, '0'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: AppColors.cream,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.2,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (isCover)
                                    Positioned(
                                      top: 10,
                                      right: 10,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 9,
                                          vertical: 6,
                                        ),
                                        color: AppColors.mocha,
                                        child: Text(
                                          'COVER',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall
                                              ?.copyWith(
                                                color: AppColors.cream,
                                                fontWeight: FontWeight.w800,
                                                letterSpacing: 1.1,
                                              ),
                                        ),
                                      ),
                                    ),
                                  Positioned(
                                    right: 10,
                                    bottom: 10,
                                    child: Draggable<int>(
                                      data: index,
                                      onDragStarted: () {
                                        setState(() {
                                          _draggingIndex = index;
                                        });
                                      },
                                      onDragEnd: (_) {
                                        if (mounted) {
                                          setState(() {
                                            _draggingIndex = null;
                                            _hoveredIndex = null;
                                          });
                                        }
                                      },
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: cardWidth * 0.75,
                                          height: cardWidth * 0.75,
                                          child: Opacity(
                                            opacity: 0.9,
                                            child: _PhotoImage(
                                              photo: photo,
                                              session: widget.session,
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(9),
                                        color: AppColors.espresso.withValues(
                                          alpha: 0.88,
                                        ),
                                        child: const Icon(
                                          Icons.drag_indicator_rounded,
                                          color: AppColors.cream,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                14,
                                14,
                                10,
                                12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      photo.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            color: AppColors.darkBrown,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: isCover
                                        ? 'Cover photo'
                                        : 'Set as cover',
                                    visualDensity: VisualDensity.compact,
                                    onPressed: isCover
                                        ? null
                                        : () => widget.onSetCover(photo),
                                    icon: Icon(
                                      isCover
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      size: 19,
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove photo',
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () => widget.onRemove(photo),
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 19,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _PhotoImage extends StatefulWidget {
  const _PhotoImage({required this.photo, required this.session});

  final PortfolioPhoto photo;
  final AuthSession session;

  @override
  State<_PhotoImage> createState() => _PhotoImageState();
}

class _PhotoImageState extends State<_PhotoImage> {
  Uint8List? _bytes;
  Object? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${widget.photo.previewUrl}'),
        headers: {'Authorization': 'Bearer ${widget.session.accessToken}'},
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Preview request failed with ${response.statusCode}.');
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _bytes = response.bodyBytes;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const ColoredBox(
        color: AppColors.sand,
        child: Center(child: CircularProgressIndicator(color: AppColors.mocha)),
      );
    }

    if (_bytes == null) {
      return ColoredBox(
        color: AppColors.sand,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.broken_image_outlined,
                color: AppColors.brown,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                'PREVIEW UNAVAILABLE',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Tap refresh to try again.',
                  style: Theme.of(context).textTheme.bodySmall
                      ?.copyWith(color: AppColors.muted),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return ColoredBox(
      color: AppColors.sand,
      child: Image.memory(
        _bytes!,
        fit: BoxFit.contain,
        width: double.infinity,
        height: double.infinity,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColors.brown,
              size: 32,
            ),
          );
        },
      ),
    );
  }
}
