import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../services/api/gallery_api_service.dart';
import '../../services/auth/auth_session.dart';

class StudioGalleriesScreen extends StatefulWidget {
  const StudioGalleriesScreen({super.key, required this.session});

  final AuthSession session;

  @override
  State<StudioGalleriesScreen> createState() => _StudioGalleriesScreenState();
}

class _StudioGalleriesScreenState extends State<StudioGalleriesScreen> {
  final GalleryApiService _api = GalleryApiService();

  late Future<List<GallerySummary>> _galleriesFuture;

  int? _uploadingGalleryId;
  bool _creatingGallery = false;
  int _selectedFilter = 0;

  static const _filters = ['ALL', 'PUBLISHED', 'DRAFT'];

  @override
  void initState() {
    super.initState();
    _loadGalleries();
  }

  void _loadGalleries() {
    _galleriesFuture = _api.fetchGalleries(session: widget.session);
  }

  Future<void> _refresh() async {
    setState(_loadGalleries);
    await _galleriesFuture;
  }

  List<GallerySummary> _filteredGalleries(List<GallerySummary> galleries) {
    switch (_selectedFilter) {
      case 1:
        return galleries
            .where((gallery) => gallery.status == 'published')
            .toList();
      case 2:
        return galleries.where((gallery) => gallery.status == 'draft').toList();
      default:
        return galleries;
    }
  }

  Future<void> _pickPhotos(GallerySummary gallery) async {
    if (_uploadingGalleryId != null) {
      return;
    }

    final files = await FilePicker.pickFiles(type: FileType.image);

    if (files.isEmpty || !mounted) {
      return;
    }

    setState(() {
      _uploadingGalleryId = gallery.id;
    });

    try {
      final uploaded = await _api.uploadPhotos(
        session: widget.session,
        galleryId: gallery.id,
        files: files,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${uploaded.length} photo${uploaded.length == 1 ? '' : 's'} uploaded to ${gallery.name}.',
          ),
        ),
      );

      await _refresh();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Upload failed: $error')));
    } finally {
      if (mounted) {
        setState(() {
          _uploadingGalleryId = null;
        });
      }
    }
  }

  Future<void> _createGallery() async {
    if (_creatingGallery) {
      return;
    }

    final result = await showDialog<_NewGalleryData>(
      context: context,
      builder: (context) => const _NewGalleryDialog(),
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      _creatingGallery = true;
    });

    try {
      final client = await _api.createClient(
        session: widget.session,
        fullName: result.clientName,
        email: result.clientEmail,
        phone: result.clientPhone,
      );

      await _api.createGallery(
        session: widget.session,
        clientId: client.id,
        name: result.galleryName,
        slug: _slugify(result.galleryName),
        description: result.description,
        status: 'draft',
        isDownloadEnabled: result.downloadsEnabled,
        isFavoritesEnabled: result.favoritesEnabled,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New client gallery created.')),
      );

      await _refresh();
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create gallery: $error')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _creatingGallery = false;
        });
      }
    }
  }

  String _slugify(String value) {
    return value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  Future<void> _showShareLink(GallerySummary gallery) async {
    try {
      final token = await _api.createShareLink(
        session: widget.session,
        galleryId: gallery.id,
      );

      if (!mounted) {
        return;
      }

      final uri = Uri.base.replace(
        path: '/client-gallery/$token',
        queryParameters: const {},
        fragment: '',
      );

      await showDialog<void>(
        context: context,
        builder: (context) {
          return _ShareLinkDialog(url: uri.toString());
        },
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not create share link: $error')),
      );
    }
  }

  Future<void> _revokeShareLink(GallerySummary gallery) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.ivory,
        title: const Text('Revoke client link?'),
        content: const Text(
          'Anyone using the current private gallery link will lose access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('REVOKE'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    try {
      await _api.revokeShareLink(
        session: widget.session,
        galleryId: gallery.id,
      );

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Client gallery link revoked.')),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not revoke link: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.ivory,
      child: RefreshIndicator(
        color: AppColors.mocha,
        onRefresh: _refresh,
        child: FutureBuilder<List<GallerySummary>>(
          future: _galleriesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.mocha),
              );
            }

            if (snapshot.hasError) {
              return _ErrorState(
                message: snapshot.error.toString(),
                onRetry: () {
                  setState(_loadGalleries);
                },
              );
            }

            final galleries = snapshot.data ?? const [];
            final filtered = _filteredGalleries(galleries);

            final published = galleries
                .where((gallery) => gallery.status == 'published')
                .length;

            final drafts = galleries
                .where((gallery) => gallery.status == 'draft')
                .length;

            return CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _PageHeader(
                    galleryCount: galleries.length,
                    creating: _creatingGallery,
                    onCreate: _createGallery,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _StatsStrip(
                    total: galleries.length,
                    published: published,
                    drafts: drafts,
                  ),
                ),
                SliverToBoxAdapter(
                  child: _FilterBar(
                    selected: _selectedFilter,
                    onChanged: (index) {
                      setState(() {
                        _selectedFilter = index;
                      });
                    },
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl,
                      8,
                      AppSpacing.xl,
                      64,
                    ),
                    sliver: SliverList.builder(
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final gallery = filtered[index];

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 22),
                          child: _GalleryCard(
                            gallery: gallery,
                            uploading: _uploadingGalleryId == gallery.id,
                            onUpload: () => _pickPhotos(gallery),
                            onShare: gallery.status == 'published'
                                ? () => _showShareLink(gallery)
                                : null,
                            onRevoke: gallery.status == 'published'
                                ? () => _revokeShareLink(gallery)
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.galleryCount,
    required this.creating,
    required this.onCreate,
  });

  final int galleryCount;
  final bool creating;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 34, AppSpacing.xl, 26),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;

          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CLIENT GALLERIES',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.mocha,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your private galleries.',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.espresso,
                  fontSize: compact ? 32 : 42,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create, organise and deliver finished galleries to your clients.',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted, height: 1.5),
              ),
              const SizedBox(height: 12),
              Text(
                '$galleryCount ${galleryCount == 1 ? 'GALLERY' : 'GALLERIES'}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.brown,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
            ],
          );

          final button = FilledButton.icon(
            onPressed: creating ? null : onCreate,
            icon: creating
                ? const SizedBox(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add, size: 18),
            label: const Text('NEW GALLERY'),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 22), button],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: copy),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  const _StatsStrip({
    required this.total,
    required this.published,
    required this.drafts,
  });

  final int total;
  final int published;
  final int drafts;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('TOTAL', '$total'),
      ('PUBLISHED', '$published'),
      ('DRAFTS', '$drafts'),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.mocha,
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 620;

            return Flex(
              direction: compact ? Axis.vertical : Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var index = 0; index < stats.length; index++) ...[
                  if (compact && index > 0) const SizedBox(height: 14),
                  if (!compact && index > 0) const SizedBox(width: 42),
                  Expanded(
                    flex: compact ? 0 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats[index].$2,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppColors.ivory,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          stats[index].$1,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.cream,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, 26, AppSpacing.xl, 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (
            var index = 0;
            index < _StudioGalleriesScreenState._filters.length;
            index++
          )
            ChoiceChip(
              label: Text(_StudioGalleriesScreenState._filters[index]),
              selected: selected == index,
              onSelected: (_) => onChanged(index),
              selectedColor: AppColors.espresso,
              backgroundColor: AppColors.cream,
              labelStyle: TextStyle(
                color: selected == index ? AppColors.ivory : AppColors.brown,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
                fontSize: 11,
              ),
              side: BorderSide(color: AppColors.border.withValues(alpha: 0.6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.gallery,
    required this.uploading,
    required this.onUpload,
    required this.onShare,
    required this.onRevoke,
  });

  final GallerySummary gallery;
  final bool uploading;
  final VoidCallback onUpload;
  final VoidCallback? onShare;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final published = gallery.status == 'published';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.65)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 760;

            final details = _GalleryDetails(
              gallery: gallery,
              published: published,
            );

            final actions = _GalleryActions(
              galleryId: gallery.id,
              uploading: uploading,
              published: published,
              onUpload: onUpload,
              onShare: onShare,
              onRevoke: onRevoke,
            );

            if (compact) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [details, const SizedBox(height: 22), actions],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: 32),
                SizedBox(width: 330, child: actions),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _GalleryDetails extends StatelessWidget {
  const _GalleryDetails({required this.gallery, required this.published});

  final GallerySummary gallery;
  final bool published;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: published ? AppColors.mocha : AppColors.sand,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                published ? 'PUBLISHED' : 'DRAFT',
                style: TextStyle(
                  color: published ? AppColors.ivory : AppColors.espresso,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.3,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${gallery.photoCount} ${gallery.photoCount == 1 ? 'PHOTOGRAPH' : 'PHOTOGRAPHS'}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text(
          gallery.name,
          style: Theme.of(context).textTheme.headlineMedium
              ?.copyWith(color: AppColors.espresso, fontSize: 30),
        ),
        const SizedBox(height: 7),
        Text(
          gallery.clientName,
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: AppColors.brown, fontWeight: FontWeight.w600),
        ),
        if (gallery.description != null && gallery.description!.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(
            gallery.description!,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: AppColors.muted, height: 1.55),
          ),
        ],
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _MetaPill(
              label: gallery.isDownloadEnabled
                  ? 'DOWNLOADS ON'
                  : 'DOWNLOADS OFF',
            ),
            _MetaPill(
              label: gallery.isFavoritesEnabled
                  ? 'FAVORITES ON'
                  : 'FAVORITES OFF',
            ),
          ],
        ),
      ],
    );
  }
}

class _GalleryActions extends StatelessWidget {
  const _GalleryActions({
    required this.galleryId,
    required this.uploading,
    required this.published,
    required this.onUpload,
    required this.onShare,
    required this.onRevoke,
  });

  final int galleryId;
  final bool uploading;
  final bool published;
  final VoidCallback onUpload;
  final VoidCallback? onShare;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: uploading ? null : onUpload,
          icon: uploading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.add_photo_alternate_outlined, size: 18),
          label: Text(uploading ? 'UPLOADING…' : 'UPLOAD PHOTOS'),
        ),
        const SizedBox(height: 10),
        if (published && onShare != null)
          FilledButton.icon(
            onPressed: onShare,
            icon: const Icon(Icons.link, size: 18),
            label: const Text('CREATE CLIENT LINK'),
          ),
        if (published && onShare != null) const SizedBox(height: 10),
        if (published && onRevoke != null)
          TextButton.icon(
            onPressed: onRevoke,
            icon: const Icon(Icons.link_off, size: 17),
            label: const Text('REVOKE CLIENT LINK'),
          ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () => context.go('/studio/galleries/$galleryId'),
          icon: const Icon(Icons.tune_rounded, size: 17),
          label: const Text('MANAGE GALLERY'),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.muted,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

class _NewGalleryData {
  const _NewGalleryData({
    required this.galleryName,
    required this.clientName,
    this.clientEmail,
    this.clientPhone,
    this.description,
    required this.downloadsEnabled,
    required this.favoritesEnabled,
  });

  final String galleryName;
  final String clientName;
  final String? clientEmail;
  final String? clientPhone;
  final String? description;
  final bool downloadsEnabled;
  final bool favoritesEnabled;
}

class _NewGalleryDialog extends StatefulWidget {
  const _NewGalleryDialog();

  @override
  State<_NewGalleryDialog> createState() => _NewGalleryDialogState();
}

class _NewGalleryDialogState extends State<_NewGalleryDialog> {
  final _formKey = GlobalKey<FormState>();

  final _galleryController = TextEditingController();
  final _clientController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _downloadsEnabled = true;
  bool _favoritesEnabled = true;

  @override
  void dispose() {
    _galleryController.dispose();
    _clientController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    Navigator.of(context).pop(
      _NewGalleryData(
        galleryName: _galleryController.text,
        clientName: _clientController.text,
        clientEmail: _emailController.text,
        clientPhone: _phoneController.text,
        description: _descriptionController.text,
        downloadsEnabled: _downloadsEnabled,
        favoritesEnabled: _favoritesEnabled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.ivory,
      title: Text(
        'NEW CLIENT GALLERY',
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: AppColors.espresso, letterSpacing: 1.4),
      ),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Field(
                  controller: _galleryController,
                  label: 'GALLERY NAME',
                  hint: 'e.g. Sarah & Daniel',
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter a gallery name.'
                      : null,
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _clientController,
                  label: 'CLIENT NAME',
                  hint: 'e.g. Sarah Namukasa',
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Enter the client name.'
                      : null,
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _emailController,
                  label: 'EMAIL',
                  hint: 'Optional',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _phoneController,
                  label: 'PHONE',
                  hint: 'Optional',
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 14),
                _Field(
                  controller: _descriptionController,
                  label: 'DESCRIPTION',
                  hint: 'Optional',
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('CLIENT DOWNLOADS'),
                  value: _downloadsEnabled,
                  activeThumbColor: AppColors.mocha,
                  onChanged: (value) {
                    setState(() {
                      _downloadsEnabled = value;
                    });
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('CLIENT FAVORITES'),
                  value: _favoritesEnabled,
                  activeThumbColor: AppColors.mocha,
                  onChanged: (value) {
                    setState(() {
                      _favoritesEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
        FilledButton(onPressed: _submit, child: const Text('CREATE GALLERY')),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}

class _ShareLinkDialog extends StatelessWidget {
  const _ShareLinkDialog({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.ivory,
      title: Text(
        'CLIENT LINK READY',
        style: Theme.of(context).textTheme.titleLarge
            ?.copyWith(color: AppColors.espresso, letterSpacing: 1.4),
      ),
      content: SelectableText(
        url,
        style: Theme.of(context).textTheme.bodyMedium
            ?.copyWith(color: AppColors.brown, height: 1.5),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('DONE'),
        ),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 46,
              color: AppColors.brown,
            ),
            const SizedBox(height: 20),
            Text(
              'NO GALLERIES YET.',
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(color: AppColors.espresso),
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first private client gallery and begin preparing the collection.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: AppColors.muted, height: 1.5),
            ),
          ],
        ),
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
        padding: const EdgeInsets.all(40),
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
              'COULD NOT LOAD GALLERIES',
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: AppColors.espresso),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: AppColors.muted),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('TRY AGAIN')),
          ],
        ),
      ),
    );
  }
}
