import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/brand_page_background.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BrandPageBackground(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(),
            _PositioningStrip(),
            _IntroductionSection(),
            _FeaturedWorkSection(),
            _DisciplinesSection(),
            _ExperienceSection(),
            _PackagesSection(),
            _GallerySection(),
            _FinalCtaSection(),
            _FooterSection(),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        if (!wide) {
          return const Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeroCopy(),
                SizedBox(height: 44),
                SizedBox(height: 520, child: _HeroImage()),
              ],
            ),
          );
        }

        return SizedBox(
          height: 760,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(72, 56, 72, 64),
            child: Row(
              children: [
                const Expanded(flex: 47, child: _HeroCopy()),
                const SizedBox(width: 56),
                const Expanded(flex: 53, child: _HeroImage()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Eyebrow('KAMPALA · UGANDA · WORLDWIDE'),
          const SizedBox(height: 28),
          Text(
            'THE ART\nOF BEING\nREMEMBERED.',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 68,
              height: .9,
              letterSpacing: -2.4,
              color: AppColors.darkBrown,
            ),
          ),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 470),
            child: Text(
              'Photography for weddings, celebrations, portraits, '
              'and the moments that deserve to stay with you.',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: AppColors.brown, height: 1.7),
            ),
          ),
          const SizedBox(height: 36),
          FilledButton(
            onPressed: () => context.go('/booking'),
            child: const Text('BEGIN YOUR STORY'),
          ),
          const SizedBox(height: 32),
          const _ScrollCue(),
        ],
      ),
    );
  }
}

class _HeroImage extends StatelessWidget {
  const _HeroImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/ryan/Introduction4.jpg',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const ColoredBox(
                color: AppColors.sand,
                child: Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 42,
                    color: AppColors.brown,
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 20,
            bottom: 20,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.cream.withValues(alpha: .94),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                child: Text(
                  'INTRODUCTIONS',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PositioningStrip extends StatelessWidget {
  const _PositioningStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.darkBrown,
        border: Border(
          top: BorderSide(color: AppColors.brown),
          bottom: BorderSide(color: AppColors.brown),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          final items = ['WEDDINGS', 'PORTRAITS', 'CELEBRATIONS', 'MOMENTS'];

          return wide
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (var i = 0; i < items.length; i++) ...[
                      Text(
                        items[i],
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                          color: AppColors.cream,
                        ),
                      ),
                      if (i != items.length - 1)
                        const Text(
                          '·',
                          style: TextStyle(
                            color: AppColors.mocha,
                            fontSize: 18,
                          ),
                        ),
                    ],
                  ],
                )
              : Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 18,
                  runSpacing: 12,
                  children: items
                      .map(
                        (item) => Text(
                          item,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.5,
                            color: AppColors.cream,
                          ),
                        ),
                      )
                      .toList(),
                );
        },
      ),
    );
  }
}

class _IntroductionSection extends StatelessWidget {
  const _IntroductionSection();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: wide ? 96 : 28,
            vertical: wide ? 150 : 90,
          ),
          child: wide
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 42,
                      child: _SectionLabel('01 · THE APPROACH'),
                    ),
                    SizedBox(width: 70),
                    Expanded(flex: 58, child: _IntroductionCopy()),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _SectionLabel('01 · THE APPROACH'),
                    SizedBox(height: 34),
                    _IntroductionCopy(),
                  ],
                ),
        );
      },
    );
  }
}

class _IntroductionCopy extends StatelessWidget {
  const _IntroductionCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PHOTOGRAPHS\nTHAT FEEL\nLIKE MEMORY.',
          style: Theme.of(context).textTheme.displayMedium
              ?.copyWith(fontSize: 56, height: .94, letterSpacing: -1.5),
        ),
        const SizedBox(height: 34),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Text(
            'The best photographs are not simply beautiful. '
            'They take you back. They preserve the atmosphere, '
            'the people, the movement and the feeling of a day '
            'you never want to forget.',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.brown, height: 1.85),
          ),
        ),
        const SizedBox(height: 32),
        TextButton(
          onPressed: () => context.go('/portfolio'),
          child: const Text('EXPLORE THE WORK  →'),
        ),
      ],
    );
  }
}

class _FeaturedWorkSection extends StatelessWidget {
  const _FeaturedWorkSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sand.withValues(alpha: .48),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 100),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return Column(
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(
                      child: _SectionHeading(
                        eyebrow: '02 · SELECTED WORK',
                        title: 'THE WAY\nIT FELT.',
                      ),
                    ),
                    if (wide)
                      TextButton(
                        onPressed: () => context.go('/portfolio'),
                        child: const Text('VIEW FULL PORTFOLIO  →'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 56),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: wide
                    ? const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 58,
                            child: _FeatureImage(
                              image: 'Wedding.jpg',
                              label: 'WEDDINGS',
                              height: 620,
                            ),
                          ),
                          SizedBox(width: 28),
                          Expanded(
                            flex: 42,
                            child: Padding(
                              padding: EdgeInsets.only(top: 150),
                              child: _FeatureImage(
                                image: 'Moment6.jpg',
                                label: 'MOMENTS',
                                height: 470,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        children: [
                          _FeatureImage(
                            image: 'Wedding.jpg',
                            label: 'WEDDINGS',
                            height: 480,
                          ),
                          SizedBox(height: 28),
                          _FeatureImage(
                            image: 'Moment6.jpg',
                            label: 'MOMENTS',
                            height: 420,
                          ),
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

class _FeatureImage extends StatefulWidget {
  const _FeatureImage({
    required this.image,
    required this.label,
    required this.height,
  });

  final String image;
  final String label;
  final double height;

  @override
  State<_FeatureImage> createState() => _FeatureImageState();
}

class _FeatureImageState extends State<_FeatureImage> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: () => context.go('/portfolio'),
        child: SizedBox(
          height: widget.height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: hovering ? 1.025 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  child: Image.asset(
                    'assets/images/ryan/${widget.image}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const ColoredBox(
                        color: AppColors.sand,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            color: AppColors.brown,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  left: 18,
                  bottom: 18,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cream.withValues(alpha: .95),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 9,
                      ),
                      child: Text(
                        widget.label,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
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

class _DisciplinesSection extends StatelessWidget {
  const _DisciplinesSection();

  @override
  Widget build(BuildContext context) {
    const disciplines = [
      (
        number: '01',
        title: 'WEDDINGS',
        body: 'For the full story — from quiet preparation to the last dance.',
      ),
      (
        number: '02',
        title: 'INTRODUCTIONS',
        body: 'For the moments where a new chapter begins and everyone is watching.',
      ),
      (
        number: '03',
        title: 'CELEBRATIONS',
        body: 'For birthdays, baby showers, graduations and everything worth gathering for.',
      ),
      (
        number: '04',
        title: 'PORTRAITS',
        body: 'For images that feel unmistakably like you, rather than simply looking posed.',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeading(
              eyebrow: '03 · WHAT WE PHOTOGRAPH',
              title: 'EVERY CHAPTER\nDESERVES ITS FRAME.',
            ),
            const SizedBox(height: 70),
            ...disciplines.map(
              (item) => _DisciplineRow(
                number: item.number,
                title: item.title,
                body: item.body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisciplineRow extends StatefulWidget {
  const _DisciplineRow({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  State<_DisciplineRow> createState() => _DisciplineRowState();
}

class _DisciplineRowState extends State<_DisciplineRow> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: hovering
              ? AppColors.sand.withValues(alpha: .35)
              : Colors.transparent,
          border: const Border(top: BorderSide(color: AppColors.border)),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 800;

            return wide
                ? Row(
                    children: [
                      SizedBox(
                        width: 70,
                        child: Text(
                          widget.number,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            letterSpacing: 1,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.darkBrown,
                                letterSpacing: 1,
                              ),
                        ),
                      ),
                      SizedBox(
                        width: 360,
                        child: Text(
                          widget.body,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.number,
                        style: const TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          letterSpacing: 1,
                          color: AppColors.muted,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(color: AppColors.darkBrown),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.body,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 110),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '04 · THE EXPERIENCE',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                  color: AppColors.sand,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'NOT JUST\nPHOTOGRAPHS.\nAN EXPERIENCE.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.cream,
                  fontSize: 54,
                  height: .95,
                ),
              ),
              const SizedBox(height: 28),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 540),
                child: const Text(
                  'From the first conversation to the final gallery, '
                  'everything is designed to make the process feel calm, '
                  'intentional and completely yours.',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 15,
                    height: 1.8,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 34),
              FilledButton(
                onPressed: () => context.go('/booking'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mocha,
                  foregroundColor: AppColors.cream,
                ),
                child: const Text('PLAN YOUR SESSION'),
              ),
            ],
          );

          final steps = [
            ('01', 'CONNECT', 'Tell us what you are planning.'),
            ('02', 'CREATE', 'We photograph the day as it unfolds.'),
            ('03', 'DELIVER', 'Your memories become a finished collection.'),
          ];

          final process = Column(
            children: steps
                .map(
                  (step) => Padding(
                    padding: const EdgeInsets.only(bottom: 34),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          step.$1,
                          style: const TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 11,
                            color: AppColors.mocha,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.$2,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.5,
                                  color: AppColors.cream,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                step.$3,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 13,
                                  height: 1.6,
                                  color: AppColors.sand,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          );

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1180),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 100),
                      SizedBox(width: 380, child: process),
                    ],
                  )
                : Column(children: [copy, const SizedBox(height: 70), process]),
          );
        },
      ),
    );
  }
}

class _PackagesSection extends StatelessWidget {
  const _PackagesSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 900;

            return wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Expanded(
                        child: _SectionHeading(
                          eyebrow: '05 · PACKAGES',
                          title: 'A COLLECTION\nFOR EVERY STORY.',
                        ),
                      ),
                      const SizedBox(width: 80),
                      Expanded(child: _PackagesCopy()),
                    ],
                  )
                : const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionHeading(
                        eyebrow: '05 · PACKAGES',
                        title: 'A COLLECTION\nFOR EVERY STORY.',
                      ),
                      SizedBox(height: 42),
                      _PackagesCopy(),
                    ],
                  );
          },
        ),
      ),
    );
  }
}

class _PackagesCopy extends StatelessWidget {
  const _PackagesCopy();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thoughtful coverage, beautiful finishes and everything '
          'you need to remember the day properly.',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(color: AppColors.brown, height: 1.8),
        ),
        const SizedBox(height: 28),
        const _PriceLine(label: 'PACKAGE 01', price: 'UGX 2.5M'),
        const _PriceLine(label: 'PACKAGE 02', price: 'UGX 3.5M'),
        const _PriceLine(label: 'PACKAGE 03', price: 'UGX 4.5M'),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go('/booking'),
          child: const Text('EXPLORE PACKAGES'),
        ),
      ],
    );
  }
}

class _PriceLine extends StatelessWidget {
  const _PriceLine({required this.label, required this.price});

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 17),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.4,
              color: AppColors.darkBrown,
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'Cormorant Garamond',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.mocha,
            ),
          ),
        ],
      ),
    );
  }
}

class _GallerySection extends StatelessWidget {
  const _GallerySection();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand.withValues(alpha: .42),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 110),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 850;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SectionHeading(
                  eyebrow: '06 · CLIENT GALLERIES',
                  title: 'YOUR MEMORIES,\nKEPT BEAUTIFULLY.',
                ),
                const SizedBox(height: 42),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'Already photographed with KALLYGRAPHY?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    if (wide)
                      FilledButton(
                        onPressed: () => context.go('/gallery'),
                        child: const Text('OPEN YOUR GALLERY'),
                      ),
                  ],
                ),
                if (!wide) ...[
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.go('/gallery'),
                    child: const Text('OPEN YOUR GALLERY'),
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

class _FinalCtaSection extends StatelessWidget {
  const _FinalCtaSection();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 130),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              const _Eyebrow('07 · LET’S MAKE SOMETHING LAST'),
              const SizedBox(height: 26),
              Text(
                'YOUR STORY\nDESERVES TO\nBE FELT.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge
                    ?.copyWith(fontSize: 72, height: .9, letterSpacing: -2),
              ),
              const SizedBox(height: 30),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Text(
                  'Whether the day is carefully planned or beautifully '
                  'unpredictable, we would love to photograph it.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(height: 1.8, color: AppColors.brown),
                ),
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () => context.go('/booking'),
                child: const Text('MAKE AN INQUIRY'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 36),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1180),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 800;

                return wide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: _FooterBrand()),
                          _FooterLinks(
                            onPortfolio: () => context.go('/portfolio'),
                            onPackages: () => context.go('/packages'),
                            onBooking: () => context.go('/booking'),
                            onGallery: () => context.go('/gallery'),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _FooterBrand(),
                          const SizedBox(height: 48),
                          _FooterLinks(
                            onPortfolio: () => context.go('/portfolio'),
                            onPackages: () => context.go('/packages'),
                            onBooking: () => context.go('/booking'),
                            onGallery: () => context.go('/gallery'),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 60),
            const Divider(color: AppColors.brown),
            const SizedBox(height: 22),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '© KALLYGRAPHY',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: AppColors.sand,
                  ),
                ),
                Text(
                  'KAMPALA · UGANDA',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    letterSpacing: 1.2,
                    color: AppColors.sand,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterBrand extends StatelessWidget {
  const _FooterBrand();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'KALLYGRAPHY',
          style: Theme.of(context).textTheme.headlineSmall
              ?.copyWith(color: AppColors.cream, letterSpacing: 2),
        ),
        const SizedBox(height: 18),
        const SizedBox(
          width: 340,
          child: Text(
            'Photography with intention. Memories with a pulse.',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 13,
              height: 1.7,
              color: AppColors.sand,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks({
    required this.onPortfolio,
    required this.onPackages,
    required this.onBooking,
    required this.onGallery,
  });

  final VoidCallback onPortfolio;
  final VoidCallback onPackages;
  final VoidCallback onBooking;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final links = [
      ('WORK', onPortfolio),
      ('PACKAGES', onPackages),
      ('GALLERIES', onGallery),
      ('INQUIRE', onBooking),
    ];

    return Wrap(
      spacing: 34,
      runSpacing: 18,
      children: links
          .map(
            (link) => InkWell(
              onTap: link.$2,
              child: Text(
                link.$1,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.cream,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.eyebrow, required this.title});

  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow(eyebrow),
        const SizedBox(height: 24),
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium
              ?.copyWith(fontSize: 54, height: .95, letterSpacing: -1.3),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: AppColors.muted,
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: AppColors.mocha,
      ),
    );
  }
}

class _ScrollCue extends StatelessWidget {
  const _ScrollCue();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SizedBox(width: 34, child: Divider(color: AppColors.border)),
        SizedBox(width: 12),
        Text(
          'SCROLL TO EXPLORE',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 9,
            letterSpacing: 1.5,
            color: AppColors.muted,
          ),
        ),
      ],
    );
  }
}
