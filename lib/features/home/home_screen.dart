import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _logo = 'assets/images/portfolio/KallyGraphy Official Logo.png';

  static const _heroImage = 'assets/images/brand/NYCT.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        primary: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _Hero(),
            _About(),
            _SelectedWork(),
            _Services(),
            _Statement(),
            _Contact(),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        return Container(
          color: AppColors.cream,
          padding: EdgeInsets.fromLTRB(
            isMobile ? 24 : 64,
            isMobile ? 32 : 52,
            isMobile ? 24 : 64,
            isMobile ? 56 : 80,
          ),
          child: isMobile
              ? const _MobileHero()
              : _DesktopHero(maxWidth: constraints.maxWidth),
        );
      },
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero({required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final imageWidth = math.min(440.0, maxWidth * 0.40);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1320),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: _HeroCopy()),
            const SizedBox(width: 64),
            SizedBox(width: imageWidth, child: const _HeroImage()),
          ],
        ),
      ),
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_HeroCopy(), SizedBox(height: 42), _HeroImage()],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          HomeScreen._logo,
          height: 42,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          errorBuilder: (_, __, ___) {
            return const Text(
              'KALLYGRAPHY',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: AppColors.espresso,
              ),
            );
          },
        ),
        const SizedBox(height: 34),
        const Text(
          'PHOTOGRAPHY STUDIO · KAMPALA',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.2,
            color: AppColors.brown,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Stories worth\nremembering.',
          style: TextStyle(
            fontFamily: 'Cormorant Garamond',
            fontSize: 68,
            height: 0.96,
            fontWeight: FontWeight.w400,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 28),
        const SizedBox(
          width: 520,
          child: Text(
            'Photography with feeling, intention and a deep respect '
            'for the moments that become part of our story.',
            style: TextStyle(fontSize: 16, height: 1.8, color: AppColors.muted),
          ),
        ),
        const SizedBox(height: 36),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: [
            _EditorialButton(
              label: 'VIEW THE WORK',
              onPressed: () => context.go('/portfolio'),
            ),
            _EditorialButton(
              label: 'START A CONVERSATION',
              onPressed: () => context.go('/booking'),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Image.asset(
          HomeScreen._heroImage,
          fit: BoxFit.cover,
          alignment: Alignment.center,
          errorBuilder: (_, __, ___) {
            return Container(
              color: AppColors.sand,
              alignment: Alignment.center,
              child: const Text(
                'KALLYGRAPHY',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 3,
                  color: AppColors.espresso,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _About extends StatelessWidget {
  const _About();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 760;

              final title = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ABOUT THE\nPHOTOGRAPHER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.2,
                      color: AppColors.mocha,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Kaliisa Ryan',
                    style: TextStyle(
                      fontFamily: 'Cormorant Garamond',
                      fontSize: 52,
                      height: 1,
                      color: AppColors.ivory,
                    ),
                  ),
                ],
              );

              const copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'I am Kaliisa Ryan — a photographer, videographer and '
                    'graphics designer with a passion for creating visual stories.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.75,
                      color: AppColors.ivory,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'My work is shaped by a strong aesthetic sense, technical '
                    'knowledge of modern camera technologies, attention to detail '
                    'and an understanding of how to bring a creative idea to life.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: AppColors.sand,
                    ),
                  ),
                  SizedBox(height: 22),
                  Text(
                    'From weddings and traditional events to fashion, beauty '
                    'and portrait photography, I focus on creating images that '
                    'feel intentional, expressive and memorable.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.8,
                      color: AppColors.sand,
                    ),
                  ),
                ],
              );

              if (isMobile) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [title, const SizedBox(height: 48), copy],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: title),
                  SizedBox(width: 80),
                  Expanded(flex: 6, child: copy),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SelectedWork extends StatelessWidget {
  const _SelectedWork();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ivory,
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECTED WORK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'A collection of moments.',
                style: TextStyle(
                  fontFamily: 'Cormorant Garamond',
                  fontSize: 52,
                  height: 1,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 44),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth >= 950
                      ? 3
                      : constraints.maxWidth >= 600
                      ? 2
                      : 1;

                  final gap = columns == 1 ? 0.0 : 18.0;
                  final width =
                      (constraints.maxWidth - gap * (columns - 1)) / columns;

                  return Wrap(
                    spacing: gap,
                    runSpacing: 18,
                    children: List.generate(
                      _HomeImages._photos.length,
                      (index) => SizedBox(
                        width: width,
                        child: _WorkCard(
                          image: _HomeImages._photos[index],
                          index: index,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeImages {
  static const _photos = [
    'assets/images/brand/wedding_bride_microphone.jpg',
    'assets/images/portfolio/portrait_man_hat.jpg',
    'assets/images/portfolio/couple_wedding.jpg',
    'assets/images/portfolio/portrait_woman_close.jpg',
    'assets/images/portfolio/wedding_bouquet.jpg',
    'assets/images/portfolio/lake_boat.jpg',
  ];
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.image, required this.index});

  final String image;
  final int index;

  static const labels = [
    'Weddings',
    'Portraits',
    'Couples',
    'Portraits',
    'Details',
    'Editorial',
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(image, fit: BoxFit.cover),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Color(0xB5000000)],
                  ),
                ),
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.6,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Services extends StatelessWidget {
  const _Services();

  @override
  Widget build(BuildContext context) {
    const services = [
      ('01', 'WEDDINGS', 'Honest, emotional coverage of your day.'),
      ('02', 'PORTRAITS', 'Images that feel like you, not a pose.'),
      (
        '03',
        'FASHION & BEAUTY',
        'Editorial imagery with character and detail.',
      ),
      ('04', 'EVENTS', 'The atmosphere, people and moments in between.'),
    ];

    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WHAT I PHOTOGRAPH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 32),
              ...services.map(
                (service) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.border, width: 0.7),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 54,
                        child: Text(
                          service.$1,
                          style: const TextStyle(
                            fontSize: 11,
                            letterSpacing: 1.5,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.$2,
                              style: const TextStyle(
                                fontFamily: 'Cormorant Garamond',
                                fontSize: 31,
                                color: AppColors.espresso,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              service.$3,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.5,
                                color: AppColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1, color: AppColors.border),
            ],
          ),
        ),
      ),
    );
  }
}

class _Statement extends StatelessWidget {
  const _Statement();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: const Text(
            '“The photographs we keep are more than images. '
            'They become places we can return to.”',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cormorant Garamond',
              fontSize: 42,
              height: 1.15,
              color: AppColors.espresso,
            ),
          ),
        ),
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(24, 90, 24, 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'LET’S CREATE SOMETHING MEANINGFUL.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2.2,
                  color: AppColors.mocha,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Have a story to tell?',
                style: TextStyle(
                  fontFamily: 'Cormorant Garamond',
                  fontSize: 58,
                  height: 1,
                  color: AppColors.ivory,
                ),
              ),
              const SizedBox(height: 28),
              const SizedBox(
                width: 600,
                child: Text(
                  'Tell me what you are planning, what you want to remember, '
                  'and how you want it to feel.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _EditorialButton(
                    label: 'START A CONVERSATION',
                    onPressed: () => context.go('/booking'),
                  ),
                  _EditorialButton(
                    label: 'PHOTOGRAPHER STUDIO →',
                    onPressed: () => context.go('/studio'),
                  ),
                ],
              ),
              const SizedBox(height: 90),
              const Divider(color: AppColors.darkBrown, height: 1),
              const SizedBox(height: 28),
              Row(
                children: [
                  Image.asset(
                    HomeScreen._logo,
                    height: 30,
                    errorBuilder: (_, __, ___) {
                      return const Text(
                        'KALLYGRAPHY',
                        style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 2,
                          color: AppColors.ivory,
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  const Text(
                    'KAMPALA · UGANDA  © 2026 KALLYGRAPHY',
                    style: TextStyle(
                      fontSize: 9,
                      letterSpacing: 1.1,
                      color: AppColors.muted,
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

class _EditorialButton extends StatelessWidget {
  const _EditorialButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    const color = AppColors.espresso;

    return InkWell(
      onTap: onPressed,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.7,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '→',
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w300,
                height: 0.8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
