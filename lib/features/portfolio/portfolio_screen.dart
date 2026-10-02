import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String selectedCategory = 'ALL';

  static const categories = [
    'ALL',
    'WEDDINGS',
    'INTRODUCTIONS',
    'BABY SHOWERS',
    'GRADUATIONS',
    'PHOTOSHOOTS',
    'MOMENTS',
  ];

  static const collections = <_Collection>[
    _Collection(
      category: 'WEDDINGS',
      eyebrow: '01 · WEDDINGS',
      title: 'The beginning\nof forever.',
      description: 'Emotion, atmosphere and all the little details that make a wedding day yours.',
      photos: [
        'Wedding.jpg',
        'Wedding2.jpg',
        'Wedding3.jpg',
        'Wedding4.jpg',
        'Wedding5.jpg',
        'Wedding6.jpg',
        'Wedding7.jpg',
      ],
    ),
    _Collection(
      category: 'INTRODUCTIONS',
      eyebrow: '02 · INTRODUCTIONS',
      title: 'A day worth\nremembering.',
      description: 'Tradition, family and the quiet moments that live between the celebration.',
      photos: [
        'Introduction.jpg',
        'Introduction2.jpg',
        'Introduction3.jpg',
        'Introduction4.jpg',
        'Introduction5.jpg',
        'Introduction6.jpg',
        'Introduction7.jpg',
        'Introduction8.jpg',
        'Introduction9.jpg',
        'Introduction10.jpg',
      ],
    ),
    _Collection(
      category: 'BABY SHOWERS',
      eyebrow: '03 · BABY SHOWERS',
      title: 'New beginnings.',
      description: 'Soft moments, anticipation and the people gathered around something beautiful.',
      photos: ['Baby shower.jpg'],
    ),
    _Collection(
      category: 'GRADUATIONS',
      eyebrow: '04 · GRADUATIONS',
      title: 'A moment\nof arrival.',
      description: 'The pride, the people and the celebration behind a milestone earned.',
      photos: ['graduation.jpg', 'graduation2.jpg', 'graduation3.jpg'],
    ),
    _Collection(
      category: 'PHOTOSHOOTS',
      eyebrow: '05 · PHOTOSHOOTS',
      title: 'In their\nelement.',
      description: 'Portraits and creative sessions shaped around personality, light and presence.',
      photos: [
        'photoshoot.jpg',
        'photoshoot3.jpg',
        'photoshoot4.jpg',
        'photoshoot5.jpg',
        'photoshoot6.jpg',
        'photoshoot7.jpg',
        'photoshoot8.jpg',
        'photoshoot9.jpg',
        'photoshoot10.jpg',
        'photoshoot11.jpg',
      ],
    ),
    _Collection(
      category: 'MOMENTS',
      eyebrow: '06 · MOMENTS',
      title: 'Life,\nas it felt.',
      description: 'Unscripted frames, atmosphere and the fleeting moments worth keeping.',
      photos: [
        'Moments.jpg',
        'Moments2.jpg',
        'Moments3.jpg',
        'Moments4.jpg',
        'Moments5.jpg',
        'Moment6.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleCollections = selectedCategory == 'ALL'
        ? collections
        : collections
              .where((collection) => collection.category == selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _PortfolioHero()),
          SliverToBoxAdapter(
            child: _CategoryNavigation(
              selected: selectedCategory,
              categories: categories,
              onSelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 72)),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final collection = visibleCollections[index];

              return _CollectionSection(
                collection: collection,
                number: selectedCategory == 'ALL'
                    ? index + 1
                    : collections.indexOf(collection) + 1,
              );
            }, childCount: visibleCollections.length),
          ),
          const SliverToBoxAdapter(child: _PortfolioFooter()),
        ],
      ),
    );
  }
}

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 150, 24, 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final desktop = constraints.maxWidth >= 850;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'THE WORK',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(height: 25),
                  if (desktop)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Expanded(
                          child: Text(
                            'Stories worth\nremembering.',
                            style: TextStyle(
                              fontFamily: 'CormorantGaramond',
                              fontSize: 82,
                              height: .88,
                              color: AppColors.espresso,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Text(
                              'A collection of celebrations, people and moments photographed by KALIISA RYAN.',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12.5,
                                height: 1.85,
                                color: AppColors.darkBrown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    const Text(
                      'Stories worth\nremembering.',
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: 61,
                        height: .9,
                        color: AppColors.espresso,
                      ),
                    ),
                  if (!desktop) ...[
                    const SizedBox(height: 25),
                    Text(
                      'A collection of celebrations, people and moments photographed by KALIISA RYAN.',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12.5,
                        height: 1.85,
                        color: AppColors.darkBrown,
                      ),
                    ),
                  ],
                  const SizedBox(height: 45),
                  Container(height: .7, color: AppColors.border),
                  const SizedBox(height: 15),
                  const Row(
                    children: [
                      Text(
                        'KALLYGRAPHY',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          color: AppColors.espresso,
                        ),
                      ),
                      Spacer(),
                      Text(
                        'KAMPALA · UGANDA',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                          color: AppColors.muted,
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

class _CategoryNavigation extends StatelessWidget {
  const _CategoryNavigation({
    required this.selected,
    required this.categories,
    required this.onSelected,
  });

  final String selected;
  final List<String> categories;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 27),
                    child: InkWell(
                      onTap: () => onSelected(category),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.6,
                            color: selected == category
                                ? AppColors.espresso
                                : AppColors.muted,
                            decoration: selected == category
                                ? TextDecoration.underline
                                : null,
                            decorationColor: AppColors.brown,
                            decorationThickness: 1,
                            decorationStyle: TextDecorationStyle.solid,
                          ),
                        ),
                      ),
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

class _CollectionSection extends StatelessWidget {
  const _CollectionSection({required this.collection, required this.number});

  final _Collection collection;
  final int number;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CollectionHeading(collection: collection, number: number),
              const SizedBox(height: 38),
              _EditorialGallery(photos: collection.photos),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollectionHeading extends StatelessWidget {
  const _CollectionHeading({required this.collection, required this.number});

  final _Collection collection;
  final int number;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 800;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    number.toString().padLeft(2, '0'),
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: AppColors.brown,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: Text(
                      collection.title,
                      style: TextStyle(
                        fontFamily: 'CormorantGaramond',
                        fontSize: desktop ? 55 : 43,
                        height: .9,
                        color: AppColors.espresso,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (desktop)
              SizedBox(
                width: 280,
                child: Text(
                  collection.description,
                  style: const TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 11.5,
                    height: 1.75,
                    color: AppColors.darkBrown,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _EditorialGallery extends StatelessWidget {
  const _EditorialGallery({required this.photos});

  final List<String> photos;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final desktop = constraints.maxWidth >= 850;

        if (!desktop) {
          return Column(
            children: [
              for (var i = 0; i < photos.length; i++) ...[
                _PhotoCard(filename: photos[i], index: i),
                if (i != photos.length - 1) const SizedBox(height: 14),
              ],
            ],
          );
        }

        final children = <Widget>[];

        for (var i = 0; i < photos.length; i += 3) {
          final remaining = photos.length - i;

          if (remaining >= 3) {
            children.add(
              SizedBox(
                height: 620,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 5,
                      child: _PhotoCard(filename: photos[i], index: i),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 3,
                      child: _PhotoCard(filename: photos[i + 1], index: i + 1),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 4,
                      child: _PhotoCard(filename: photos[i + 2], index: i + 2),
                    ),
                  ],
                ),
              ),
            );
          } else if (remaining == 2) {
            children.add(
              SizedBox(
                height: 520,
                child: Row(
                  children: [
                    Expanded(
                      child: _PhotoCard(filename: photos[i], index: i),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _PhotoCard(filename: photos[i + 1], index: i + 1),
                    ),
                  ],
                ),
              ),
            );
          } else {
            children.add(
              SizedBox(
                height: 620,
                width: constraints.maxWidth * .62,
                child: _PhotoCard(filename: photos[i], index: i),
              ),
            );
          }

          if (i + 3 < photos.length) {
            children.add(const SizedBox(height: 14));
          }
        }

        return Column(children: children);
      },
    );
  }
}

class _PhotoCard extends StatefulWidget {
  const _PhotoCard({required this.filename, required this.index});

  final String filename;
  final int index;

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final path = 'assets/images/ryan/${widget.filename}';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() => hovered = false),
      child: GestureDetector(
        onTap: () => _openImage(context, path),
        child: ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: hovered ? 1.018 : 1,
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOut,
                child: Image.asset(
                  path,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.sand,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.brown,
                      ),
                    );
                  },
                ),
              ),
              AnimatedOpacity(
                opacity: hovered ? 1 : 0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  color: AppColors.espresso.withValues(alpha: .28),
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    '${(widget.index + 1).toString().padLeft(2, '0')}  ·  KALLYGRAPHY',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.7,
                      color: Colors.white,
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

  void _openImage(BuildContext context, String path) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.espresso.withValues(alpha: .95),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  child: Image.asset(path, fit: BoxFit.contain),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PortfolioFooter extends StatelessWidget {
  const _PortfolioFooter();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 150),
      child: Center(
        child: Column(
          children: [
            Container(width: 70, height: .8, color: AppColors.border),
            const SizedBox(height: 35),
            const Text(
              'THE WAY IT FELT.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
                color: AppColors.brown,
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Photographs are\nmemories with a pulse.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'CormorantGaramond',
                fontSize: 52,
                height: .95,
                color: AppColors.espresso,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'KALLYGRAPHY · KALIISA RYAN · KAMPALA',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 8.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Collection {
  const _Collection({
    required this.category,
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.photos,
  });

  final String category;
  final String eyebrow;
  final String title;
  final String description;
  final List<String> photos;
}
