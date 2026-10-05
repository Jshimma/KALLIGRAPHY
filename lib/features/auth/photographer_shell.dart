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
    final selectedIndex = switch (location) {
      '/studio/inquiries' => 1,
      '/studio/galleries' => 2,
      _ => 0,
    };

    return Scaffold(
      backgroundColor: AppColors.ivory,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 850;

          if (isMobile) {
            return _MobileStudioLayout(
              session: session,
              selectedIndex: selectedIndex,
              onLogout: onLogout,
              child: child,
            );
          }

          return _DesktopStudioLayout(
            session: session,
            selectedIndex: selectedIndex,
            onLogout: onLogout,
            child: child,
          );
        },
      ),
    );
  }
}

class _DesktopStudioLayout extends StatelessWidget {
  const _DesktopStudioLayout({
    required this.session,
    required this.child,
    required this.selectedIndex,
    required this.onLogout,
  });

  final AuthSession session;
  final Widget child;
  final int selectedIndex;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 260,
          child: _StudioSidebar(
            selectedIndex: selectedIndex,
            onLogout: onLogout,
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _StudioTopbar(session: session, onLogout: onLogout),
              Expanded(child: child),
            ],
          ),
        ),
      ],
    );
  }
}

class _MobileStudioLayout extends StatelessWidget {
  const _MobileStudioLayout({
    required this.session,
    required this.child,
    required this.selectedIndex,
    required this.onLogout,
  });

  final AuthSession session;
  final Widget child;
  final int selectedIndex;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StudioMobileHeader(
          session: session,
          onLogout: onLogout,
          selectedIndex: selectedIndex,
        ),
        Expanded(child: child),
      ],
    );
  }
}

class _StudioSidebar extends StatelessWidget {
  const _StudioSidebar({required this.selectedIndex, required this.onLogout});

  final int selectedIndex;
  final VoidCallback onLogout;

  void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/studio');
      case 1:
        context.go('/studio/inquiries');
      case 2:
        context.go('/studio/galleries');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KALLYGRAPHY',
                    style: TextStyle(
                      color: AppColors.cream,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3.2,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'STUDIO',
                    style: TextStyle(
                      color: AppColors.mocha,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.darkBrown),
            const SizedBox(height: AppSpacing.lg),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'WORKSPACE',
                style: TextStyle(
                  color: AppColors.beige,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            _StudioNavItem(
              icon: Icons.grid_view_rounded,
              label: 'Overview',
              selected: selectedIndex == 0,
              onTap: () => _navigate(context, 0),
            ),
            _StudioNavItem(
              icon: Icons.mail_outline_rounded,
              label: 'Inquiries',
              selected: selectedIndex == 1,
              onTap: () => _navigate(context, 1),
            ),
            _StudioNavItem(
              icon: Icons.photo_library_outlined,
              label: 'Client galleries',
              selected: selectedIndex == 2,
              onTap: () => _navigate(context, 2),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => context.go('/'),
                      icon: const Icon(Icons.arrow_back_rounded, size: 17),
                      label: const Text('VIEW WEBSITE'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.cream,
                        side: const BorderSide(color: AppColors.brown),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      onPressed: onLogout,
                      icon: const Icon(Icons.logout_rounded, size: 17),
                      label: const Text('SIGN OUT'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.sand,
                        minimumSize: const Size.fromHeight(44),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.3,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StudioNavItem extends StatelessWidget {
  const _StudioNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected ? AppColors.mocha : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 19,
                  color: selected ? AppColors.cream : AppColors.sand,
                ),
                const SizedBox(width: 13),
                Text(
                  label,
                  style: TextStyle(
                    color: selected ? AppColors.cream : AppColors.sand,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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

class _StudioTopbar extends StatelessWidget {
  const _StudioTopbar({required this.session, required this.onLogout});

  final AuthSession session;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      decoration: const BoxDecoration(
        color: AppColors.ivory,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const Text(
            'PRIVATE WORKSPACE',
            style: TextStyle(
              color: AppColors.muted,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Text(
            session.fullName,
            style: const TextStyle(
              color: AppColors.espresso,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 14),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.sand,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_outline_rounded,
              color: AppColors.espresso,
              size: 19,
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            tooltip: 'Sign out',
            onPressed: onLogout,
            icon: const Icon(
              Icons.logout_rounded,
              color: AppColors.espresso,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudioMobileHeader extends StatelessWidget {
  const _StudioMobileHeader({
    required this.session,
    required this.onLogout,
    required this.selectedIndex,
  });

  final AuthSession session;
  final VoidCallback onLogout;
  final int selectedIndex;

  String get _sectionName {
    switch (selectedIndex) {
      case 1:
        return 'INQUIRIES';
      case 2:
        return 'CLIENT GALLERIES';
      default:
        return 'OVERVIEW';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.espresso,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KALLYGRAPHY',
                      style: TextStyle(
                        color: AppColors.cream,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'STUDIO',
                      style: TextStyle(
                        color: AppColors.mocha,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.2,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: onLogout,
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppColors.cream,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _MobileNavButton(
                  label: 'OVERVIEW',
                  selected: selectedIndex == 0,
                  onTap: () => context.go('/studio'),
                ),
                _MobileNavButton(
                  label: 'INQUIRIES',
                  selected: selectedIndex == 1,
                  onTap: () => context.go('/studio/inquiries'),
                ),
                _MobileNavButton(
                  label: 'GALLERIES',
                  selected: selectedIndex == 2,
                  onTap: () => context.go('/studio/galleries'),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _sectionName,
                style: const TextStyle(
                  color: AppColors.sand,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileNavButton extends StatelessWidget {
  const _MobileNavButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.mocha : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? AppColors.cream : AppColors.sand,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}
