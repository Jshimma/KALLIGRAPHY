import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: const [
            _Hero(),
            _Intro(),
            _SelectedWork(),
            _Manifesto(),
            _Closing(),
          ],
        ),
      ),
    );
  }
}

class _Hero extends StatefulWidget {
  const _Hero();

  @override
  State<_Hero> createState() => _HeroState();
}

class _HeroState extends State<_Hero> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _scale = Tween<double>(
      begin: 1.06,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        final height = wide ? 760.0 : 680.0;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FadeTransition(
                opacity: _fade,
                child: ScaleTransition(
                  scale: _scale,
                  child: Image.asset(
                    'assets/images/portfolio-hero.jpg',
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.15, 0.58, 1],
                    colors: [
                      AppColors.espresso.withValues(alpha: 0.18),
                      Colors.transparent,
                      AppColors.espresso.withValues(alpha: 0.78),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: wide ? 56 : 24,
                right: wide ? 56 : 24,
                bottom: wide ? 58 : 38,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PHOTOGRAPHY STUDIO · KAMPALA',
                      style: TextStyle(
                        color: AppColors.cream.withValues(alpha: 0.85),
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.4,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Stories worth\nremembering.',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: wide ? 76 : 50,
                        height: 0.94,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -2.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Text(
                          'EXPLORE THE WORK',
                          style: TextStyle(
                            color: AppColors.cream,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.8,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Icon(
                          Icons.arrow_downward_rounded,
                          color: AppColors.cream,
                          size: 17,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: wide ? 56 : 24,
                top: wide ? 112 : 90,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Text(
                    'KALLIGRAPHY',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.75),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Intro extends StatelessWidget {
  const _Intro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 120, 28, 130),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _Eyebrow(text: '01 / THE APPROACH')),
                Expanded(
                  flex: 3,
                  child: Text(
                    'We photograph people, places and moments with an '
                    'editorial eye — creating images that feel honest, '
                    'cinematic and timeless.',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 42,
                      height: 1.14,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1.2,
                    ),
                  ),
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(text: '01 / THE APPROACH'),
              const SizedBox(height: 26),
              Text(
                'We photograph people, places and moments with an '
                'editorial eye — creating images that feel honest, '
                'cinematic and timeless.',
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 34,
                  height: 1.16,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -0.8,
                ),
              ),
            ],
          );
        },
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return Column(
            children: [
              Row(
                children: [
                  Text(
                    '02 / SELECTED WORK',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.7),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '2026',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.5),
                      fontSize: 9,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: _Photo(
                        height: 640,
                        label: 'PORTRAITS',
                        alignment: Alignment.center,
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 120),
                        child: Column(
                          children: [
                            _Photo(
                              height: 280,
                              label: 'EDITORIAL',
                              alignment: Alignment.center,
                            ),
                            const SizedBox(height: 24),
                            _Photo(
                              height: 280,
                              label: 'CELEBRATIONS',
                              alignment: Alignment.center,
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
                    const _Photo(
                      height: 480,
                      label: 'PORTRAITS',
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 18),
                    const _Photo(
                      height: 300,
                      label: 'EDITORIAL',
                      alignment: Alignment.center,
                    ),
                    const SizedBox(height: 18),
                    const _Photo(
                      height: 300,
                      label: 'CELEBRATIONS',
                      alignment: Alignment.center,
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Photo extends StatefulWidget {
  const _Photo({
    required this.height,
    required this.label,
    required this.alignment,
  });

  final double height;
  final String label;
  final Alignment alignment;

  @override
  State<_Photo> createState() => _PhotoState();
}

class _PhotoState extends State<_Photo> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _entrance;
  late final Animation<double> _imageScale;

  bool _hovered = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _entrance = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _imageScale = Tween<double>(begin: 1.08, end: 1.0).animate(_entrance);

    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedBuilder(
        animation: _entrance,
        builder: (context, child) {
          return Opacity(
            opacity: _entrance.value,
            child: Transform.translate(
              offset: Offset(0, 28 * (1 - _entrance.value)),
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: SizedBox(
              width: double.infinity,
              height: widget.height,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _imageScale.value * (_hovered ? 1.035 : 1),
                        child: Image.asset(
                          'assets/images/portfolio-hero.jpg',
                          fit: BoxFit.cover,
                          alignment: widget.alignment,
                        ),
                      );
                    },
                  ),

                  AnimatedOpacity(
                    opacity: _hovered ? 1 : 0,
                    duration: const Duration(milliseconds: 350),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.espresso.withValues(alpha: 0.02),
                            AppColors.espresso.withValues(alpha: 0.82),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 18,
                    left: 18,
                    child: AnimatedOpacity(
                      opacity: _hovered ? 1 : 0.65,
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        widget.label == 'PORTRAITS'
                            ? '01'
                            : widget.label == 'EDITORIAL'
                            ? '02'
                            : '03',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 18,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: AnimatedSlide(
                            offset: _hovered
                                ? Offset.zero
                                : const Offset(0, 0.35),
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            child: AnimatedOpacity(
                              opacity: _hovered ? 1 : 0.9,
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                widget.label,
                                style: TextStyle(
                                  color: AppColors.cream,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        AnimatedScale(
                          scale: _hovered ? 1 : 0.82,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutBack,
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: AppColors.cream,
                              borderRadius: BorderRadius.circular(21),
                            ),
                            child: const Icon(
                              Icons.arrow_outward_rounded,
                              color: AppColors.brown,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Manifesto extends StatelessWidget {
  const _Manifesto();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 130, 28, 130),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow(text: '03 / OUR PHILOSOPHY'),
              const SizedBox(height: 34),
              Align(
                alignment: wide ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: wide ? 900 : 650),
                  child: Text(
                    'The most beautiful photographs are not always '
                    'the most perfect ones. They are the ones that '
                    'make you remember exactly how it felt.',
                    textAlign: wide ? TextAlign.right : TextAlign.left,
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: wide ? 54 : 38,
                      height: 1.06,
                      fontWeight: FontWeight.w300,
                      letterSpacing: -1.5,
                    ),
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

class _Closing extends StatelessWidget {
  const _Closing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 60),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return Column(
            children: [
              if (wide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        'LET’S MAKE\nSOMETHING\nTIMELESS.',
                        style: TextStyle(
                          color: AppColors.cream,
                          fontSize: 64,
                          height: 0.92,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: _ContactButton(),
                      ),
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LET’S MAKE\nSOMETHING\nTIMELESS.',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 48,
                        height: 0.94,
                        fontWeight: FontWeight.w300,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 34),
                    const _ContactButton(),
                  ],
                ),
              const SizedBox(height: 110),
              Divider(color: AppColors.cream.withValues(alpha: 0.18)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'KALLIGRAPHY',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.5,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'KAMPALA · UGANDA',
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.5),
                      fontSize: 8,
                      letterSpacing: 1.6,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => GoRouter.of(context).go('/booking'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.cream,
        side: BorderSide(color: AppColors.cream.withValues(alpha: 0.6)),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 19),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      child: const Text(
        'START A CONVERSATION  →',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.7,
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.mocha,
        fontSize: 9,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }
}
