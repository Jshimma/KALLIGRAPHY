import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../core/constants/app_colors.dart';
import '../../services/api/api_config.dart';
import '../../services/api/gallery_api_service.dart';

class ClientGalleryScreen extends StatefulWidget {
  const ClientGalleryScreen({super.key, required this.token});

  final String token;

  @override
  State<ClientGalleryScreen> createState() => _ClientGalleryScreenState();
}

class _ClientGalleryScreenState extends State<ClientGalleryScreen> {
  final GalleryApiService _api = GalleryApiService();

  late Future<PublicGallery> _galleryFuture;

  @override
  void initState() {
    super.initState();
    _galleryFuture = _api.fetchPublicGallery(token: widget.token);
  }

  String _imageUrl(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return path;
    }

    return '${ApiConfig.baseUrl}$path';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: FutureBuilder<PublicGallery>(
        future: _galleryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const _LoadingState();
          }

          if (snapshot.hasError) {
            final error = snapshot.error.toString();

            final expired = error.contains('expired');

            return _UnavailableState(
              title: expired ? 'GALLERY EXPIRED.' : 'GALLERY UNAVAILABLE.',
              message: expired
                  ? 'This private gallery link is no longer active.'
                  : 'This gallery could not be opened. Please contact KALLYGRAPHY STUDIO.',
            );
          }

          final gallery = snapshot.data;

          if (gallery == null) {
            return const _UnavailableState(
              title: 'GALLERY UNAVAILABLE.',
              message: 'This private gallery could not be opened. Please contact KALLYGRAPHY STUDIO.',
            );
          }

          return _GalleryContent(
            gallery: gallery,
            imageUrl: _imageUrl,
            token: widget.token,
          );
        },
      ),
    );
  }
}

class _GalleryContent extends StatelessWidget {
  const _GalleryContent({
    required this.gallery,
    required this.imageUrl,
    required this.token,
  });

  final PublicGallery gallery;
  final String Function(String) imageUrl;
  final String token;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _GalleryHero(gallery: gallery)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 70),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.crossAxisExtent;
              final columns = width >= 1200
                  ? 4
                  : width >= 800
                  ? 3
                  : width >= 520
                  ? 2
                  : 1;

              return SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final photo = gallery.photos[index];

                  return _ClientPhoto(
                    photo: photo,
                    url: imageUrl(photo.previewUrl),
                    token: token,
                    onTap: () {
                      _showLightbox(
                        context,
                        gallery.photos,
                        index,
                        imageUrl,
                        token,
                      );
                    },
                  );
                }, childCount: gallery.photos.length),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
              );
            },
          ),
        ),
        const SliverToBoxAdapter(child: _GalleryFooter()),
      ],
    );
  }

  void _showLightbox(
    BuildContext context,
    List<PublicGalleryPhoto> photos,
    int initialIndex,
    String Function(String) imageUrl,
    String token,
  ) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      builder: (_) => _ClientLightbox(
        photos: photos,
        initialIndex: initialIndex,
        imageUrl: imageUrl,
        token: token,
      ),
    );
  }
}

class _GalleryHero extends StatelessWidget {
  const _GalleryHero({required this.gallery});

  final PublicGallery gallery;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 54),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'KALLYGRAPHY STUDIO',
                style: TextStyle(
                  color: AppColors.sand,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                ),
              ),
              const SizedBox(height: 42),
              const Text(
                'YOUR PHOTOGRAPHS.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'Cormorant Garamond',
                  fontSize: 48,
                  height: 0.95,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                gallery.name.toUpperCase(),
                style: const TextStyle(
                  color: AppColors.mocha,
                  fontFamily: 'Cormorant Garamond',
                  fontSize: 48,
                  height: 0.95,
                  letterSpacing: 1.2,
                ),
              ),
              if (gallery.description != null) ...[
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Text(
                    gallery.description!,
                    style: const TextStyle(
                      color: AppColors.sand,
                      fontSize: 14,
                      height: 1.7,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              Row(
                children: [
                  _Meta(value: '${gallery.photoCount}', label: 'PHOTOGRAPHS'),
                  if (gallery.isDownloadEnabled) ...[
                    const SizedBox(width: 30),
                    const _Meta(value: 'ON', label: 'DOWNLOADS'),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.ivory,
            fontFamily: 'Cormorant Garamond',
            fontSize: 25,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.sand,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
      ],
    );
  }
}

class _ClientPhoto extends StatelessWidget {
  const _ClientPhoto({
    required this.photo,
    required this.url,
    required this.token,
    required this.onTap,
  });

  final PublicGalleryPhoto photo;
  final String url;
  final String token;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: AppColors.sand,
        child: _PublicImage(url: url, token: token),
      ),
    );
  }
}

class _PublicImage extends StatefulWidget {
  const _PublicImage({required this.url, required this.token});

  final String url;
  final String token;

  @override
  State<_PublicImage> createState() => _PublicImageState();
}

class _PublicImageState extends State<_PublicImage> {
  late Future<Uint8List> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Uint8List> _load() async {
    final response = await http.get(
      Uri.parse(widget.url),
      headers: const {'Accept': 'image/jpeg'},
    );

    if (response.statusCode != 200) {
      throw Exception('Photo unavailable.');
    }

    return response.bodyBytes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.contain,
            gaplessPlayback: true,
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Icon(Icons.broken_image_outlined, color: AppColors.muted),
          );
        }

        return const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 1.4,
              color: AppColors.brown,
            ),
          ),
        );
      },
    );
  }
}

class _ClientLightbox extends StatefulWidget {
  const _ClientLightbox({
    required this.photos,
    required this.initialIndex,
    required this.imageUrl,
    required this.token,
  });

  final List<PublicGalleryPhoto> photos;
  final int initialIndex;
  final String Function(String) imageUrl;
  final String token;

  @override
  State<_ClientLightbox> createState() => _ClientLightboxState();
}

class _ClientLightboxState extends State<_ClientLightbox> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 0.9,
            child: PageView.builder(
              controller: _controller,
              itemCount: widget.photos.length,
              itemBuilder: (context, index) {
                return Center(
                  child: InteractiveViewer(
                    child: _PublicImage(
                      url: widget.imageUrl(widget.photos[index].previewUrl),
                      token: widget.token,
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: AppColors.ivory),
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryFooter extends StatelessWidget {
  const _GalleryFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 70, 28, 80),
      child: Center(
        child: Column(
          children: [
            const Text(
              'KALLYGRAPHY',
              style: TextStyle(
                color: AppColors.ivory,
                fontFamily: 'Cormorant Garamond',
                fontSize: 30,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'PHOTOGRAPHS THAT FEEL LIKE MEMORY.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.sand,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.8,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'PRIVATE CLIENT GALLERY',
              style: TextStyle(
                color: AppColors.mocha,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.espresso,
      child: Center(child: CircularProgressIndicator(color: AppColors.sand)),
    );
  }
}

class _UnavailableState extends StatelessWidget {
  const _UnavailableState({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.espresso,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KALLYGRAPHY STUDIO',
                  style: TextStyle(
                    color: AppColors.sand,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.2,
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.ivory,
                    fontFamily: 'Cormorant Garamond',
                    fontSize: 42,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.sand,
                    fontSize: 14,
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
