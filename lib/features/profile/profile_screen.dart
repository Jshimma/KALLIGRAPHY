import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _portrait = 'assets/images/portfolio/portrait_woman_close.jpg';
  static const _landscape = 'assets/images/portfolio/kampala_landscape.jpg';
  static const _detail = 'assets/images/portfolio/camera_detail.jpg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _AboutHero(),
          _Story(),
          _Values(),
          _VisualBreak(),
          _Process(),
          _AboutClosing(),
        ],
      ),
    );
  }
}

class _AboutHero extends StatelessWidget {
  const _AboutHero();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;

    return Container(
      color: AppColors.cream,
      padding: EdgeInsets.fromLTRB(
        28,
        mobile ? 150 : 170,
        28,
        mobile ? 90 : 120,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('ABOUT / KALLYGRAPHY'),
              const SizedBox(height: 42),
              Text(
                'Photographs\nwith a point\nof view.',
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 70 : 112,
                  height: 0.84,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 55),
              Align(
                alignment: Alignment.centerRight,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Text(
                    'KALLYGRAPHY is a photography studio built around '
                    'honest moments, beautiful light and photographs '
                    'that continue to mean something long after they '
                    'were taken.',
                    style: TextStyle(
                      color: AppColors.brown,
                      fontSize: 15,
                      height: 1.75,
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

class _Story extends StatelessWidget {
  const _Story();

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 800;

    return Container(
      color: AppColors.brown,
      padding: const EdgeInsets.fromLTRB(28, 90, 28, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _eyebrow(
                      '01 / THE STUDIO',
                      color: AppColors.cream.withValues(alpha: 0.72),
                    ),
                    const SizedBox(height: 35),
                    _StoryText(),
                    const SizedBox(height: 55),
                    _StudioImage(),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _eyebrow(
                        '01 / THE STUDIO',
                        color: AppColors.cream.withValues(alpha: 0.72),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: _StoryText(color: AppColors.cream),
                    ),
                    const SizedBox(width: 70),
                    const Expanded(flex: 4, child: _StudioImage()),
                  ],
                ),
        ),
      ),
    );
  }
}

class _StoryText extends StatelessWidget {
  const _StoryText({this.color = AppColors.cream});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      'We believe the strongest photographs are not forced. '
      'They happen when people feel comfortable, when light '
      'falls naturally and when there is enough space for a '
      'real moment to unfold.\n\n'
      'Our approach is intentional but never rigid. We observe, '
      'we guide when needed and we let the story lead.',
      style: TextStyle(
        color: color,
        fontFamily: 'CormorantGaramond',
        fontSize: MediaQuery.sizeOf(context).width < 700 ? 38 : 48,
        height: 1.12,
      ),
    );
  }
}

class _StudioImage extends StatelessWidget {
  const _StudioImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: AspectRatio(
        aspectRatio: 0.82,
        child: Image.asset(ProfileScreen._portrait, fit: BoxFit.cover),
      ),
    );
  }
}

class _Values extends StatelessWidget {
  const _Values();

  static const _items = [
    (
      '01',
      'HONEST',
      'We look for photographs that feel like you, not photographs that simply look good.',
    ),
    (
      '02',
      'INTENTIONAL',
      'Every frame has a reason. From composition to light, details are considered.',
    ),
    (
      '03',
      'TIMELESS',
      'We create images designed to remain beautiful when trends have moved on.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('02 / WHAT MATTERS'),
              const SizedBox(height: 55),
              LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 800;

                  if (!wide) {
                    return Column(
                      children: [
                        for (var i = 0; i < _items.length; i++) ...[
                          _ValueItem(
                            number: _items[i].$1,
                            title: _items[i].$2,
                            body: _items[i].$3,
                          ),
                          if (i != _items.length - 1)
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
                      for (var i = 0; i < _items.length; i++) ...[
                        Expanded(
                          child: _ValueItem(
                            number: _items[i].$1,
                            title: _items[i].$2,
                            body: _items[i].$3,
                          ),
                        ),
                        if (i != _items.length - 1) const SizedBox(width: 55),
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

class _ValueItem extends StatelessWidget {
  const _ValueItem({
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
          style: TextStyle(
            color: AppColors.mocha,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 22),
        Text(
          title,
          style: TextStyle(
            color: AppColors.espresso,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          body,
          style: TextStyle(color: AppColors.brown, fontSize: 14, height: 1.7),
        ),
      ],
    );
  }
}

class _VisualBreak extends StatelessWidget {
  const _VisualBreak();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).width < 700 ? 500 : 650,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(ProfileScreen._landscape, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.espresso.withValues(alpha: 0.05),
                  AppColors.espresso.withValues(alpha: 0.65),
                ],
              ),
            ),
          ),
          Positioned(
            left: 28,
            bottom: 35,
            child: Text(
              'KAMPALA · UGANDA',
              style: TextStyle(
                color: AppColors.ivory,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Process extends StatelessWidget {
  const _Process();

  static const _steps = [
    (
      '01',
      'DISCOVER',
      'We begin with a conversation about your story, your vision and what matters to you.',
    ),
    (
      '02',
      'CREATE',
      'The shoot is relaxed, considered and guided around the people and moments in front of us.',
    ),
    (
      '03',
      'DELIVER',
      'Your final photographs are carefully selected and finished so they feel unmistakably yours.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _eyebrow('03 / THE EXPERIENCE'),
              const SizedBox(height: 45),
              Text(
                'Simple by design.',
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: MediaQuery.sizeOf(context).width < 700 ? 52 : 72,
                ),
              ),
              const SizedBox(height: 60),
              for (var i = 0; i < _steps.length; i++) ...[
                _ProcessStep(
                  number: _steps[i].$1,
                  title: _steps[i].$2,
                  body: _steps[i].$3,
                ),
                if (i != _steps.length - 1)
                  const Divider(height: 65, color: AppColors.border),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessStep extends StatelessWidget {
  const _ProcessStep({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final mobile = MediaQuery.sizeOf(context).width < 700;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: mobile ? 55 : 100,
          child: Text(
            number,
            style: TextStyle(
              color: AppColors.mocha,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: mobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.espresso,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      body,
                      style: const TextStyle(
                        color: AppColors.brown,
                        fontSize: 14,
                        height: 1.7,
                      ),
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 220,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppColors.espresso,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        body,
                        style: const TextStyle(
                          color: AppColors.brown,
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _AboutClosing extends StatelessWidget {
  const _AboutClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(28, 110, 28, 100),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COME AS YOU ARE.\nLEAVE WITH\nSOMETHING\nTIMELESS.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'CormorantGaramond',
                  fontSize: MediaQuery.sizeOf(context).width < 700 ? 55 : 82,
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
              const SizedBox(height: 75),
              Row(
                children: [
                  SizedBox(
                    width: 115,
                    child: Image.asset(
                      ProfileScreen._detail,
                      height: 65,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'KALLYGRAPHY\nPHOTOGRAPHY STUDIO',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: AppColors.cream.withValues(alpha: 0.55),
                      fontSize: 9,
                      height: 1.7,
                      letterSpacing: 1.5,
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
