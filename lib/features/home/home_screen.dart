import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _logo = 'assets/images/portfolio/KallyGraphy Official Logo.png';

  static const _photos = [
    'assets/images/portfolio/portrait_woman.jpg',
    'assets/images/portfolio/portrait_man_hat.jpg',
    'assets/images/portfolio/couple_wedding.jpg',
    'assets/images/portfolio/portrait_woman_close.jpg',
    'assets/images/portfolio/wedding_bouquet.jpg',
    'assets/images/portfolio/lake_boat.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _Hero(),
          _Introduction(),
          _SelectedWork(),
          _Statement(),
          _Contact(),
        ],
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 700 ? 720 : 820,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            HomeScreen._photos[0],
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.espresso.withValues(alpha: 0.28),
                  Colors.transparent,
                  AppColors.espresso.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 150, 28, 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    'PHOTOGRAPHY STUDIO · KAMPALA',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.85),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.2,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    'Stories worth\nremembering.',
                    style: TextStyle(
                      color: AppColors.ivory,
                      fontFamily: 'CormorantGaramond',
                      fontSize: MediaQuery.sizeOf(context).width < 700
                          ? 58
                          : 88,
                      height: 0.92,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Row(
                    children: [
                      Text(
                        'EXPLORE THE WORK',
                        style: TextStyle(
                          color: AppColors.ivory,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Icon(
                        Icons.arrow_downward_rounded,
                        color: AppColors.ivory,
                        size: 17,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Introduction extends StatelessWidget {
  const _Introduction();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 100, 28, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 800;

              if (!wide) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _eyebrow('01 / THE APPROACH'),
                    const SizedBox(height: 35),
                    const _IntroText(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: _eyebrow('01 / THE APPROACH')),
                  const Expanded(flex: 6, child: _IntroText()),
                  const Spacer(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _IntroText extends StatelessWidget {
  const _IntroText();

  @override
  Widget build(BuildContext context) {
    return Text(
      'We photograph people, places and moments with an eye for what feels honest, beautiful and timeless.',
      style: TextStyle(
        color: AppColors.espresso,
        fontFamily: 'CormorantGaramond',
        fontSize: MediaQuery.sizeOf(context).width < 700 ? 38 : 58,
        height: 1.02,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

class _SelectedWork extends StatelessWidget {
  const _SelectedWork();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brown,
      padding: const EdgeInsets.fromLTRB(28, 90, 28, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final wide = constraints.maxWidth >= 850;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _eyebrow(
                        '02 / SELECTED WORK',
                        color: AppColors.cream.withValues(alpha: 0.72),
                      ),
                      const Spacer(),
                      Text(
                        '2026',
                        style: TextStyle(
                          color: AppColors.cream.withValues(alpha: 0.5),
                          fontSize: 9,
                          letterSpacing: 1.6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: _ImageTile(
                            image: HomeScreen._photos[0],
                            label: 'PORTRAITS',
                            height: 650,
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 120),
                            child: Column(
                              children: [
                                _ImageTile(
                                  image: HomeScreen._photos[1],
                                  label: 'EDITORIAL',
                                  height: 285,
                                ),
                                const SizedBox(height: 24),
                                _ImageTile(
                                  image: HomeScreen._photos[2],
                                  label: 'CELEBRATIONS',
                                  height: 285,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        _ImageTile(
                          image: HomeScreen._photos[0],
                          label: 'PORTRAITS',
                          height: 500,
                        ),
                        const SizedBox(height: 18),
                        _ImageTile(
                          image: HomeScreen._photos[1],
                          label: 'EDITORIAL',
                          height: 310,
                        ),
                        const SizedBox(height: 18),
                        _ImageTile(
                          image: HomeScreen._photos[2],
                          label: 'CELEBRATIONS',
                          height: 310,
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

class _ImageTile extends StatefulWidget {
  const _ImageTile({
    required this.image,
    required this.label,
    required this.height,
  });

  final String image;
  final String label;
  final double height;

  @override
  State<_ImageTile> createState() => _ImageTileState();
}

class _ImageTileState extends State<_ImageTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: SizedBox(
            width: double.infinity,
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                AnimatedScale(
                  scale: _hovered ? 1.035 : 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  child: Image.asset(widget.image, fit: BoxFit.cover),
                ),
                AnimatedOpacity(
                  opacity: _hovered ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.espresso.withValues(alpha: 0.02),
                          AppColors.espresso.withValues(alpha: 0.75),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.label,
                          style: const TextStyle(
                            color: AppColors.ivory,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_outward_rounded,
                        color: AppColors.ivory,
                        size: 16,
                      ),
                    ],
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

class _Statement extends StatelessWidget {
  const _Statement();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 120, 28, 130),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('03 / OUR PHILOSOPHY'),
              const SizedBox(height: 40),
              Text(
                'The beauty is already there.\nWe simply frame it.',
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: MediaQuery.sizeOf(context).width < 700 ? 50 : 76,
                  height: 0.96,
                ),
              ),
              const SizedBox(height: 36),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  'From quiet portraits to unforgettable celebrations, '
                  'our photographs are made to feel as meaningful years '
                  'from now as they did in the moment.',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 14,
                    height: 1.7,
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

class _Contact extends StatelessWidget {
  const _Contact();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 90),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'LET’S MAKE\nSOMETHING\nTIMELESS.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'CormorantGaramond',
                  fontSize: MediaQuery.sizeOf(context).width < 700 ? 56 : 84,
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
                    'START A CONVERSATION  →',
                    style: TextStyle(
                      color: AppColors.espresso,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.6,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 150,
                    child: Image.asset(
                      HomeScreen._logo,
                      fit: BoxFit.contain,
                      color: AppColors.ivory,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'KAMPALA · UGANDA\n© 2026 KALLYGRAPHY',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.55),
                      fontSize: 9,
                      height: 1.7,
                      letterSpacing: 1.2,
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

Widget _eyebrow(String text, {Color color = AppColors.espresso}) {
  return Text(
    text,
    style: TextStyle(
      color: color,
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 2,
    ),
  );
}
