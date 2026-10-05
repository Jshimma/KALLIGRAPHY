import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _portrait = 'assets/images/brand/NYCT.jpg';

  static const _workImages = [
    'assets/images/ryan/Wedding.jpg',
    'assets/images/ryan/Introduction4.jpg',
    'assets/images/ryan/photoshoot.jpg',
    'assets/images/ryan/Moments4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.cream,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _AboutHero(),
            const _Manifesto(),
            const _AboutStory(),
            const _Disciplines(),
            const _VisualInterlude(),
            const _Approach(),
            const _AboutClosing(),
          ],
        ),
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            wide ? 72 : 24,
            wide ? 110 : 70,
            wide ? 72 : 24,
            wide ? 105 : 70,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280),
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(flex: 51, child: _HeroPortrait()),
                        const SizedBox(width: 90),
                        const Expanded(flex: 49, child: _HeroCopy()),
                      ],
                    )
                  : const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _HeroPortrait(),
                        SizedBox(height: 48),
                        _HeroCopy(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      constraints: const BoxConstraints(maxWidth: 610),
      child: AspectRatio(
        aspectRatio: .82,
        child: Image.asset(
          ProfileScreen._portrait,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.person_outline,
                size: 48,
                color: AppColors.brown,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 900;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('01 · THE PERSON BEHIND THE LENS'),
        const SizedBox(height: 28),
        Text(
          'KALIISA\nRYAN.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: mobile ? 78 : 108,
            height: .79,
            letterSpacing: -2.5,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 34),
        Container(width: 48, height: 1, color: AppColors.mocha),
        const SizedBox(height: 26),
        const Text(
          'PHOTOGRAPHER · VIDEOGRAPHER\nGRAPHICS DESIGNER',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.8,
            letterSpacing: 1.8,
            color: AppColors.brown,
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Creating photographs that feel like something you remember.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: mobile ? 29 : 35,
            height: 1.2,
            color: AppColors.darkBrown,
          ),
        ),
      ],
    );
  }
}

class _Manifesto extends StatelessWidget {
  const _Manifesto();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 78 : 115,
        mobile ? 24 : 72,
        mobile ? 82 : 125,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('02 · THE PHILOSOPHY', color: AppColors.sand),
              const SizedBox(height: 30),
              Text(
                'THE BEST PHOTOGRAPHS\nDON’T JUST SHOW YOU\nWHAT HAPPENED.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 49 : 78,
                  height: .91,
                  letterSpacing: -1.2,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 38),
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 540),
                  child: const Text(
                    'They bring you back to how it felt.',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: 'CormorantGaramond',
                      fontSize: 28,
                      height: 1.2,
                      fontStyle: FontStyle.italic,
                      color: AppColors.sand,
                    ),
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

class _AboutStory extends StatelessWidget {
  const _AboutStory();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 850;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 82 : 125,
        mobile ? 24 : 72,
        mobile ? 90 : 135,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: mobile
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_StoryLabel(), SizedBox(height: 36), _StoryText()],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _StoryLabel()),
                    SizedBox(width: 70),
                    Expanded(flex: 7, child: _StoryText()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _StoryLabel extends StatelessWidget {
  const _StoryLabel();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow('03 · THE STORY'),
        SizedBox(height: 18),
        Text(
          'THE EYE\nBEHIND\nTHE IMAGE.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 43,
            height: .9,
            color: AppColors.espresso,
          ),
        ),
      ],
    );
  }
}

class _StoryText extends StatelessWidget {
  const _StoryText();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'I am Kaliisa Ryan — a photographer, videographer and graphics '
          'designer driven by the belief that meaningful images should '
          'feel as good as they look.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 32,
            height: 1.25,
            color: AppColors.darkBrown,
          ),
        ),
        SizedBox(height: 30),
        Text(
          'My work is built around observation. The expression that happens '
          'for half a second. The quiet before everyone arrives. The way '
          'people look at each other when they forget the camera is there.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            height: 1.85,
            color: AppColors.brown,
          ),
        ),
        SizedBox(height: 22),
        Text(
          'From weddings and traditional celebrations to portraits, '
          'introductions, fashion and everyday moments, I approach each '
          'story with intention — creating photographs that remain '
          'personal long after the day is over.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            height: 1.85,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}

class _Disciplines extends StatelessWidget {
  const _Disciplines();

  static const _items = [
    (
      '01',
      'PHOTOGRAPHY',
      'Weddings, portraits, introductions, celebrations and the honest '
          'moments between them.',
    ),
    (
      '02',
      'VIDEOGRAPHY',
      'Moving images that preserve atmosphere, energy and the story '
          'behind an important day.',
    ),
    (
      '03',
      'GRAPHICS DESIGN',
      'Visual identities and creative design with the same attention '
          'to detail brought to every photograph.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 850;

    return Container(
      color: AppColors.sand,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 78 : 110,
        mobile ? 24 : 72,
        mobile ? 82 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('04 · WHAT I CREATE'),
              const SizedBox(height: 25),
              Text(
                'MORE THAN\nA CAMERA.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 58 : 82,
                  height: .87,
                  letterSpacing: -1.5,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 58),
              if (mobile)
                Column(
                  children: [
                    for (var i = 0; i < _items.length; i++) ...[
                      _DisciplineItem(
                        number: _items[i].$1,
                        title: _items[i].$2,
                        body: _items[i].$3,
                      ),
                      if (i != _items.length - 1)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 34),
                          child: Divider(color: AppColors.border),
                        ),
                    ],
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _items.length; i++) ...[
                      Expanded(
                        child: _DisciplineItem(
                          number: _items[i].$1,
                          title: _items[i].$2,
                          body: _items[i].$3,
                        ),
                      ),
                      if (i != _items.length - 1) const SizedBox(width: 55),
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

class _DisciplineItem extends StatelessWidget {
  const _DisciplineItem({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.mocha,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 17),
        Text(
          body,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 13,
            height: 1.8,
            color: AppColors.brown,
          ),
        ),
      ],
    );
  }
}

class _VisualInterlude extends StatelessWidget {
  const _VisualInterlude();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 850;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        mobile ? 18 : 40,
        mobile ? 18 : 40,
        mobile ? 18 : 40,
        mobile ? 18 : 40,
      ),
      child: mobile
          ? Column(
              children: [
                _Frame(image: ProfileScreen._workImages[0], aspectRatio: .82),
                const SizedBox(height: 18),
                _Frame(image: ProfileScreen._workImages[1], aspectRatio: .82),
                const SizedBox(height: 18),
                _Frame(image: ProfileScreen._workImages[2], aspectRatio: .82),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 12,
                  child: _Frame(
                    image: ProfileScreen._workImages[0],
                    aspectRatio: .78,
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 95),
                    child: _Frame(
                      image: ProfileScreen._workImages[1],
                      aspectRatio: .78,
                    ),
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  flex: 10,
                  child: _Frame(
                    image: ProfileScreen._workImages[2],
                    aspectRatio: .78,
                  ),
                ),
              ],
            ),
    );
  }
}

class _Frame extends StatelessWidget {
  const _Frame({required this.image, required this.aspectRatio});

  final String image;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(image, fit: BoxFit.contain),
      ),
    );
  }
}

class _Approach extends StatelessWidget {
  const _Approach();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.espresso,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 82 : 120,
        mobile ? 24 : 72,
        mobile ? 90 : 135,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('05 · THE APPROACH', color: AppColors.sand),
              const SizedBox(height: 30),
              Text(
                'I WANT THE\nPHOTOGRAPH TO\nFEEL LIKE THE\nMOMENT.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 52 : 76,
                  height: .89,
                  letterSpacing: -1,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 42),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: const Text(
                  'Beautiful is important. But feeling is everything. '
                  'I look for the details that make a photograph personal — '
                  'the people, the atmosphere, the movement and the small '
                  'things you may not notice until later.',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    height: 1.9,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Container(width: 55, height: 1, color: AppColors.mocha),
              const SizedBox(height: 25),
              const Text(
                'OBSERVE · CREATE · PRESERVE',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                  color: AppColors.cream,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutClosing extends StatelessWidget {
  const _AboutClosing();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      width: double.infinity,
      color: AppColors.brown,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 82 : 115,
        mobile ? 24 : 72,
        mobile ? 95 : 130,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('06 · YOUR STORY', color: AppColors.sand),
              const SizedBox(height: 28),
              Text(
                'YOUR MOMENT\nDESERVES TO BE\nREMEMBERED.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 53 : 78,
                  height: .9,
                  letterSpacing: -1,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(
                width: 570,
                child: Text(
                  'Whether it is a wedding, portrait session, celebration '
                  'or an idea waiting to become real, let’s create '
                  'something that still feels like you years from now.',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    height: 1.85,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 38),
              FilledButton(
                onPressed: () => context.go('/booking'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mocha,
                  foregroundColor: AppColors.cream,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 18,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'START A CONVERSATION',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.7,
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

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color = AppColors.mocha});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.2,
        color: color,
      ),
    );
  }
}
