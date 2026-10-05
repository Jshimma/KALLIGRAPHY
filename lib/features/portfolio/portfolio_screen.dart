import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/brand_page_background.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  static const categories = [
    'ALL',
    'WEDDINGS',
    'INTRODUCTIONS',
    'BABY SHOWERS',
    'GRADUATIONS',
    'PHOTOSHOOTS',
    'MOMENTS',
  ];

  String selectedCategory = 'ALL';

  final collections = const [
    _Collection(
      category: 'WEDDINGS',
      title: 'The beginning of forever.',
      description: 'The people, movement and quiet in-between moments that make a wedding feel like yours.',
      images: [
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
      title: 'A day worth remembering.',
      description:
          'The first chapter deserves photographs that hold onto every detail.',
      images: [
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
      title: 'New beginnings.',
      description: 'Joy, anticipation and the people gathered around something beautiful.',
      images: ['Baby shower.jpg'],
    ),
    _Collection(
      category: 'GRADUATIONS',
      title: 'A moment of arrival.',
      description:
          'A milestone made tangible through portraits and celebration.',
      images: ['graduation.jpg', 'graduation2.jpg', 'graduation3.jpg'],
    ),
    _Collection(
      category: 'PHOTOSHOOTS',
      title: 'In their element.',
      description:
          'Portraits with room for personality, presence and movement.',
      images: [
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
      title: 'Life, as it felt.',
      description: 'The photographs between the photographs — spontaneous, honest and alive.',
      images: [
        'Moments.jpg',
        'Moments2.jpg',
        'Moments3.jpg',
        'Moments4.jpg',
        'Moments5.jpg',
        'Moments6.jpg',
        'Moment6.jpg',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleCollections = selectedCategory == 'ALL'
        ? collections
        : collections
              .where((item) => item.category == selectedCategory)
              .toList();

    return BrandPageBackground(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _WorkHero()),
          SliverPersistentHeader(
            pinned: true,
            delegate: _CategoryHeaderDelegate(
              categories: categories,
              selectedCategory: selectedCategory,
              onSelected: (category) {
                setState(() => selectedCategory = category);
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final collection = visibleCollections[index];

              return _CollectionSection(
                key: ValueKey(collection.category),
                collection: collection,
                index: index,
              );
            }, childCount: visibleCollections.length),
          ),
          const SliverToBoxAdapter(child: _WorkClosing()),
        ],
      ),
    );
  }
}

class _WorkHero extends StatelessWidget {
  const _WorkHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            wide ? 80 : 26,
            wide ? 105 : 70,
            wide ? 80 : 26,
            wide ? 95 : 70,
          ),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(flex: 64, child: _heroTitle(context)),
                    const SizedBox(width: 80),
                    const Expanded(flex: 36, child: _HeroStatement()),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _heroTitle(context),
                    const SizedBox(height: 36),
                    const _HeroStatement(),
                  ],
                ),
        );
      },
    );
  }

  Widget _heroTitle(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Eyebrow('01 · THE PORTFOLIO'),
        const SizedBox(height: 25),
        Text(
          'THE WORK\nSPEAKS\nFOR ITSELF.',
          style: Theme.of(context).textTheme.displayLarge
              ?.copyWith(fontSize: 76, height: .88, letterSpacing: -2.5),
        ),
      ],
    );
  }
}

class _HeroStatement extends StatelessWidget {
  const _HeroStatement();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 42, height: 1, color: AppColors.mocha),
        const SizedBox(height: 24),
        Text(
          'A collection of stories, celebrations and people photographed as they truly felt.',
          style: Theme.of(context).textTheme.bodyLarge
              ?.copyWith(height: 1.8, color: AppColors.brown),
        ),
      ],
    );
  }
}

class _CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CategoryHeaderDelegate({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onSelected;

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Material(
      color: AppColors.cream.withValues(alpha: .97),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.border),
            bottom: BorderSide(color: AppColors.border),
          ),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Row(
            children: categories.map((category) {
              final active = category == selectedCategory;

              return Padding(
                padding: const EdgeInsets.only(right: 30),
                child: InkWell(
                  onTap: () => onSelected(category),
                  child: SizedBox(
                    height: 72,
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 180),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 10,
                          fontWeight: active
                              ? FontWeight.w700
                              : FontWeight.w500,
                          letterSpacing: 1.5,
                          color: active ? AppColors.mocha : AppColors.muted,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(category),
                            const SizedBox(height: 7),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: active ? 24 : 0,
                              height: 2,
                              color: AppColors.mocha,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _CategoryHeaderDelegate oldDelegate) {
    return oldDelegate.selectedCategory != selectedCategory;
  }
}

class _CollectionSection extends StatelessWidget {
  const _CollectionSection({
    super.key,
    required this.collection,
    required this.index,
  });

  final _Collection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            wide ? 70 : 22,
            wide ? 115 : 80,
            wide ? 70 : 22,
            wide ? 135 : 90,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CollectionHeading(collection: collection, index: index),
              const SizedBox(height: 55),
              _EditorialGallery(
                images: collection.images,
                wide: wide,
                collectionIndex: index,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollectionHeading extends StatelessWidget {
  const _CollectionHeading({required this.collection, required this.index});

  final _Collection collection;
  final int index;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1050),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 800;

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Eyebrow(
                            '${(index + 2).toString().padLeft(2, '0')} · ${collection.category}',
                          ),
                          const SizedBox(height: 20),
                          Text(
                            collection.title,
                            style: Theme.of(context).textTheme.displayMedium
                                ?.copyWith(
                                  fontSize: 56,
                                  height: .94,
                                  letterSpacing: -1.2,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 60),
                    SizedBox(
                      width: 310,
                      child: Text(
                        collection.description,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(height: 1.75, color: AppColors.brown),
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Eyebrow(
                      '${(index + 2).toString().padLeft(2, '0')} · ${collection.category}',
                    ),
                    const SizedBox(height: 18),
                    Text(
                      collection.title,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontSize: 47,
                            height: .94,
                            letterSpacing: -1,
                          ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      collection.description,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.75, color: AppColors.brown),
                    ),
                  ],
                );
        },
      ),
    );
  }
}

class _EditorialGallery extends StatelessWidget {
  const _EditorialGallery({
    required this.images,
    required this.wide,
    required this.collectionIndex,
  });

  final List<String> images;
  final bool wide;
  final int collectionIndex;

  @override
  Widget build(BuildContext context) {
    if (!wide) {
      return Column(
        children: [
          for (var i = 0; i < images.length; i++) ...[
            _PhotoCard(
              image: images[i],
              images: images,
              imageIndex: i,
              height: i.isEven ? 460 : 360,
              alignment: Alignment.center,
            ),
            if (i != images.length - 1) const SizedBox(height: 18),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    var imageIndex = 0;

    while (imageIndex < images.length) {
      final pattern = imageIndex % 3;

      if (pattern == 0 && imageIndex + 1 < images.length) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 58,
                child: _PhotoCard(
                  image: images[imageIndex],
                  images: images,
                  imageIndex: imageIndex,
                  height: 620,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 42,
                child: Padding(
                  padding: const EdgeInsets.only(top: 110),
                  child: _PhotoCard(
                    image: images[imageIndex + 1],
                    images: images,
                    imageIndex: imageIndex + 1,
                    height: 450,
                  ),
                ),
              ),
            ],
          ),
        );
        imageIndex += 2;
      } else if (imageIndex + 2 < images.length) {
        rows.add(
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PhotoCard(
                  image: images[imageIndex],
                  images: images,
                  imageIndex: imageIndex,
                  height: 430,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 90),
                  child: _PhotoCard(
                    image: images[imageIndex + 1],
                    images: images,
                    imageIndex: imageIndex + 1,
                    height: 510,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _PhotoCard(
                  image: images[imageIndex + 2],
                  images: images,
                  imageIndex: imageIndex + 2,
                  height: 390,
                ),
              ),
            ],
          ),
        );
        imageIndex += 3;
      } else {
        rows.add(
          SizedBox(
            width: 520,
            child: _PhotoCard(
              image: images[imageIndex],
              images: images,
              imageIndex: imageIndex,
              height: 500,
            ),
          ),
        );
        imageIndex++;
      }

      if (imageIndex < images.length) {
        rows.add(const SizedBox(height: 28));
      }
    }

    return Column(children: rows);
  }
}

class _PhotoCard extends StatefulWidget {
  const _PhotoCard({
    required this.image,
    required this.images,
    required this.imageIndex,
    required this.height,
    this.alignment = Alignment.center,
  });

  final String image;
  final List<String> images;
  final int imageIndex;
  final double height;
  final Alignment alignment;

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovering = true),
      onExit: (_) => setState(() => hovering = false),
      child: GestureDetector(
        onTap: () => _openImage(context),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: widget.height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Keep the complete photograph visible.
                // No scale transform is applied, so faces and heads
                // cannot be pushed outside the card bounds.
                Image.asset(
                  'assets/images/ryan/${widget.image}',
                  fit: BoxFit.contain,
                  alignment: widget.alignment,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: AppColors.sand,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.brown,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 220),
                  opacity: hovering ? 1 : 0,
                  child: Container(
                    color: AppColors.darkBrown.withValues(alpha: .25),
                    alignment: Alignment.center,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.cream,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Icon(
                          Icons.open_in_full,
                          color: AppColors.darkBrown,
                          size: 20,
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

  void _openImage(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.espresso.withValues(alpha: .97),
      builder: (_) => _FullscreenGallery(
        images: widget.images,
        initialIndex: widget.imageIndex,
      ),
    );
  }
}

class _FullscreenGallery extends StatefulWidget {
  const _FullscreenGallery({required this.images, required this.initialIndex});

  final List<String> images;
  final int initialIndex;

  @override
  State<_FullscreenGallery> createState() => _FullscreenGalleryState();
}

class _FullscreenGalleryState extends State<_FullscreenGallery> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _previous() {
    if (currentIndex == 0) return;
    setState(() => currentIndex--);
  }

  void _next() {
    if (currentIndex >= widget.images.length - 1) return;
    setState(() => currentIndex++);
  }

  @override
  Widget build(BuildContext context) {
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == widget.images.length - 1;
    final image = widget.images[currentIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12),
      child: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            minScale: .8,
            maxScale: 4,
            child: Image.asset(
              'assets/images/ryan/$image',
              fit: BoxFit.contain,
            ),
          ),

          // Previous
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: isFirst ? null : _previous,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.cream.withValues(alpha: .94),
                  foregroundColor: AppColors.darkBrown,
                  disabledBackgroundColor: AppColors.cream.withValues(
                    alpha: .20,
                  ),
                  disabledForegroundColor: AppColors.cream.withValues(
                    alpha: .30,
                  ),
                  minimumSize: const Size(52, 52),
                ),
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
              ),
            ),
          ),

          // Next
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                onPressed: isLast ? null : _next,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.cream.withValues(alpha: .94),
                  foregroundColor: AppColors.darkBrown,
                  disabledBackgroundColor: AppColors.cream.withValues(
                    alpha: .20,
                  ),
                  disabledForegroundColor: AppColors.cream.withValues(
                    alpha: .30,
                  ),
                  minimumSize: const Size(52, 52),
                ),
                icon: const Icon(Icons.arrow_forward_ios_rounded),
              ),
            ),
          ),

          // Close
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.cream,
                foregroundColor: AppColors.darkBrown,
                minimumSize: const Size(48, 48),
              ),
              icon: const Icon(Icons.close),
            ),
          ),

          // Position indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.espresso.withValues(alpha: .82),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.sand.withValues(alpha: .45),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${widget.images.length}',
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: AppColors.cream,
                    ),
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

class _WorkClosing extends StatelessWidget {
  const _WorkClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 120),
      child: Column(
        children: [
          const _Eyebrow('08 · YOUR STORY IS NEXT', color: AppColors.sand),
          const SizedBox(height: 25),
          Text(
            'THE NEXT FRAME\nCOULD BE YOURS.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium
                ?.copyWith(color: AppColors.cream, fontSize: 62, height: .92),
          ),
          const SizedBox(height: 28),
          const SizedBox(
            width: 560,
            child: Text(
              'Every celebration has a rhythm. Every person has a story. '
              'Let’s make photographs that keep yours alive.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                height: 1.8,
                color: AppColors.sand,
              ),
            ),
          ),
          const SizedBox(height: 34),
          FilledButton(
            onPressed: () {
              // Navigation is intentionally handled by the surrounding
              // website shell when this section is reached.
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.mocha,
              foregroundColor: AppColors.cream,
            ),
            child: const Text('MAKE AN INQUIRY'),
          ),
        ],
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
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
        color: color,
      ),
    );
  }
}

class _Collection {
  const _Collection({
    required this.category,
    required this.title,
    required this.description,
    required this.images,
  });

  final String category;
  final String title;
  final String description;
  final List<String> images;
}
