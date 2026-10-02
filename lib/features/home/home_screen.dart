import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _ryanPortrait = 'assets/images/brand/NYCT.jpg';

  static const _selectedWork = [
    (
      image: 'assets/images/ryan/Wedding.jpg',
      title: 'WEDDINGS',
      subtitle: 'Stories worth remembering.',
    ),
    (
      image: 'assets/images/ryan/photoshoot.jpg',
      title: 'PHOTOSHOOTS',
      subtitle: 'In their element.',
    ),
    (
      image: 'assets/images/ryan/Moments.jpg',
      title: 'MOMENTS',
      subtitle: 'Life, as it felt.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _RyanHero(onViewWork: () => context.go('/portfolio')),
            _AboutRyan(),
            _SelectedWork(onViewWork: () => context.go('/portfolio')),
            const _Services(),
            _Closing(onInquire: () => context.go('/booking')),
          ],
        ),
      ),
    );
  }
}

class _RyanHero extends StatelessWidget {
  const _RyanHero({required this.onViewWork});

  final VoidCallback onViewWork;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        return Container(
          constraints: BoxConstraints(minHeight: isDesktop ? 760 : 720),
          color: AppColors.ivory,
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(
                      flex: 48,
                      child: _HeroCopy(onViewWork: onViewWork),
                    ),
                    Expanded(flex: 52, child: _HeroImage()),
                  ],
                )
              : Column(
                  children: [
                    _HeroImage(height: 500),
                    _HeroCopy(onViewWork: onViewWork),
                  ],
                ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.onViewWork});

  final VoidCallback onViewWork;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(80, 70, 55, 70),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Transform.translate(
          offset: const Offset(0, -35),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'KALLYGRAPHY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 3.4,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'KALIISA\nRYAN',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 82,
                  height: .78,
                  fontWeight: FontWeight.w400,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'PHOTOGRAPHER · VIDEOGRAPHER\nGRAPHICS DESIGNER',
                style: TextStyle(
                  fontSize: 10,
                  height: 1.7,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.7,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 25),
              const SizedBox(
                width: 430,
                child: Text(
                  'I create visual stories with an eye for feeling, '
                  'detail and the moments that matter.',
                  style: TextStyle(
                    fontFamily: 'CormorantGaramond',
                    fontSize: 26,
                    height: 1.25,
                    color: AppColors.espresso,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _PillButton(
                    label: 'VIEW MY WORK',
                    filled: true,
                    onPressed: onViewWork,
                  ),
                  _PillButton(
                    label: 'INQUIRE',
                    onPressed: () => context.go('/booking'),
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

class _HeroImage extends StatelessWidget {
  const _HeroImage({this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Image.asset(
        HomeScreen._ryanPortrait,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (context, error, stackTrace) {
          return const ColoredBox(
            color: AppColors.sand,
            child: Center(
              child: Icon(
                Icons.person_outline,
                size: 70,
                color: AppColors.brown,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
  });

  final String label;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? AppColors.espresso : Colors.transparent,
      shape: StadiumBorder(
        side: BorderSide(
          color: filled ? AppColors.espresso : AppColors.darkBrown,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 15),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              color: filled ? AppColors.ivory : AppColors.espresso,
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutRyan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.espresso,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 110,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/portfolio/KallyGraphy Official Logo.png',
                width: 280,
                height: 110,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'KALLYGRAPHY',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: AppColors.ivory,
                    ),
                  );
                },
              ),
              const SizedBox(height: 70),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isDesktop = constraints.maxWidth >= 850;

                  return isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Expanded(flex: 4, child: _AboutLabel()),
                            const SizedBox(width: 80),
                            Expanded(flex: 7, child: _AboutText()),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _AboutLabel(),
                            const SizedBox(height: 50),
                            _AboutText(),
                          ],
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

class _AboutLabel extends StatelessWidget {
  const _AboutLabel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ABOUT RYAN',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.4,
            color: AppColors.sand,
          ),
        ),
        SizedBox(height: 20),
        Text(
          'THE PERSON\nBEHIND THE\nCAMERA.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 48,
            height: .95,
            color: AppColors.ivory,
          ),
        ),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am Kaliisa Ryan — a photographer, videographer and '
          'graphics designer with a passion for creating visual stories.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 31,
            height: 1.25,
            color: AppColors.ivory,
          ),
        ),
        SizedBox(height: 30),
        Text(
          'My work is shaped by a strong aesthetic sense, technical '
          'knowledge of modern camera technologies, attention to detail '
          'and an understanding of how to bring a creative idea to life.',
          style: TextStyle(fontSize: 14, height: 1.9, color: AppColors.sand),
        ),
        SizedBox(height: 22),
        Text(
          'From weddings and traditional events to fashion, beauty and '
          'portrait photography, I focus on creating images that feel '
          'intentional, expressive and memorable.',
          style: TextStyle(fontSize: 14, height: 1.9, color: AppColors.sand),
        ),
      ],
    );
  }
}

class _SelectedWork extends StatelessWidget {
  const _SelectedWork({required this.onViewWork});

  final VoidCallback onViewWork;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 105,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1240),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'SELECTED WORK',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'A few stories\nthrough my lens.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 57,
                  height: .95,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth < 700) {
                    return Column(
                      children: HomeScreen._selectedWork
                          .map(
                            (work) => Padding(
                              padding: const EdgeInsets.only(bottom: 28),
                              child: _WorkCard(work: work),
                            ),
                          )
                          .toList(),
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _WorkCard(work: HomeScreen._selectedWork[0]),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _WorkCard(work: HomeScreen._selectedWork[1]),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _WorkCard(work: HomeScreen._selectedWork[2]),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 50),
              Center(
                child: _PillButton(
                  label: 'VIEW MY WORK',
                  filled: true,
                  onPressed: onViewWork,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkCard extends StatelessWidget {
  const _WorkCard({required this.work});

  final ({String image, String title, String subtitle}) work;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: .78,
          child: Image.asset(
            work.image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppColors.sand,
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.brown,
                  size: 40,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),
        Text(
          work.title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          work.subtitle,
          style: const TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 21,
            color: AppColors.espresso,
          ),
        ),
      ],
    );
  }
}

class _Services extends StatelessWidget {
  const _Services();

  static const services = [
    ('01', 'WEDDINGS'),
    ('02', 'PORTRAITS'),
    ('03', 'FASHION & BEAUTY'),
    ('04', 'EVENTS'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ivory,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 100,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'WHAT I DO',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.4,
                  color: AppColors.brown,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Creating with intention.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 52,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 55),
              ...services.map(
                (service) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: .7),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        service.$1,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(width: 35),
                      Text(
                        service.$2,
                        style: const TextStyle(
                          fontFamily: 'CormorantGaramond',
                          fontSize: 31,
                          color: AppColors.espresso,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Closing extends StatelessWidget {
  const _Closing({required this.onInquire});

  final VoidCallback onInquire;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: 110,
      ),
      child: Column(
        children: [
          const Text(
            'YOUR STORY DESERVES\nTO BE REMEMBERED.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'CormorantGaramond',
              fontSize: 55,
              height: .98,
              color: AppColors.ivory,
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Let’s create something meaningful together.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.sand),
          ),
          const SizedBox(height: 38),
          _PillButton(label: 'INQUIRE', filled: false, onPressed: onInquire),
        ],
      ),
    );
  }
}
