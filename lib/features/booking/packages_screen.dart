import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  static const _packages = [
    _Package(
      number: '01',
      price: 'UGX 2,500,000',
      items: [
        '3 cameras on location',
        'A3 photobook',
        '3 board pics',
        '200 edited soft copies',
      ],
      image: 'assets/images/ryan/Wedding.jpg',
    ),
    _Package(
      number: '02',
      price: 'UGX 3,500,000',
      items: [
        '3 cameras on location',
        'A3 photobook',
        '5 board pics',
        '250 edited soft copies',
        'Drone',
      ],
      image: 'assets/images/ryan/Wedding2.jpg',
    ),
    _Package(
      number: '03',
      price: 'UGX 4,500,000',
      items: [
        '4 cameras on location',
        'A3 photobook',
        '6 board pics',
        '250 edited soft copies',
        'Drone',
        '2 × 55-inch TV screens',
      ],
      image: 'assets/images/ryan/Wedding3.jpg',
    ),
    _Package(
      number: '04',
      price: 'UGX 5,000,000',
      items: [
        '4 cameras on location',
        'A3 photobook',
        '6 board pics',
        'Memory Lane',
        '250 edited soft copies',
        'Drone',
        '2 × 55-inch TV screens',
      ],
      image: 'assets/images/ryan/Wedding4.jpg',
    ),
    _Package(
      number: '05',
      price: 'UGX 6,000,000',
      items: [
        '4 cameras on location',
        'A3 photobook',
        '6 board pics',
        'Memory Lane',
        '250 edited soft copies',
        'Drone',
        '1 LED screen (2 × 3)',
      ],
      image: 'assets/images/ryan/Wedding5.jpg',
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
            const _PackageIntro(),
            _PackageList(packages: _packages),
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
    required this.price,
    required this.items,
    required this.image,
  });

  final String number;
  final String price;
  final List<String> items;
  final String image;
}

class _PackagesHero extends StatelessWidget {
  const _PackagesHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 105, 28, 95),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 800;

              final heading = Text(
                'PACKAGES\nMADE FOR\nTHE DAY.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.espresso,
                  fontSize: wide ? 92 : 58,
                  height: .82,
                  letterSpacing: -1.5,
                ),
              );

              final introduction = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Eyebrow('KALLYGRAPHY / PACKAGES'),
                  const SizedBox(height: 28),
                  Container(width: 52, height: 3, color: AppColors.mocha),
                  const SizedBox(height: 25),
                  Text(
                    'Because every celebration deserves to be '
                    'photographed with intention.',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(color: AppColors.brown, height: 1.7),
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    'FIVE WAYS TO PRESERVE THE DAY.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                      color: AppColors.mocha,
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 55), introduction],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(flex: 5, child: heading),
                  const SizedBox(width: 100),
                  Expanded(flex: 2, child: introduction),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PackageIntro extends StatelessWidget {
  const _PackageIntro();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.mocha,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 19),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'CHOOSE YOUR COVERAGE',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: AppColors.ivory,
                  ),
                ),
              ),
              Text(
                '01 — 05',
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: AppColors.ivory, letterSpacing: 1.5),
              ),
            ],
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
          _PackageSection(package: packages[index], index: index),
      ],
    );
  }
}

class _PackageSection extends StatelessWidget {
  const _PackageSection({required this.package, required this.index});

  final _Package package;
  final int index;

  @override
  Widget build(BuildContext context) {
    final alternate = index.isOdd;

    return Container(
      width: double.infinity,
      color: alternate ? AppColors.ivory : AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 100, 28, 105),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 820;

              final image = _PackageImage(
                image: package.image,
                number: package.number,
              );

              final details = _PackageDetails(
                package: package,
                number: package.number,
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [image, const SizedBox(height: 48), details],
                );
              }

              final content = [
                Expanded(flex: 6, child: image),
                const SizedBox(width: 90),
                Expanded(flex: 5, child: details),
              ];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: alternate ? content.reversed.toList() : content,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PackageImage extends StatelessWidget {
  const _PackageImage({required this.image, required this.number});

  final String image;
  final String number;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.15,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.sand,
            padding: const EdgeInsets.all(14),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.image_outlined,
                    size: 42,
                    color: AppColors.espresso,
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
              color: AppColors.espresso,
              child: Text(
                number,
                style: const TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: AppColors.ivory,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PackageDetails extends StatelessWidget {
  const _PackageDetails({required this.package, required this.number});

  final _Package package;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PACKAGE $number',
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.2,
            color: AppColors.mocha,
          ),
        ),
        const SizedBox(height: 19),
        Text(
          package.price,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: AppColors.espresso,
            fontSize: 48,
            height: .95,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 24),
        Container(width: 58, height: 3, color: AppColors.mocha),
        const SizedBox(height: 32),
        ...package.items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '—',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mocha,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(color: AppColors.espresso, height: 1.45),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 22),
        _PackageButton(onPressed: () => context.go('/booking')),
      ],
    );
  }
}

class _PackageButton extends StatelessWidget {
  const _PackageButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.mocha,
        foregroundColor: AppColors.ivory,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 19),
        shape: const StadiumBorder(),
      ),
      child: const Text(
        'CHOOSE THIS PACKAGE  →',
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.6,
        ),
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
      padding: const EdgeInsets.fromLTRB(28, 115, 28, 125),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth > 780;

              final heading = Text(
                'THE DAY WILL PASS.\n'
                'THE PHOTOGRAPHS\n'
                'WILL STAY.',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: AppColors.ivory,
                  fontSize: wide ? 67 : 46,
                  height: .88,
                  letterSpacing: -1,
                ),
              );

              final action = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'READY WHEN YOU ARE.',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.sand,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton(
                    onPressed: () => context.go('/booking'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.mocha,
                      foregroundColor: AppColors.ivory,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 19,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text(
                      'START YOUR INQUIRY  →',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.7,
                      ),
                    ),
                  ),
                ],
              );

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [heading, const SizedBox(height: 42), action],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: heading),
                  const SizedBox(width: 90),
                  action,
                ],
              );
            },
          ),
        ),
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
        fontWeight: FontWeight.w700,
        letterSpacing: 2.2,
        color: AppColors.brown,
      ),
    );
  }
}
