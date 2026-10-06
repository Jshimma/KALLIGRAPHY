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

        return Container(
          color: AppColors.cream,
          padding: EdgeInsets.fromLTRB(
            wide ? 72 : 22,
            wide ? 62 : 38,
            wide ? 72 : 22,
            wide ? 88 : 58,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1320),
              child: wide ? const _DesktopHero() : const _MobileHero(),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(flex: 56, child: _HeroPortrait()),
            const SizedBox(width: 72),
            Expanded(
              flex: 44,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _HeroCopy(),
              ),
            ),
          ],
        ),
        const Positioned(
          left: 0,
          top: 0,
          child: _Eyebrow('01 · THE PERSON BEHIND THE LENS'),
        ),
        const Positioned(
          right: 0,
          bottom: 0,
          child: _VerticalMark('KALLIGRAPHY'),
        ),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Eyebrow('01 · THE PERSON BEHIND THE LENS'),
        SizedBox(height: 24),
        _HeroPortrait(),
        SizedBox(height: 34),
        _HeroCopy(),
      ],
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.sand,
      constraints: const BoxConstraints(maxWidth: 680),
      child: AspectRatio(
        aspectRatio: .84,
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
        Text(
          'KALIISA\nRYAN.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: mobile ? 52 : 70,
            height: .78,
            letterSpacing: -3,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 30),
        Container(width: 54, height: 2, color: AppColors.mocha),
        const SizedBox(height: 25),
        const Text(
          'PHOTOGRAPHER · VIDEOGRAPHER\nGRAPHICS DESIGNER',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1.8,
            letterSpacing: 1.7,
            color: AppColors.brown,
          ),
        ),
        const SizedBox(height: 30),
        Text(
          'Creating photographs that feel like something you remember.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: mobile ? 28 : 38,
            height: 1.12,
            color: AppColors.darkBrown,
          ),
        ),
        const SizedBox(height: 32),
        OutlinedButton(
          onPressed: () => context.go('/booking'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.espresso,
            side: const BorderSide(color: AppColors.espresso),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            shape: const StadiumBorder(),
          ),
          child: const Text(
            'WORK WITH RYAN',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
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
      color: AppColors.espresso,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 72 : 112,
        mobile ? 24 : 72,
        mobile ? 76 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('02 · THE PHILOSOPHY', color: AppColors.sand),
              const SizedBox(height: 28),
              Text(
                'THE BEST PHOTOGRAPHS\nDON’T JUST SHOW YOU WHAT HAPPENED.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 39 : 60,
                  height: .9,
                  letterSpacing: -1.4,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 42),
              Row(
                children: [
                  Container(width: 42, height: 1, color: AppColors.mocha),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Text(
                      'They bring you back to how it felt.',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 27,
                        height: 1.2,
                        fontStyle: FontStyle.italic,
                        color: AppColors.sand,
                      ),
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
        mobile ? 88 : 135,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: mobile
              ? const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_StoryLabel(), SizedBox(height: 38), _StoryText()],
                )
              : const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _StoryLabel()),
                    SizedBox(width: 90),
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
          'THE EYE\nBEHIND THE\nIMAGE.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 38,
            height: .88,
            letterSpacing: -1,
            color: AppColors.espresso,
          ),
        ),
        SizedBox(height: 30),
        Text(
          'K · R',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 32,
            fontStyle: FontStyle.italic,
            color: AppColors.mocha,
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
            height: 1.22,
            color: AppColors.darkBrown,
          ),
        ),
        SizedBox(height: 34),
        _StoryParagraph(
          'My work is built around observation. The expression that happens '
          'for half a second. The quiet before everyone arrives. The way '
          'people look at each other when they forget the camera is there.',
        ),
        SizedBox(height: 24),
        _StoryParagraph(
          'From weddings and traditional celebrations to portraits, '
          'introductions, fashion and everyday moments, I approach each '
          'story with intention — creating photographs that remain '
          'personal long after the day is over.',
        ),
      ],
    );
  }
}

class _StoryParagraph extends StatelessWidget {
  const _StoryParagraph(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Manrope',
        fontSize: 13.5,
        height: 1.9,
        color: AppColors.brown,
      ),
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
        mobile ? 76 : 108,
        mobile ? 24 : 72,
        mobile ? 82 : 118,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('04 · WHAT I CREATE'),
              const SizedBox(height: 22),
              Text(
                'MORE THAN\nA CAMERA.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 46 : 64,
                  height: .86,
                  letterSpacing: -1.5,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 55),
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
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.mocha, width: 1),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontFamily: 'Manrope',
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: AppColors.mocha,
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.8,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 15),
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

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        mobile ? 18 : 40,
        mobile ? 18 : 40,
        mobile ? 18 : 40,
        mobile ? 28 : 55,
      ),
      child: mobile
          ? Column(
              children: [
                _Frame(image: ProfileScreen._workImages[0], aspectRatio: .82),
                const SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _Frame(
                        image: ProfileScreen._workImages[1],
                        aspectRatio: .78,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _Frame(
                        image: ProfileScreen._workImages[2],
                        aspectRatio: .78,
                      ),
                    ),
                  ],
                ),
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
                  flex: 8,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 92),
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
        child: Image.asset(
          image,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.image_outlined, color: AppColors.brown),
            );
          },
        ),
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
      color: AppColors.darkBrown,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 72,
        mobile ? 80 : 118,
        mobile ? 24 : 72,
        mobile ? 88 : 128,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('05 · THE APPROACH', color: AppColors.sand),
              const SizedBox(height: 30),
              Text(
                'I WANT THE PHOTOGRAPH\nTO FEEL LIKE THE MOMENT.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 40 : 58,
                  height: .9,
                  letterSpacing: -1.1,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 45),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 2, height: 88, color: AppColors.mocha),
                  const SizedBox(width: 22),
                  const Expanded(
                    child: Text(
                      'Beautiful is important. But feeling is everything. '
                      'I look for the details that make a photograph personal — '
                      'the people, the atmosphere, the movement and the small '
                      'things you may not notice until later.',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13.5,
                        height: 1.9,
                        color: AppColors.sand,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 38),
              const Text(
                'OBSERVE · CREATE · PRESERVE',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 9.5,
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
        mobile ? 78 : 112,
        mobile ? 24 : 72,
        mobile ? 92 : 128,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1220),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('06 · YOUR STORY', color: AppColors.sand),
              const SizedBox(height: 26),
              Text(
                'YOUR MOMENT\nDESERVES TO BE REMEMBERED.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 41 : 60,
                  height: .9,
                  letterSpacing: -1,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 30),
              const SizedBox(
                width: 590,
                child: Text(
                  'Whether it is a wedding, portrait session, celebration '
                  'or an idea waiting to become real, let’s create '
                  'something that still feels like you years from now.',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 13.5,
                    height: 1.85,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () => context.go('/booking'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.mocha,
                  foregroundColor: AppColors.cream,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 17,
                  ),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  'START A CONVERSATION',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 9.5,
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

class _VerticalMark extends StatelessWidget {
  const _VerticalMark(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Manrope',
          fontSize: 8,
          fontWeight: FontWeight.w700,
          letterSpacing: 3,
          color: AppColors.muted,
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
        fontSize: 9.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.1,
        color: color,
      ),
    );
  }
}
