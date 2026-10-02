import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  static const _packages = [
    _Package(
      number: '01',
      category: 'WEDDINGS',
      title: 'Your wedding,\nas it felt.',
      description: 'From the quiet details before the ceremony to the people, movement and emotion that fill the day — your wedding is documented as a story, not just a collection of images.',
      image: 'assets/images/ryan/Wedding.jpg',
    ),
    _Package(
      number: '02',
      category: 'INTRODUCTIONS',
      title: 'A day worth\nremembering.',
      description: 'Traditional introductions deserve photographs that preserve the atmosphere, the people and the moments that make the celebration yours.',
      image: 'assets/images/ryan/Introduction.jpg',
    ),
    _Package(
      number: '03',
      category: 'BABY SHOWERS',
      title: 'New\nbeginnings.',
      description: 'A celebration filled with anticipation, laughter and love. I capture the little details and the people who make the moment meaningful.',
      image: 'assets/images/ryan/Baby shower.jpg',
    ),
    _Package(
      number: '04',
      category: 'PHOTOSHOOTS',
      title: 'In your\nelement.',
      description: 'Portraits and creative sessions built around you — your personality, your style and the visual story you want to create.',
      image: 'assets/images/ryan/photoshoot.jpg',
    ),
    _Package(
      number: '05',
      category: 'GRADUATIONS',
      title: 'A moment\nof arrival.',
      description: 'The work, the people and the celebration behind the achievement. Graduation photography that gives the milestone the space it deserves.',
      image: 'assets/images/ryan/graduation.jpg',
    ),
    _Package(
      number: '06',
      category: 'MOMENTS',
      title: 'Life,\nas it felt.',
      description: 'For the celebrations and everyday moments that deserve to be remembered — photographed naturally, intentionally and with feeling.',
      image: 'assets/images/ryan/Moments.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _PackagesHero(),
            const _ExperienceSection(),
            _PackageList(packages: _packages),
            const _AdditionalServices(),
            const _PackagesClosing(),
          ],
        ),
      ),
    );
  }
}

class _Package {
  const _Package({
    required this.number,
    required this.category,
    required this.title,
    required this.description,
    required this.image,
  });

  final String number;
  final String category;
  final String title;
  final String description;
  final String image;
}

class _PackagesHero extends StatelessWidget {
  const _PackagesHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 620),
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 80),
      color: AppColors.cream,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('PACKAGES / KALLYGRAPHY'),
              const SizedBox(height: 34),
              Text(
                'Choose the way\nwe tell your story.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 72,
                  height: .92,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 34),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 610),
                child: Text(
                  'Every story is different. Explore the kinds of work I create, then let’s talk about what you have in mind.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: AppColors.muted, height: 1.7),
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;

              final eyebrow = const _Eyebrow(
                '01 / THE EXPERIENCE',
                color: AppColors.sand,
              );

              final copy = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'More than\nphotographs.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.ivory,
                      fontSize: 58,
                      height: .96,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'Every booking begins with a conversation. I want to understand the occasion, the people and what you want to remember about it.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: AppColors.sand, height: 1.75),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [eyebrow, const SizedBox(height: 38), copy],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: eyebrow),
                  const SizedBox(width: 80),
                  Expanded(flex: 2, child: copy),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PackageList extends StatelessWidget {
  const _PackageList({required this.packages});

  final List<_Package> packages;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < packages.length; index++)
          _PackageRow(package: packages[index], reverse: index.isOdd),
      ],
    );
  }
}

class _PackageRow extends StatelessWidget {
  const _PackageRow({required this.package, required this.reverse});

  final _Package package;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: reverse ? AppColors.ivory : AppColors.cream,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;

              final image = ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: AspectRatio(
                  aspectRatio: 4 / 5,
                  child: Image.asset(
                    package.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.sand,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_outlined,
                          size: 40,
                          color: AppColors.espresso,
                        ),
                      );
                    },
                  ),
                ),
              );

              final copy = Padding(
                padding: EdgeInsets.only(
                  left: wide && !reverse ? 70 : 0,
                  right: wide && reverse ? 70 : 0,
                  top: wide ? 20 : 36,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Eyebrow('${package.number} / ${package.category}'),
                    const SizedBox(height: 28),
                    Text(
                      package.title,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            color: AppColors.espresso,
                            fontSize: 54,
                            height: .96,
                          ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      package.description,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(color: AppColors.muted, height: 1.75),
                    ),
                    const SizedBox(height: 34),
                    _InquireButton(
                      label: 'INQUIRE',
                      onPressed: () => context.go('/booking'),
                    ),
                  ],
                ),
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [image, copy],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: reverse
                    ? [
                        Expanded(child: copy),
                        const SizedBox(width: 30),
                        Expanded(child: image),
                      ]
                    : [
                        Expanded(child: image),
                        const SizedBox(width: 30),
                        Expanded(child: copy),
                      ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdditionalServices extends StatelessWidget {
  const _AdditionalServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.sand,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 760;

              final services = [
                ('01', 'VIDEOGRAPHY'),
                ('02', 'GRAPHICS DESIGN'),
                ('03', 'CUSTOM WORK'),
              ];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow('02 / BEYOND PHOTOGRAPHY'),
                  const SizedBox(height: 42),
                  Text(
                    'Built around\nyour vision.',
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: AppColors.espresso,
                      fontSize: 58,
                      height: .96,
                    ),
                  ),
                  const SizedBox(height: 58),
                  if (wide)
                    Row(
                      children: [
                        for (var i = 0; i < services.length; i++)
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: i == services.length - 1 ? 0 : 18,
                              ),
                              child: _ServiceItem(
                                number: services[i].$1,
                                title: services[i].$2,
                              ),
                            ),
                          ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        for (final service in services)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: _ServiceItem(
                              number: service.$1,
                              title: service.$2,
                            ),
                          ),
                      ],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ServiceItem extends StatelessWidget {
  const _ServiceItem({required this.number, required this.title});

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: AppColors.muted, letterSpacing: 1.5),
          ),
          const SizedBox(height: 44),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(color: AppColors.espresso, letterSpacing: 1.2),
          ),
        ],
      ),
    );
  }
}

class _PackagesClosing extends StatelessWidget {
  const _PackagesClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.espresso,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(
                '03 / START A CONVERSATION',
                color: AppColors.sand,
              ),
              const SizedBox(height: 34),
              Text(
                'Tell me what you are\nplanning.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.ivory,
                  fontSize: 64,
                  height: .95,
                ),
              ),
              const SizedBox(height: 34),
              Text(
                'Share the details and let’s create something meaningful around them.',
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(color: AppColors.sand, height: 1.7),
              ),
              const SizedBox(height: 42),
              _InquireButton(
                label: 'MAKE AN INQUIRY',
                dark: false,
                onPressed: () => context.go('/booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InquireButton extends StatelessWidget {
  const _InquireButton({
    required this.label,
    required this.onPressed,
    this.dark = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: dark ? AppColors.espresso : AppColors.ivory,
        foregroundColor: dark ? AppColors.ivory : AppColors.espresso,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: dark ? AppColors.ivory : AppColors.espresso,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: color ?? AppColors.muted,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }
}
