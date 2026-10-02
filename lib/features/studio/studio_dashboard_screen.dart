import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class StudioDashboardScreen extends StatelessWidget {
  const StudioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STUDIO OVERVIEW',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.brown,
              letterSpacing: 2.4,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Welcome back, Ryan.',
            style: Theme.of(context).textTheme.displaySmall
                ?.copyWith(color: AppColors.espresso),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Your private KALLYGRAPHY workspace.',
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: const [
              _StudioCard(
                label: 'INQUIRIES',
                title: 'Manage client inquiries',
                icon: Icons.inbox_outlined,
                route: '/studio/inquiries',
              ),
              _StudioCard(
                label: 'GALLERIES',
                title: 'Client galleries',
                icon: Icons.photo_library_outlined,
              ),
              _StudioCard(
                label: 'PORTFOLIO',
                title: 'Manage your work',
                icon: Icons.collections_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudioCard extends StatelessWidget {
  const _StudioCard({
    required this.label,
    required this.title,
    required this.icon,
    this.route,
  });

  final String label;
  final String title;
  final IconData icon;
  final String? route;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: InkWell(
        onTap: route == null ? null : () => context.go(route!),
        borderRadius: BorderRadius.circular(4),
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.cream,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.55)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.brown, size: 24),
              const SizedBox(height: AppSpacing.lg),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.brown,
                  letterSpacing: 1.8,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                    ?.copyWith(color: AppColors.espresso),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
