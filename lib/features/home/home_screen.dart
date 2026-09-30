import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.lg,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'KALLIGRAPHY',
                      style: theme.textTheme.titleMedium?.copyWith(
                        letterSpacing: 3,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.menu),
                      color: AppColors.black,
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              sliver: SliverToBoxAdapter(child: _HeroSection(theme: theme)),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.xxxl,
                AppSpacing.screenHorizontal,
                AppSpacing.xxl,
              ),
              sliver: SliverToBoxAdapter(
                child: _IntroductionSection(theme: theme),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.screenHorizontal,
              ),
              sliver: SliverToBoxAdapter(
                child: _SectionHeader(
                  title: 'Selected Work',
                  action: 'View All',
                  onPressed: () {},
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(child: _PortfolioPreview()),
            ),

            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                0,
                AppSpacing.screenHorizontal,
                AppSpacing.xxxl,
              ),
              sliver: SliverToBoxAdapter(
                child: _BookingCallToAction(theme: theme),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final ThemeData theme;

  const _HeroSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 520,
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [AppColors.espresso, AppColors.black],
                ),
              ),
            ),
          ),

          Positioned(
            top: 32,
            left: 28,
            child: Text(
              'EST. 2026',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.beige,
                letterSpacing: 2.5,
              ),
            ),
          ),

          Positioned(
            left: 28,
            right: 28,
            bottom: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stories',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.cream,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Captured.',
                  style: theme.textTheme.displayMedium?.copyWith(
                    color: AppColors.cream,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  'Photography created with intention, '
                  'emotion and timeless character.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.beige,
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: 170,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.cream,
                      side: const BorderSide(color: AppColors.beige),
                    ),
                    child: const Text('VIEW PORTFOLIO'),
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

class _IntroductionSection extends StatelessWidget {
  final ThemeData theme;

  const _IntroductionSection({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THE ART OF',
          style: theme.textTheme.labelLarge?.copyWith(color: AppColors.mocha),
        ),
        const SizedBox(height: 10),
        Text(
          'Photography',
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'KALLIGRAPHY is a photography experience built around '
          'authentic moments, thoughtful composition and images '
          'that remain meaningful long after they are captured.',
          style: theme.textTheme.bodyLarge,
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onPressed;

  const _SectionHeader({
    required this.title,
    required this.action,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: theme.textTheme.headlineMedium),
        TextButton(
          onPressed: onPressed,
          child: Text(
            action,
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brown),
          ),
        ),
      ],
    );
  }
}

class _PortfolioPreview extends StatelessWidget {
  const _PortfolioPreview();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PortfolioPlaceholder(height: 360, label: 'PORTRAITS'),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _PortfolioPlaceholder(height: 240, label: 'WEDDINGS'),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _PortfolioPlaceholder(height: 240, label: 'EDITORIAL'),
            ),
          ],
        ),
      ],
    );
  }
}

class _PortfolioPlaceholder extends StatelessWidget {
  final double height;
  final String label;

  const _PortfolioPlaceholder({required this.height, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.espresso,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.darkBrown, AppColors.black],
                ),
              ),
            ),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            child: Text(
              label,
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.cream,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookingCallToAction extends StatelessWidget {
  final ThemeData theme;

  const _BookingCallToAction({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.beige,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LET’S CREATE',
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.brown),
          ),
          const SizedBox(height: 10),
          Text('Your next story.', style: theme.textTheme.headlineLarge),
          const SizedBox(height: 14),
          Text(
            'From intimate portraits to unforgettable celebrations, '
            'let’s create something worth remembering.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton(onPressed: () {}, child: const Text('BOOK A SESSION')),
        ],
      ),
    );
  }
}
