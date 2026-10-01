import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  static const _photos = [
    _PortfolioPhoto(
      'assets/images/portfolio/portrait_woman.jpg',
      'Portraits',
      'Quiet confidence',
      1,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/portrait_woman_close.jpg',
      'Portraits',
      'In her element',
      2,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/portrait_man_hat.jpg',
      'Editorial',
      'The modern muse',
      3,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/portrait_man.jpg',
      'Editorial',
      'Between moments',
      4,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/couple_wedding.jpg',
      'Weddings',
      'A beginning',
      5,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/wedding_bouquet.jpg',
      'Weddings',
      'Details that matter',
      6,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/wedding_rings.jpg',
      'Weddings',
      'Forever, framed',
      7,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/hands_detail.jpg',
      'Details',
      'Made by hand',
      8,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/woman_landscape.jpg',
      'Places',
      'Where light falls',
      9,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/lake_boat.jpg',
      'Places',
      'Into the distance',
      10,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/sunset_lake.jpg',
      'Places',
      'Golden hour',
      11,
    ),
    _PortfolioPhoto(
      'assets/images/portfolio/architecture_door.jpg',
      'Details',
      'Lines & light',
      12,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _PortfolioIntro()),
          SliverToBoxAdapter(child: _CategoryBar()),
          const SliverToBoxAdapter(child: SizedBox(height: 50)),
          const SliverToBoxAdapter(child: _FeaturedPhoto()),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
          const SliverToBoxAdapter(
            child: _SectionLabel(
              number: '01',
              title: 'PORTRAITS',
              description: 'People, presence and the quiet moments between.',
            ),
          ),
          SliverToBoxAdapter(
            child: _PortraitGrid(photos: _photos.sublist(0, 4)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 130)),
          const SliverToBoxAdapter(
            child: _SectionLabel(
              number: '02',
              title: 'WEDDINGS',
              description:
                  'The emotion, details and atmosphere of a day remembered.',
            ),
          ),
          SliverToBoxAdapter(
            child: _WeddingGrid(photos: _photos.sublist(4, 7)),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 130)),
          const SliverToBoxAdapter(
            child: _SectionLabel(
              number: '03',
              title: 'PLACES & DETAILS',
              description:
                  'Light, texture and the stories hidden in ordinary places.',
            ),
          ),
          SliverToBoxAdapter(child: _PlacesGrid(photos: _photos.sublist(7))),
          const SliverToBoxAdapter(child: SizedBox(height: 150)),
          const SliverToBoxAdapter(child: _PortfolioClosing()),
        ],
      ),
    );
  }
}

class _PortfolioIntro extends StatelessWidget {
  const _PortfolioIntro();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 150, 24, 30),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 800;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PORTFOLIO',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2.5,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (desktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            'Stories in\nstillness.',
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 82,
                              height: .9,
                              color: AppColors.espresso,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 280,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              'A collection of photographs shaped by light, atmosphere and honest moments.',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                height: 1.8,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Stories in\nstillness.',
                          style: TextStyle(
                            fontFamily: 'CormorantGaramond',
                            fontSize: 64,
                            height: .92,
                            color: AppColors.espresso,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'A collection of photographs shaped by light, atmosphere and honest moments.',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 13,
                            height: 1.8,
                            color: AppColors.darkBrown,
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

class _CategoryBar extends StatelessWidget {
  const _CategoryBar();

  @override
  Widget build(BuildContext context) {
    const categories = ['ALL', 'PORTRAITS', 'EDITORIAL', 'WEDDINGS', 'PLACES'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < categories.length; i++) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: i == 0 ? AppColors.brown : Colors.transparent,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: i == 0 ? AppColors.brown : AppColors.border,
                      ),
                    ),
                    child: Text(
                      categories[i],
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color: i == 0 ? AppColors.cream : AppColors.darkBrown,
                      ),
                    ),
                  ),
                  if (i != categories.length - 1) const SizedBox(width: 8),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturedPhoto extends StatelessWidget {
  const _FeaturedPhoto();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final height = constraints.maxWidth >= 800 ? 650.0 : 480.0;

              return ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: SizedBox(
                  height: height,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.asset(
                        'assets/images/portfolio/portrait_woman.jpg',
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.espresso.withValues(alpha: .05),
                              AppColors.espresso.withValues(alpha: .7),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 30,
                        right: 30,
                        bottom: 30,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '01 / FEATURED',
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2,
                                      color: AppColors.cream,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Quiet confidence',
                                    style: TextStyle(
                                      fontFamily: 'CormorantGaramond',
                                      fontSize: 38,
                                      color: AppColors.ivory,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'PORTRAIT',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: AppColors.cream,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 800;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    number,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: AppColors.mocha,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: desktop
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontFamily: 'CormorantGaramond',
                                    fontSize: 52,
                                    height: .95,
                                    color: AppColors.espresso,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 250,
                                child: Text(
                                  description,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 12,
                                    height: 1.7,
                                    color: AppColors.muted,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontFamily: 'CormorantGaramond',
                                  fontSize: 48,
                                  height: .95,
                                  color: AppColors.espresso,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                description,
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 12,
                                  height: 1.7,
                                  color: AppColors.muted,
                                ),
                              ),
                            ],
                          ),
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

class _PortraitGrid extends StatelessWidget {
  const _PortraitGrid({required this.photos});

  final List<_PortfolioPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 45, 24, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 700) {
                return Column(
                  children: [
                    _PhotoCard(photo: photos[0], height: 430),
                    const SizedBox(height: 14),
                    _PhotoCard(photo: photos[1], height: 300),
                    const SizedBox(height: 14),
                    _PhotoCard(photo: photos[2], height: 420),
                    const SizedBox(height: 14),
                    _PhotoCard(photo: photos[3], height: 300),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _PhotoCard(photo: photos[0], height: 590),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        _PhotoCard(photo: photos[1], height: 340),
                        const SizedBox(height: 16),
                        _PhotoCard(photo: photos[2], height: 520),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 150),
                      child: _PhotoCard(photo: photos[3], height: 350),
                    ),
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

class _WeddingGrid extends StatelessWidget {
  const _WeddingGrid({required this.photos});

  final List<_PortfolioPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 45, 24, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 700;

              if (!desktop) {
                return Column(
                  children: [
                    _PhotoCard(photo: photos[0], height: 420),
                    const SizedBox(height: 14),
                    _PhotoCard(photo: photos[1], height: 300),
                    const SizedBox(height: 14),
                    _PhotoCard(photo: photos[2], height: 360),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _PhotoCard(photo: photos[0], height: 600),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _PhotoCard(photo: photos[1], height: 360),
                        const SizedBox(height: 16),
                        _PhotoCard(photo: photos[2], height: 430),
                      ],
                    ),
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

class _PlacesGrid extends StatelessWidget {
  const _PlacesGrid({required this.photos});

  final List<_PortfolioPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 45, 24, 0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 700;

              if (!desktop) {
                return Column(
                  children: [
                    for (final photo in photos) ...[
                      _PhotoCard(photo: photo, height: 340),
                      const SizedBox(height: 14),
                    ],
                  ],
                );
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: photos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: .78,
                ),
                itemBuilder: (context, index) {
                  return _PhotoCard(
                    photo: photos[index],
                    height: double.infinity,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.photo, required this.height});

  final _PortfolioPhoto photo;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(photo.path, fit: BoxFit.cover),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.espresso.withValues(alpha: 0),
                      AppColors.espresso.withValues(alpha: .75),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photo.category.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 8,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.8,
                              color: AppColors.cream,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            photo.title,
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 25,
                              color: AppColors.ivory,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      photo.number.toString().padLeft(2, '0'),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 9,
                        color: AppColors.sand,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PortfolioClosing extends StatelessWidget {
  const _PortfolioClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.brown,
      padding: const EdgeInsets.fromLTRB(24, 100, 24, 110),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KALLYGRAPHY',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  color: AppColors.sand,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Every photograph\nholds a feeling.',
                style: TextStyle(
                  fontFamily: 'CormorantGaramond',
                  fontSize: 64,
                  height: .95,
                  color: AppColors.ivory,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'PORTRAITS  ·  EDITORIAL  ·  WEDDINGS  ·  STORIES',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.7,
                  color: AppColors.beige,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PortfolioPhoto {
  const _PortfolioPhoto(this.path, this.category, this.title, this.number);

  final String path;
  final String category;
  final String title;
  final int number;
}
