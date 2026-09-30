import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../shared/models/portfolio_category.dart';
import '../../shared/models/portfolio_photo.dart';
import 'data/portfolio_data.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _selectedCategory = 'all';

  List<PortfolioPhoto> get _filteredPhotos {
    if (_selectedCategory == 'all') {
      return PortfolioData.photos;
    }

    return PortfolioData.photos
        .where((photo) => photo.categoryId == _selectedCategory)
        .toList();
  }

  void _selectCategory(PortfolioCategory category) {
    setState(() {
      _selectedCategory = category.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.lg,
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'THE COLLECTION',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: AppColors.mocha,
                        letterSpacing: 2.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Portfolio', style: theme.textTheme.displayMedium),
                    const SizedBox(height: 12),
                    Text(
                      'A selection of moments, people and stories '
                      'captured through the KALLIGRAPHY lens.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: _CategorySelector(
                categories: PortfolioData.categories,
                selectedCategory: _selectedCategory,
                onSelected: _selectCategory,
              ),
            ),

            if (_filteredPhotos.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyPortfolio(theme: theme),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                  AppSpacing.screenHorizontal,
                  AppSpacing.xxxl,
                ),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final photo = _filteredPhotos[index];

                    return _PortfolioTile(photo: photo, onTap: () {});
                  }, childCount: _filteredPhotos.length),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 320,
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 0.78,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelector extends StatelessWidget {
  final List<PortfolioCategory> categories;
  final String selectedCategory;
  final ValueChanged<PortfolioCategory> onSelected;

  const _CategorySelector({
    required this.categories,
    required this.selectedCategory,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedCategory;

          return GestureDetector(
            onTap: () => onSelected(category),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: selected ? AppColors.black : AppColors.ivory,
                border: Border.all(
                  color: selected ? AppColors.black : AppColors.border,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
              alignment: Alignment.center,
              child: Text(
                category.name.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? AppColors.cream : AppColors.brown,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PortfolioTile extends StatelessWidget {
  final PortfolioPhoto photo;
  final VoidCallback onTap;

  const _PortfolioTile({required this.photo, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'portfolio-${photo.id}',
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.espresso,
            borderRadius: BorderRadius.circular(2),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(photo.imageUrl, fit: BoxFit.cover),
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.black.withValues(alpha: 0.72),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Text(
                  photo.title,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(color: AppColors.cream),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyPortfolio extends StatelessWidget {
  final ThemeData theme;

  const _EmptyPortfolio({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenHorizontal),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_outlined,
              size: 44,
              color: AppColors.mocha,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Photography is coming.',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'The KALLIGRAPHY collection will appear here '
              'once the photographer adds the first work.',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
