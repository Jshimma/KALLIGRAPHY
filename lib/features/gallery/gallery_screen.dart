import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  static const _categories = [
    'ALL',
    'WEDDINGS',
    'INTRODUCTIONS',
    'BABY SHOWERS',
    'GRADUATIONS',
    'PHOTOSHOOTS',
    'MOMENTS',
  ];

  static const _photos = [
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding2.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding3.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding4.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding5.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding6.jpg'),
    _GalleryPhoto('WEDDINGS', 'assets/images/ryan/Wedding7.jpg'),

    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction2.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction3.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction4.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction5.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction6.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction7.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction8.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction9.jpg'),
    _GalleryPhoto('INTRODUCTIONS', 'assets/images/ryan/Introduction10.jpg'),

    _GalleryPhoto('BABY SHOWERS', 'assets/images/ryan/Baby shower.jpg'),

    _GalleryPhoto('GRADUATIONS', 'assets/images/ryan/graduation.jpg'),
    _GalleryPhoto('GRADUATIONS', 'assets/images/ryan/graduation2.jpg'),
    _GalleryPhoto('GRADUATIONS', 'assets/images/ryan/graduation3.jpg'),

    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot3.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot4.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot5.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot6.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot7.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot8.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot9.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot10.jpg'),
    _GalleryPhoto('PHOTOSHOOTS', 'assets/images/ryan/photoshoot11.jpg'),

    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments.jpg'),
    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments2.jpg'),
    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments3.jpg'),
    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments4.jpg'),
    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments5.jpg'),
    _GalleryPhoto('MOMENTS', 'assets/images/ryan/Moments6.jpg'),
  ];

  String _selectedCategory = 'ALL';

  List<_GalleryPhoto> get _filteredPhotos {
    if (_selectedCategory == 'ALL') {
      return _photos;
    }

    return _photos
        .where((photo) => photo.category == _selectedCategory)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _GalleryIntro(
              selectedCategory: _selectedCategory,
              categories: _categories,
              onCategoryChanged: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 100),
            sliver: SliverLayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.crossAxisExtent;

                if (width >= 1050) {
                  return _DesktopGallery(photos: _filteredPhotos);
                }

                if (width >= 650) {
                  return _TabletGallery(photos: _filteredPhotos);
                }

                return _MobileGallery(photos: _filteredPhotos);
              },
            ),
          ),
          const SliverToBoxAdapter(child: _GalleryClosing()),
        ],
      ),
    );
  }
}

class _GalleryPhoto {
  const _GalleryPhoto(this.category, this.asset);

  final String category;
  final String asset;
}

class _GalleryIntro extends StatelessWidget {
  const _GalleryIntro({
    required this.selectedCategory,
    required this.categories,
    required this.onCategoryChanged,
  });

  final String selectedCategory;
  final List<String> categories;
  final ValueChanged<String> onCategoryChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.cream,
      padding: const EdgeInsets.fromLTRB(24, 105, 24, 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'THE GALLERIES',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.muted,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'A collection of moments.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: AppColors.espresso,
                fontSize: 62,
                height: .95,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Text(
                'Weddings, celebrations, portraits and everything in between — photographed by Kaliisa Ryan.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted, height: 1.7),
              ),
            ),
          ),
          const SizedBox(height: 52),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(right: 28),
                    child: GestureDetector(
                      onTap: () => onCategoryChanged(category),
                      child: _CategoryLabel(
                        category: category,
                        active: selectedCategory == category,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryLabel extends StatelessWidget {
  const _CategoryLabel({required this.category, required this.active});

  final String category;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: active ? AppColors.espresso : Colors.transparent,
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        category,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: active ? AppColors.espresso : AppColors.muted,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _DesktopGallery extends StatelessWidget {
  const _DesktopGallery({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final gap = 8.0;
          final largeWidth = (width - gap) * .58;
          final smallWidth = (width - gap) * .42;

          return Column(
            children: [
              for (var start = 0; start < photos.length; start += 3)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SizedBox(
                    height: start % 2 == 0 ? 520 : 430,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (start < photos.length)
                          SizedBox(
                            width: start % 2 == 0 ? largeWidth : smallWidth,
                            child: _GalleryTile(
                              photo: photos[start],
                              featured: true,
                              index: start,
                            ),
                          ),
                        if (start + 1 < photos.length) SizedBox(width: gap),
                        if (start + 1 < photos.length)
                          Expanded(
                            child: _GalleryTile(
                              photo: photos[start + 1],
                              featured: false,
                              index: start + 1,
                            ),
                          ),
                        if (start + 2 < photos.length) SizedBox(width: gap),
                        if (start + 2 < photos.length)
                          SizedBox(
                            width: start % 2 == 0 ? smallWidth : largeWidth,
                            child: _GalleryTile(
                              photo: photos[start + 2],
                              featured: true,
                              index: start + 2,
                            ),
                          ),
                      ],
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

class _TabletGallery extends StatelessWidget {
  const _TabletGallery({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.zero,
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate((context, index) {
          return _GalleryTile(
            photo: photos[index],
            featured: index % 6 == 0,
            index: index,
          );
        }, childCount: photos.length),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: .78,
        ),
      ),
    );
  }
}

class _MobileGallery extends StatelessWidget {
  const _MobileGallery({required this.photos});

  final List<_GalleryPhoto> photos;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate((context, index) {
        return _GalleryTile(
          photo: photos[index],
          featured: index % 5 == 0,
          index: index,
        );
      }, childCount: photos.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: .78,
      ),
    );
  }
}

class _GalleryTile extends StatefulWidget {
  const _GalleryTile({
    required this.photo,
    required this.featured,
    required this.index,
  });

  final _GalleryPhoto photo;
  final bool featured;
  final int index;

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _openViewer(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              widget.photo.asset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.sand,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.espresso,
                  ),
                );
              },
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _hovered ? 1 : 0,
              child: Container(
                color: AppColors.espresso.withValues(alpha: .32),
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(18),
                child: Text(
                  widget.photo.category,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.ivory,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openViewer(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierColor: AppColors.espresso.withValues(alpha: .96),
      builder: (_) => _GalleryViewer(
        photos: _GalleryScreenState._photos,
        initialIndex: _GalleryScreenState._photos.indexOf(widget.photo),
      ),
    );
  }
}

class _GalleryViewer extends StatefulWidget {
  const _GalleryViewer({required this.photos, required this.initialIndex});

  final List<_GalleryPhoto> photos;
  final int initialIndex;

  @override
  State<_GalleryViewer> createState() => _GalleryViewerState();
}

class _GalleryViewerState extends State<_GalleryViewer> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    final photo = widget.photos[_index];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(18),
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              minScale: .8,
              maxScale: 4,
              child: Image.asset(photo.asset, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close, color: AppColors.ivory),
            ),
          ),
          Positioned(
            left: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ViewerButton(
                icon: Icons.arrow_back_ios_new,
                onPressed: _index == 0 ? null : () => setState(() => _index--),
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 0,
            bottom: 0,
            child: Center(
              child: _ViewerButton(
                icon: Icons.arrow_forward_ios,
                onPressed: _index == widget.photos.length - 1
                    ? null
                    : () => setState(() => _index++),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: 18,
            child: Text(
              '${photo.category}  /  ${_index + 1} OF ${widget.photos.length}',
              style: Theme.of(context).textTheme.labelSmall
                  ?.copyWith(color: AppColors.ivory, letterSpacing: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewerButton extends StatelessWidget {
  const _ViewerButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: AppColors.ivory, size: 22),
    );
  }
}

class _GalleryClosing extends StatelessWidget {
  const _GalleryClosing();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.darkBrown,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 110),
      child: Center(
        child: Column(
          children: [
            Text(
              'KEEP LOOKING.',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.sand,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Every frame tells\nsomething different.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium
                  ?.copyWith(color: AppColors.ivory, fontSize: 54, height: .95),
            ),
          ],
        ),
      ),
    );
  }
}
