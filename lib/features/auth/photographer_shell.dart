import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../services/auth/auth_session.dart';

class PhotographerShell extends StatelessWidget {
  const PhotographerShell({
    super.key,
    required this.session,
    required this.child,
    required this.onLogout,
  });

  final AuthSession session;
  final Widget child;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final selectedIndex = location == '/studio/inquiries' ? 1 : 0;

    return Scaffold(
      backgroundColor: AppColors.ivory,
      appBar: AppBar(
        title: const Text('KALLYGRAPHY STUDIO'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(
              children: [
                Text(
                  session.fullName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: AppSpacing.md),
                IconButton(
                  tooltip: 'Sign out',
                  onPressed: onLogout,
                  icon: const Icon(Icons.logout_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: selectedIndex,
            backgroundColor: AppColors.cream,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
              child: Icon(Icons.camera_alt_outlined, color: AppColors.brown),
            ),
            onDestinationSelected: (index) {
              if (index == 0) {
                context.go('/studio');
              } else if (index == 1) {
                context.go('/studio/inquiries');
              }
            },
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Overview'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inbox_outlined),
                selectedIcon: Icon(Icons.inbox),
                label: Text('Inquiries'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
