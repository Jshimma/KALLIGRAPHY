import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/models/portfolio_category.dart';
import '../../shared/models/portfolio_photo.dart';
import '../../services/api/portfolio_api_service.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final PortfolioApiService _api = const PortfolioApiService();

  String _selectedCategory = 'all';
  List<PortfolioCategory> _categories = const [];
  List<PortfolioPhoto> _photos = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPortfolio();
  }

  Future<void> _loadPortfolio() async {
    try {
      final results = await Future.wait([
        _api.fetchCategories(),
        _api.fetchPhotos(),
      ]);

      if (!mounted) return;

      setState(() {
        _categories = results[0] as List<PortfolioCategory>;
        _photos = results[1] as List<PortfolioPhoto>;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _categories = const [];
        _photos = const [];
      });
    }
  }

  List<PortfolioPhoto> get _filteredPhotos {
    if (_selectedCategory == 'all') return _photos;

    return _photos
        .where((photo) => photo.categoryId == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final categories = <PortfolioCategory>[
      const PortfolioCategory(id: 'all', name: 'All', slug: 'all'),
      ..._categories,
    ];

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: _PortfolioIntro(
              loading: _loading,
              count: _filteredPhotos.length,
            ),
          ),
          SliverToBoxAdapter(
            child: _CategoryBar(
              categories: categories,
              selected: _selectedCategory,
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category.id;
                });
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 34, 20, 120),
            sliver: _PortfolioGrid(photos: _filteredPhotos),
          ),
        ],
      ),
    );
  }
}

class _PortfolioIntro extends StatelessWidget {
  final bool loading;
  final int count;

  const _PortfolioIntro({required this.loading, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 150, 24, 38),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 900;

          return wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Expanded(child: _IntroCopy()),
                    _WorkCount(loading: loading, count: count),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_IntroCopy()],
                );
        },
      ),
    );
  }
}

class _IntroCopy extends StatelessWidget {
  const _IntroCopy();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '02 / PORTFOLIO',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.mocha,
            letterSpacing: 2.2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Stories,\ncarefully seen.',
          style: theme.textTheme.displayLarge?.copyWith(
            color: AppColors.espresso,
            fontSize: 68,
            height: 0.9,
          ),
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            'A collection of portraits, celebrations and quiet moments '
            'photographed with warmth, intention and a sense of place.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.brown,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkCount extends StatelessWidget {
  final bool loading;
  final int count;

  const _WorkCount({required this.loading, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        loading ? '— WORKS' : '${count.toString().padLeft(2, '0')} WORKS',
        style: Theme.of(context).textTheme.labelLarge
            ?.copyWith(color: AppColors.mocha, letterSpacing: 1.8),
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final List<PortfolioCategory> categories;
  final String selected;
  final ValueChanged<PortfolioCategory> onSelected;

  const _CategoryBar({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 58,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final active = category.id == selected;

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 19),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active ? AppColors.espresso : AppColors.beige,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                category.name.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: active ? AppColors.cream : AppColors.brown,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PortfolioGrid extends StatelessWidget {
  final List<PortfolioPhoto> photos;

  const _PortfolioGrid({required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return const SliverToBoxAdapter(child: _EditorialPreview());
    }

    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final wide = MediaQuery.sizeOf(context).width >= 900;

        if (!wide) {
          return SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: _PhotoCard(photo: photos[index], large: index % 3 == 0),
              );
            }, childCount: photos.length),
          );
        }

        return SliverGrid(
          delegate: SliverChildBuilderDelegate((context, index) {
            return _PhotoCard(photo: photos[index], large: index % 5 == 0);
          }, childCount: photos.length),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 18,
            mainAxisSpacing: 18,
            childAspectRatio: 0.82,
          ),
        );
      },
    );
  }
}

class _PhotoCard extends StatefulWidget {
  final PortfolioPhoto photo;
  final bool large;

  const _PhotoCard({required this.photo, required this.large});

  @override
  State<_PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<_PhotoCard>
    with SingleTickerProviderStateMixin {
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

    _imageScale = Tween<double>(begin: 1.08, end: 1).animate(_entrance);

    Future.delayed(Duration(milliseconds: 90 + (widget.large ? 120 : 0)), () {
      if (mounted) _controller.forward();
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
              offset: Offset(0, 24 * (1 - _entrance.value)),
              child: child,
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hovered ? -8 : 0, 0),
          child: GestureDetector(
            onTap: () => _openPhoto(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Transform.scale(
                        scale: _imageScale.value * (_hovered ? 1.035 : 1),
                        child: Image.network(
                          widget.photo.previewUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Image.asset(
                            'assets/images/portfolio-hero.jpg',
                            fit: BoxFit.cover,
                          ),
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
                      opacity: _hovered ? 1 : 0.72,
                      duration: const Duration(milliseconds: 250),
                      child: Text(
                        '${widget.photo.id}'.padLeft(2, '0'),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppColors.cream,
                              letterSpacing: 1.4,
                            ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: AnimatedSlide(
                      offset: _hovered ? Offset.zero : const Offset(0, 0.35),
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOutCubic,
                      child: AnimatedOpacity(
                        opacity: _hovered ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                widget.photo.title.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelLarge
                                    ?.copyWith(
                                      color: AppColors.cream,
                                      letterSpacing: 1.2,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Container(
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
                          ],
                        ),
                      ),
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

  void _openPhoto(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.espresso.withValues(alpha: 0.94),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100, maxHeight: 800),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                widget.photo.previewUrl,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Image.asset(
                  'assets/images/portfolio-hero.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EditorialPreview extends StatelessWidget {
  const _EditorialPreview();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;

        final cards = [
          ('01', 'PORTRAITS', Alignment.center),
          ('02', 'EDITORIAL', Alignment.topCenter),
          ('03', 'CELEBRATIONS', Alignment.bottomCenter),
        ];

        return Wrap(
          spacing: 18,
          runSpacing: 18,
          children: cards.map((item) {
            return SizedBox(
              width: wide
                  ? (constraints.maxWidth - 36) / 3
                  : constraints.maxWidth,
              height: wide ? 520 : 430,
              child: _PreviewCard(
                number: item.$1,
                label: item.$2,
                alignment: item.$3,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _PreviewCard extends StatefulWidget {
  final String number;
  final String label;
  final Alignment alignment;

  const _PreviewCard({
    required this.number,
    required this.label,
    required this.alignment,
  });

  @override
  State<_PreviewCard> createState() => _PreviewCardState();
}

class _PreviewCardState extends State<_PreviewCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              scale: _hovered ? 1.035 : 1,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOutCubic,
              child: Image.asset(
                'assets/images/portfolio-hero.jpg',
                fit: BoxFit.cover,
                alignment: widget.alignment,
              ),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.espresso.withValues(alpha: 0.02),
                    AppColors.espresso.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Text(
                widget.number,
                style: Theme.of(context).textTheme.labelLarge
                    ?.copyWith(color: AppColors.cream.withValues(alpha: 0.72)),
              ),
            ),
            Positioned(
              left: 20,
              bottom: 22,
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: AppColors.cream, letterSpacing: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
