import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  static const _portrait = 'assets/images/portfolio/portrait_woman.jpg';
  static const _wedding = 'assets/images/portfolio/couple_wedding.jpg';
  static const _baby = 'assets/images/portfolio/portrait_woman_close.jpg';
  static const _birthday = 'assets/images/portfolio/portrait_man_hat.jpg';
  static const _couples = 'assets/images/portfolio/portrait_man.jpg';
  static const _graduation = 'assets/images/portfolio/woman_landscape.jpg';
  static const _event = 'assets/images/portfolio/lake_boat.jpg';
  static const _details = 'assets/images/portfolio/hands_detail.jpg';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _PackagesHero(),
          const _Intro(),
          const _SignaturePackage(),
          const _PackageSection(
            number: '01',
            title: 'WEDDINGS',
            description: 'From the quiet moments before the ceremony to the celebration that follows, we document your wedding with intention, warmth and an editorial eye.',
            image: _wedding,
            alignment: Alignment.center,
            reverse: false,
          ),
          const _PackageSection(
            number: '02',
            title: 'BABY SHOWERS',
            description: 'A beautiful chapter deserves to be remembered. Soft details, joyful gatherings and the people who make the moment special.',
            image: _baby,
            alignment: Alignment.center,
            reverse: true,
          ),
          const _PackageSection(
            number: '03',
            title: 'BIRTHDAYS',
            description: 'Whether intimate or unforgettable, we capture the personality, people and atmosphere behind your celebration.',
            image: _birthday,
            alignment: Alignment.center,
            reverse: false,
          ),
          const _PackageSection(
            number: '04',
            title: 'PHOTOSHOOTS',
            description: 'Portrait sessions designed around you. Personal, expressive and carefully directed without ever feeling forced.',
            image: _portrait,
            alignment: Alignment.center,
            reverse: true,
          ),
          const _PackageSection(
            number: '05',
            title: 'COUPLES',
            description: 'For the two of you. Natural connection, beautiful light and photographs that feel like you rather than a performance.',
            image: _couples,
            alignment: Alignment.center,
            reverse: false,
          ),
          const _PackageSection(
            number: '06',
            title: 'GRADUATIONS',
            description: 'A milestone worth more than a certificate. Celebrate the person, the journey and everything that brought you here.',
            image: _graduation,
            alignment: Alignment.center,
            reverse: true,
          ),
          const _PackageSection(
            number: '07',
            title: 'EVENTS',
            description: 'Private celebrations, launches, gatherings and special occasions documented with a refined editorial approach.',
            image: _event,
            alignment: Alignment.center,
            reverse: false,
          ),
          const _MoreServices(image: _details),
          const _PackagesClosing(),
        ],
      ),
    );
  }
}

class _PackagesHero extends StatelessWidget {
  const _PackagesHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;

        return Container(
          color: AppColors.cream,
          padding: EdgeInsets.fromLTRB(
            mobile ? 24 : 72,
            mobile ? 132 : 160,
            mobile ? 24 : 72,
            mobile ? 70 : 110,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '05 / PACKAGES',
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: 850,
                child: Text(
                  'Moments worth\nremembering.',
                  style: TextStyle(
                    color: AppColors.espresso,
                    fontFamily: 'CormorantGaramond',
                    fontSize: mobile ? 58 : 100,
                    height: .88,
                    letterSpacing: -2.5,
                  ),
                ),
              ),
              const SizedBox(height: 36),
              SizedBox(
                width: 560,
                child: Text(
                  'Photography packages for weddings, celebrations, portraits and all the beautiful chapters in between.',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 15,
                    height: 1.8,
                    letterSpacing: .2,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;

        return Container(
          color: AppColors.ivory,
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 24 : 72,
            vertical: mobile ? 70 : 110,
          ),
          child: Flex(
            direction: mobile ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: mobile ? 0 : 2,
                child: Text(
                  'THE RIGHT\nPACKAGE FOR\nYOUR STORY.',
                  style: TextStyle(
                    color: AppColors.espresso,
                    fontFamily: 'CormorantGaramond',
                    fontSize: mobile ? 42 : 58,
                    height: .95,
                  ),
                ),
              ),
              if (mobile) const SizedBox(height: 36),
              Expanded(
                flex: mobile ? 0 : 2,
                child: Text(
                  'Every celebration is different. Our packages provide a starting point, while each session can be shaped around your people, your location and the story you want to remember.',
                  style: TextStyle(
                    color: AppColors.brown,
                    fontSize: 14,
                    height: 1.9,
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

class _SignaturePackage extends StatelessWidget {
  const _SignaturePackage();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;

        return Container(
          color: AppColors.espresso,
          padding: EdgeInsets.all(mobile ? 24 : 72),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'THE KALLYGRAPHY EXPERIENCE',
                style: TextStyle(
                  color: AppColors.beige,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'A little more than\njust photographs.',
                style: TextStyle(
                  color: AppColors.ivory,
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 48 : 76,
                  height: .92,
                ),
              ),
              const SizedBox(height: 32),
              if (mobile)
                Column(
                  children: [
                    _ExperienceImage(),
                    const SizedBox(height: 28),
                    _ExperienceText(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(flex: 3, child: _ExperienceImage()),
                    const SizedBox(width: 70),
                    Expanded(flex: 2, child: _ExperienceText()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ExperienceImage extends StatelessWidget {
  const _ExperienceImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: AspectRatio(
        aspectRatio: 1.15,
        child: Image.asset(PackagesScreen._portrait, fit: BoxFit.cover),
      ),
    );
  }
}

class _ExperienceText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A considered experience from first conversation to final gallery.',
          style: TextStyle(
            color: AppColors.ivory,
            fontFamily: 'CormorantGaramond',
            fontSize: 30,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pre-session consultation\n'
          'Professional photography direction\n'
          'Carefully edited final photographs\n'
          'Private online gallery\n'
          'Print-ready images',
          style: TextStyle(color: AppColors.beige, fontSize: 13, height: 2.1),
        ),
      ],
    );
  }
}

class _PackageSection extends StatelessWidget {
  const _PackageSection({
    required this.number,
    required this.title,
    required this.description,
    required this.image,
    required this.alignment,
    required this.reverse,
  });

  final String number;
  final String title;
  final String description;
  final String image;
  final Alignment alignment;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;

        final imageWidget = ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: AspectRatio(
            aspectRatio: mobile ? 1.15 : .95,
            child: Image.asset(image, fit: BoxFit.cover, alignment: alignment),
          ),
        );

        final textWidget = Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 0 : 20,
            vertical: mobile ? 30 : 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                number,
                style: TextStyle(
                  color: AppColors.mocha,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                title,
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 48 : 62,
                  height: .9,
                ),
              ),
              const SizedBox(height: 26),
              Text(
                description,
                style: TextStyle(
                  color: AppColors.brown,
                  fontSize: 14,
                  height: 1.9,
                ),
              ),
              const SizedBox(height: 30),
              _ArrowButton(
                label: 'INQUIRE',
                onTap: () => context.go('/booking'),
              ),
            ],
          ),
        );

        return Container(
          color: AppColors.cream,
          padding: EdgeInsets.symmetric(
            horizontal: mobile ? 24 : 72,
            vertical: mobile ? 65 : 100,
          ),
          child: mobile
              ? Column(children: [imageWidget, textWidget])
              : Row(
                  children: reverse
                      ? [
                          Expanded(child: textWidget),
                          const SizedBox(width: 70),
                          Expanded(child: imageWidget),
                        ]
                      : [
                          Expanded(child: imageWidget),
                          const SizedBox(width: 70),
                          Expanded(child: textWidget),
                        ],
                ),
        );
      },
    );
  }
}

class _MoreServices extends StatelessWidget {
  const _MoreServices({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mobile = constraints.maxWidth < 800;

        return Container(
          color: AppColors.ivory,
          padding: EdgeInsets.fromLTRB(
            mobile ? 24 : 72,
            mobile ? 65 : 100,
            mobile ? 24 : 72,
            mobile ? 75 : 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AND MORE',
                style: TextStyle(
                  color: AppColors.mocha,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.2,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Something a little\ndifferent?',
                style: TextStyle(
                  color: AppColors.espresso,
                  fontFamily: 'CormorantGaramond',
                  fontSize: mobile ? 50 : 72,
                  height: .9,
                ),
              ),
              const SizedBox(height: 42),
              if (mobile)
                Column(
                  children: [
                    _MoreImage(image: image),
                    const SizedBox(height: 32),
                    _MoreList(),
                  ],
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _MoreImage(image: image)),
                    const SizedBox(width: 80),
                    const Expanded(flex: 2, child: _MoreList()),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _MoreImage extends StatelessWidget {
  const _MoreImage({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: AspectRatio(
        aspectRatio: 1.45,
        child: Image.asset(image, fit: BoxFit.cover),
      ),
    );
  }
}

class _MoreList extends StatelessWidget {
  const _MoreList();

  static const services = [
    'Corporate & Brand',
    'Family Sessions',
    'Maternity',
    'Engagements',
    'Private Events',
    'Content Creation',
    'Product Photography',
    'Lifestyle Sessions',
    'Custom Projects',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < services.length; i++)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 17),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Text(
                  (i + 1).toString().padLeft(2, '0'),
                  style: TextStyle(
                    color: AppColors.mocha,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Text(
                    services[i],
                    style: TextStyle(
                      color: AppColors.espresso,
                      fontFamily: 'CormorantGaramond',
                      fontSize: 24,
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

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.brown,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
            ),
          ),
          const SizedBox(width: 12),
          Icon(Icons.arrow_forward_rounded, size: 17, color: AppColors.brown),
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
      color: AppColors.brown,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 100),
      child: Column(
        children: [
          Text(
            'YOUR MOMENT.\nYOUR STORY.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.ivory,
              fontFamily: 'CormorantGaramond',
              fontSize: 56,
              height: .9,
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Tell us what you are planning.',
            style: TextStyle(color: AppColors.sand, fontSize: 13),
          ),
          const SizedBox(height: 30),
          Material(
            color: AppColors.ivory,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () => context.go('/booking'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 28, vertical: 15),
                child: Text(
                  'START AN INQUIRY',
                  style: TextStyle(
                    color: AppColors.espresso,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.7,
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
