import 'package:file_picker/file_picker.dart';
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

class _PhotoSection extends StatelessWidget {
  const _PhotoSection({
    required this.photos,
    required this.gallery,
    required this.isMobile,
    required this.isUploading,
    required this.onUpload,
    required this.onRemove,
    required this.onSetCover,
    required this.onReorder,
  });

  final List<PortfolioPhoto> photos;
  final Gallery gallery;
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
            isMobile: isMobile,
            onRemove: onRemove,
            onSetCover: onSetCover,
            onReorder: onReorder,
          ),
      ],
    );
  }
}

class ReorderableWrap extends StatelessWidget {
  const ReorderableWrap({
    super.key,
    required this.photos,
    required this.gallery,
    required this.isMobile,
    required this.onRemove,
    required this.onSetCover,
    required this.onReorder,
  });

  final List<PortfolioPhoto> photos;
  final Gallery gallery;
  final bool isMobile;
  final Future<void> Function(PortfolioPhoto photo) onRemove;
  final Future<void> Function(PortfolioPhoto photo) onSetCover;
  final Future<void> Function(int oldIndex, int newIndex) onReorder;

  @override
  Widget build(BuildContext context) {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: photos.length,
      onReorder: onReorder,
      itemBuilder: (context, index) {
        final photo = photos[index];
        final isCover = gallery.coverPhotoId == photo.id;

        return Container(
          key: ValueKey(photo.id),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.ivory,
            border: Border.all(
              color: isCover ? AppColors.mocha : AppColors.border,
              width: isCover ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              ReorderableDragStartListener(
                index: index,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.drag_indicator_rounded,
                    color: AppColors.muted,
                  ),
                ),
              ),
              SizedBox(
                width: isMobile ? 90 : 140,
                height: isMobile ? 90 : 110,
                child: _PhotoImage(photo: photo),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isCover)
                      Text(
                        'COVER PHOTOGRAPH',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.mocha,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.4,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Text(
                      photo.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkBrown,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'POSITION ${index + 1}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.muted,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isMobile)
                TextButton(
                  onPressed: isCover ? null : () => onSetCover(photo),
                  child: const Text('SET COVER'),
                ),
              IconButton(
                tooltip: 'Remove',
                onPressed: () => onRemove(photo),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PhotoImage extends StatelessWidget {
  const _PhotoImage({required this.photo});

  final PortfolioPhoto photo;

  @override
  Widget build(BuildContext context) {
    final url = photo.previewUrl;

    if (url == null || url.isEmpty) {
      return const ColoredBox(
        color: AppColors.sand,
        child: Icon(Icons.image_not_supported_outlined, color: AppColors.brown),
      );
    }

    return ColoredBox(
      color: AppColors.sand,
      child: Image.network(
        '${ApiConfig.baseUrl}$url',
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) =>
            const Icon(Icons.broken_image_outlined, color: AppColors.brown),
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 70),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.photo_library_outlined,
            size: 42,
            color: AppColors.mocha,
          ),
          const SizedBox(height: 18),
          Text(
            'THIS GALLERY IS WAITING FOR ITS PHOTOGRAPHS.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.darkBrown,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: onUpload,
            child: const Text('ADD PHOTOGRAPHS'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

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
              size: 42,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'WE COULD NOT LOAD THIS GALLERY.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.darkBrown,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('TRY AGAIN')),
          ],
        ),
      ),
    );
  }
}
