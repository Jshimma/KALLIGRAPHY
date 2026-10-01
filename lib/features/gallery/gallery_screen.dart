import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  static const _portrait = 'assets/images/portfolio/portrait_woman.jpg';
  static const _portraitClose =
      'assets/images/portfolio/portrait_woman_close.jpg';
  static const _man = 'assets/images/portfolio/portrait_man.jpg';
  static const _wedding = 'assets/images/portfolio/couple_wedding.jpg';
  static const _rings = 'assets/images/portfolio/wedding_rings.jpg';
  static const _bouquet = 'assets/images/portfolio/wedding_bouquet.jpg';
  static const _lake = 'assets/images/portfolio/lake_boat.jpg';
  static const _landscape = 'assets/images/portfolio/woman_landscape.jpg';
  static const _sunset = 'assets/images/portfolio/sunset_lake.jpg';
  static const _details = 'assets/images/portfolio/hands_detail.jpg';
  static const _door = 'assets/images/portfolio/architecture_door.jpg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _GalleryHero(),
          _GalleryNavigation(),
          _PortraitGallery(),
          _WeddingGallery(),
          _PlacesGallery(),
          _DetailsGallery(),
          _GalleryClosing(),
        ],
      ),
    );
  }
}

class _GalleryHero extends StatelessWidget {
  const _GalleryHero();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;

    return SizedBox(
      height: mobile ? 720 : 820,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GalleryScreen._portraitClose, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.espresso.withValues(alpha: 0.18),
                  Colors.transparent,
                  AppColors.espresso.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            right: 28,
            bottom: 42,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '04 / THE GALLERIES',
                  style: TextStyle(
                    color: AppColors.cream.withValues(alpha: 0.8),
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'A collection\nof moments.',
                  style: TextStyle(
                    color: AppColors.ivory,
                    fontFamily: 'CormorantGaramond',
                    fontSize: mobile ? 62 : 90,
                    height: 0.9,
                  ),
                ),
                const SizedBox(height: 25),
                Text(
                  'PORTRAITS · WEDDINGS · PLACES · DETAILS',
                  style: TextStyle(
                    color: AppColors.cream.withValues(alpha: 0.75),
                    fontSize: 9,
                    letterSpacing: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GalleryNavigation extends StatelessWidget {
  const _GalleryNavigation();

  static const _categories = [
    'ALL',
    'PORTRAITS',
    'WEDDINGS',
    'PLACES',
    'DETAILS',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 34, 28, 34),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (var i = 0; i < _categories.length; i++) ...[
                _CategoryPill(label: _categories[i], active: i == 0),
                if (i != _categories.length - 1) const SizedBox(width: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label, required this.active});

  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
      decoration: BoxDecoration(
        color: active ? AppColors.espresso : AppColors.sand,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: active ? AppColors.ivory : AppColors.brown,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _PortraitGallery extends StatelessWidget {
  const _PortraitGallery();

  @override
  Widget build(BuildContext context) {
    return _GallerySection(
      number: '01',
      title: 'PORTRAITS',
      subtitle: 'People, presence and quiet confidence.',
      background: AppColors.cream,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          if (!wide) {
            return Column(
              children: [
                _GalleryImage(image: GalleryScreen._portrait, height: 500),
                const SizedBox(height: 18),
                _GalleryImage(image: GalleryScreen._man, height: 360),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _GalleryImage(
                  image: GalleryScreen._portrait,
                  height: 650,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: _GalleryImage(image: GalleryScreen._man, height: 430),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WeddingGallery extends StatelessWidget {
  const _WeddingGallery();

  @override
  Widget build(BuildContext context) {
    return _GallerySection(
      number: '02',
      title: 'WEDDINGS',
      subtitle: 'The people, the details, the beginning of forever.',
      background: AppColors.brown,
      light: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          if (!wide) {
            return Column(
              children: [
                _GalleryImage(image: GalleryScreen._wedding, height: 520),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: _GalleryImage(
                        image: GalleryScreen._rings,
                        height: 260,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _GalleryImage(
                        image: GalleryScreen._bouquet,
                        height: 260,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: _GalleryImage(
                  image: GalleryScreen._wedding,
                  height: 650,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      _GalleryImage(image: GalleryScreen._rings, height: 260),
                      const SizedBox(height: 24),
                      _GalleryImage(image: GalleryScreen._bouquet, height: 260),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PlacesGallery extends StatelessWidget {
  const _PlacesGallery();

  @override
  Widget build(BuildContext context) {
    return _GallerySection(
      number: '03',
      title: 'PLACES',
      subtitle: 'Light, landscape and the spaces between.',
      background: AppColors.cream,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          if (!wide) {
            return Column(
              children: [
                _GalleryImage(image: GalleryScreen._lake, height: 430),
                const SizedBox(height: 18),
                _GalleryImage(image: GalleryScreen._sunset, height: 350),
                const SizedBox(height: 18),
                _GalleryImage(image: GalleryScreen._landscape, height: 430),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: _GalleryImage(
                    image: GalleryScreen._landscape,
                    height: 500,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    _GalleryImage(image: GalleryScreen._lake, height: 570),
                    const SizedBox(height: 24),
                    _GalleryImage(image: GalleryScreen._sunset, height: 350),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsGallery extends StatelessWidget {
  const _DetailsGallery();

  @override
  Widget build(BuildContext context) {
    return _GallerySection(
      number: '04',
      title: 'DETAILS',
      subtitle: 'The small things that become part of the story.',
      background: AppColors.sand,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          if (!wide) {
            return Column(
              children: [
                _GalleryImage(image: GalleryScreen._details, height: 420),
                const SizedBox(height: 18),
                _GalleryImage(image: GalleryScreen._door, height: 360),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _GalleryImage(
                  image: GalleryScreen._details,
                  height: 480,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: _GalleryImage(image: GalleryScreen._door, height: 430),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.background,
    required this.child,
    this.light = false,
  });

  final String number;
  final String title;
  final String subtitle;
  final Color background;
  final Widget child;
  final bool light;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      padding: const EdgeInsets.fromLTRB(28, 95, 28, 115),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$number /',
                    style: TextStyle(
                      color: light
                          ? AppColors.cream.withValues(alpha: 0.65)
                          : AppColors.mocha,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: TextStyle(
                      color: light ? AppColors.ivory : AppColors.espresso,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Flexible(
                    child: Text(
                      subtitle,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: light
                            ? AppColors.cream.withValues(alpha: 0.65)
                            : AppColors.brown,
                        fontSize: 11,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 38),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryImage extends StatefulWidget {
  const _GalleryImage({required this.image, required this.height});

  final String image;
  final double height;

  @override
  State<_GalleryImage> createState() => _GalleryImageState();
}

class _GalleryImageState extends State<_GalleryImage> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -7 : 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: double.infinity,
            height: widget.height,
            child: AnimatedScale(
              scale: _hovered ? 1.025 : 1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              child: Image.asset(widget.image, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }
}

class _GalleryClosing extends StatelessWidget {
  const _GalleryClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 120, 28, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'YOUR STORY\nDESERVES\nA GALLERY.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'CormorantGaramond',
                  fontSize: MediaQuery.sizeOf(context).width < 700 ? 58 : 84,
                  height: 0.88,
                ),
              ),
              const SizedBox(height: 45),
              InkWell(
                onTap: () => context.go('/booking'),
                borderRadius: BorderRadius.circular(999),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.beige,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'BOOK YOUR SESSION  →',
                    style: TextStyle(
                      color: AppColors.espresso,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Row(
                children: [
                  Text(
                    'KALLYGRAPHY',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.65),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'KAMPALA · UGANDA',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.45),
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
