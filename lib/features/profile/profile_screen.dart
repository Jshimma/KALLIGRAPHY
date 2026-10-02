import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _portrait = 'assets/images/brand/NYCT.jpg';

  static const _workImages = [
    'assets/images/ryan/Wedding.jpg',
    'assets/images/ryan/Introduction.jpg',
    'assets/images/ryan/photoshoot.jpg',
    'assets/images/ryan/graduation.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _AboutHero(),
          const _AboutRyan(),
          const _CreativeWork(),
          const _Approach(),
          const _VisualStory(),
          const _AboutClosing(),
        ],
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 60,
        mobile ? 120 : 150,
        mobile ? 24 : 60,
        mobile ? 70 : 110,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _HeroPortrait(),
                    const SizedBox(height: 45),
                    const _HeroIdentity(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(flex: 6, child: _HeroPortrait()),
                    const SizedBox(width: 90),
                    const Expanded(flex: 5, child: _HeroIdentity()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroPortrait extends StatelessWidget {
  const _HeroPortrait();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Image.asset(ProfileScreen._portrait, fit: BoxFit.cover),
      ),
    );
  }
}

class _HeroIdentity extends StatelessWidget {
  const _HeroIdentity();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('ABOUT / KALIISA RYAN'),
        const SizedBox(height: 30),
        Text(
          'KALIISA\nRYAN',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: mobile ? 72 : 104,
            height: 0.82,
            fontWeight: FontWeight.w400,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 32),
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
        const SizedBox(height: 32),
        const Text(
          'Creating visual stories with feeling, detail and intention.',
          style: TextStyle(
            fontFamily: 'CormorantGaramond',
            fontSize: 28,
            height: 1.25,
            color: AppColors.espresso,
          ),
        ),
      ],
    );
  }
}

class _AboutRyan extends StatelessWidget {
  const _AboutRyan();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.brown,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 60,
        mobile ? 75 : 110,
        mobile ? 24 : 60,
        mobile ? 85 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('01 / ABOUT RYAN', color: AppColors.cream),
                    const SizedBox(height: 35),
                    const _RyanStory(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      flex: 3,
                      child: _Eyebrow(
                        '01 / ABOUT RYAN',
                        color: AppColors.cream,
                      ),
                    ),
                    const Expanded(flex: 7, child: _RyanStory()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _RyanStory extends StatelessWidget {
  const _RyanStory();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'I am Kaliisa Ryan — a photographer, videographer and '
      'graphics designer with a passion for creating visual stories.\n\n'
      'My work is shaped by a strong aesthetic sense, technical '
      'knowledge of modern camera technologies, attention to detail '
      'and an understanding of how to bring a creative idea to life.\n\n'
      'From weddings and traditional events to fashion, beauty and '
      'portrait photography, I focus on creating images that feel '
      'intentional, expressive and memorable.',
      style: TextStyle(
        fontFamily: 'CormorantGaramond',
        fontSize: 34,
        height: 1.25,
        color: AppColors.cream,
      ),
    );
  }
}

class _CreativeWork extends StatelessWidget {
  const _CreativeWork();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 60,
        mobile ? 80 : 120,
        mobile ? 24 : 60,
        mobile ? 85 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('02 / THE CREATIVE WORK'),
              const SizedBox(height: 28),
              Text(
                'Three ways I\ncreate.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 62 : 86,
                  height: 0.9,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 65),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 800;

                  final items = [
                    (
                      '01',
                      'PHOTOGRAPHY',
                      'Portraits, weddings, introductions, celebrations, '
                          'fashion, beauty and the moments in between.',
                    ),
                    (
                      '02',
                      'VIDEOGRAPHY',
                      'Moving images that preserve atmosphere, emotion '
                          'and the story behind an important day.',
                    ),
                    (
                      '03',
                      'GRAPHICS DESIGN',
                      'Visual identities and creative designs that give '
                          'an idea its own visual language.',
                    ),
                  ];

                  if (!wide) {
                    return Column(
                      children: [
                        for (var i = 0; i < items.length; i++) ...[
                          _CreativeItem(
                            number: items[i].$1,
                            title: items[i].$2,
                            body: items[i].$3,
                          ),
                          if (i != items.length - 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 35),
                              child: Divider(color: AppColors.border),
                            ),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        Expanded(
                          child: _CreativeItem(
                            number: items[i].$1,
                            title: items[i].$2,
                            body: items[i].$3,
                          ),
                        ),
                        if (i != items.length - 1) const SizedBox(width: 55),
                      ],
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

class _CreativeItem extends StatelessWidget {
  const _CreativeItem({
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
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: AppColors.espresso,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          body,
          style: const TextStyle(
            fontSize: 14,
            height: 1.75,
            color: AppColors.brown,
          ),
        ),
      ],
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
        mobile ? 24 : 60,
        mobile ? 80 : 120,
        mobile ? 24 : 60,
        mobile ? 90 : 130,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('03 / THE APPROACH', color: AppColors.sand),
              const SizedBox(height: 35),
              Text(
                'I want the photograph\nto feel like the moment.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 50 : 76,
                  height: 0.98,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 45),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 620),
                child: const Text(
                  'For me, photography is not only about making an '
                  'image look beautiful. It is about noticing what is '
                  'already there — the expression, the movement, the '
                  'connection, the atmosphere — and preserving it with '
                  'care.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.8,
                    color: AppColors.sand,
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

class _VisualStory extends StatelessWidget {
  const _VisualStory();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 60,
        mobile ? 80 : 120,
        mobile ? 24 : 60,
        mobile ? 85 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('04 / IN FRAME'),
              const SizedBox(height: 35),
              Text(
                'A few frames\nfrom the work.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 58 : 80,
                  height: 0.9,
                  color: AppColors.espresso,
                ),
              ),
              const SizedBox(height: 55),
              LayoutBuilder(
                builder: (context, constraints) {
                  final gap = mobile ? 12.0 : 22.0;

                  if (mobile) {
                    return Column(
                      children: [
                        for (final image in ProfileScreen._workImages) ...[
                          _WorkImage(image: image),
                          if (image != ProfileScreen._workImages.last)
                            SizedBox(height: gap),
                        ],
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 13,
                        child: _WorkImage(
                          image: ProfileScreen._workImages[0],
                          aspectRatio: 0.78,
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        flex: 9,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 100),
                          child: _WorkImage(
                            image: ProfileScreen._workImages[1],
                            aspectRatio: 0.78,
                          ),
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        flex: 10,
                        child: _WorkImage(
                          image: ProfileScreen._workImages[2],
                          aspectRatio: 0.78,
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (!mobile) ...[
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 360,
                    child: _WorkImage(
                      image: ProfileScreen._workImages[3],
                      aspectRatio: 1.2,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkImage extends StatelessWidget {
  const _WorkImage({required this.image, this.aspectRatio = 0.82});

  final String image;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Image.asset(image, fit: BoxFit.cover),
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
      color: AppColors.brown,
      padding: EdgeInsets.fromLTRB(
        mobile ? 24 : 60,
        mobile ? 80 : 110,
        mobile ? 24 : 60,
        mobile ? 90 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Eyebrow('05 / LET’S CREATE', color: AppColors.sand),
              const SizedBox(height: 30),
              Text(
                'Let’s make something\nworth remembering.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 54 : 78,
                  height: 0.95,
                  color: AppColors.cream,
                ),
              ),
              const SizedBox(height: 35),
              const SizedBox(
                width: 580,
                child: Text(
                  'If you have a story, an idea or a moment you want '
                  'captured with intention, I would love to hear about it.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.75,
                    color: AppColors.sand,
                  ),
                ),
              ),
              const SizedBox(height: 38),
              _PillButton(
                label: 'INQUIRE',
                onPressed: () => context.go('/booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.text, {this.color = AppColors.brown});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.3,
        color: color,
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.cream,
        side: const BorderSide(color: AppColors.cream, width: 0.8),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 17),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
        ),
      ),
    );
  }
}
