import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    final isHome = path == '/';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        fit: StackFit.expand,
        children: [
          child,

          // The header has an explicit height so the responsive
          // LayoutBuilder always receives finite constraints.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 104,
            child: _WebsiteHeader(isHome: isHome),
          ),
        ],
      ),
    );
  }
}

class _WebsiteHeader extends StatelessWidget {
  const _WebsiteHeader({required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 48,
              vertical: 20,
            ),
            child: isMobile
                ? _MobileHeader(isHome: isHome)
                : _DesktopHeader(isHome: isHome),
          ),
        );
      },
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _BrandMark(color: isHome ? AppColors.ivory : AppColors.espresso),
        const Spacer(),
        _NavLink(
          label: 'WORK',
          route: '/portfolio',
          active: GoRouterState.of(context).uri.path == '/portfolio',
          light: isHome,
        ),
        const SizedBox(width: 28),
        _NavLink(
          label: 'ABOUT',
          route: '/profile',
          active: GoRouterState.of(context).uri.path == '/profile',
          light: isHome,
        ),
        const SizedBox(width: 28),
        _NavLink(
          label: 'PACKAGES',
          route: '/packages',
          active: GoRouterState.of(context).uri.path == '/packages',
          light: isHome,
        ),
        const SizedBox(width: 28),
        _NavLink(
          label: 'GALLERIES',
          route: '/gallery',
          active: GoRouterState.of(context).uri.path == '/gallery',
          light: isHome,
        ),
        const SizedBox(width: 28),
        _NavLink(
          label: 'BOOK',
          route: '/booking',
          active: GoRouterState.of(context).uri.path == '/booking',
          light: isHome,
        ),
        const SizedBox(width: 32),
        _InquireButton(light: isHome),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.isHome});

  final bool isHome;

  @override
  Widget build(BuildContext context) {
    final color = isHome ? AppColors.ivory : AppColors.espresso;

    return Row(
      children: [
        _BrandMark(color: color),
        const Spacer(),
        IconButton(
          onPressed: () => _showMobileMenu(context),
          icon: Icon(Icons.menu_rounded, color: color, size: 28),
          tooltip: 'Open menu',
        ),
      ],
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.cream,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 12, 28, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MobileMenuItem(
                  label: 'WORK',
                  onTap: () => _go(context, '/portfolio'),
                ),
                _MobileMenuItem(
                  label: 'ABOUT',
                  onTap: () => _go(context, '/profile'),
                ),
                _MobileMenuItem(
                  label: 'PACKAGES',
                  onTap: () => _go(context, '/packages'),
                ),
                _MobileMenuItem(
                  label: 'GALLERIES',
                  onTap: () => _go(context, '/gallery'),
                ),
                _MobileMenuItem(
                  label: 'BOOK',
                  onTap: () => _go(context, '/booking'),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _go(context, '/booking'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.espresso,
                      foregroundColor: AppColors.ivory,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    child: const Text(
                      'INQUIRE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).pop();
    context.go(route);
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Text(
        'KALLYGRAPHY',
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 3.2,
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.route,
    required this.active,
    required this.light,
  });

  final String label;
  final String route;
  final bool active;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final color = light ? AppColors.ivory : AppColors.espresso;

    return InkWell(
      onTap: () => context.go(route),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.8,
            decoration: active ? TextDecoration.underline : null,
            decorationColor: color,
            decorationThickness: 1.2,
          ),
        ),
      ),
    );
  }
}

class _InquireButton extends StatelessWidget {
  const _InquireButton({required this.light});

  final bool light;

  @override
  Widget build(BuildContext context) {
    final foreground = light ? AppColors.espresso : AppColors.ivory;
    final background = light ? AppColors.ivory : AppColors.espresso;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: () => context.go('/booking'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
          child: Text(
            'INQUIRE',
            style: TextStyle(
              color: foreground,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  const _MobileMenuItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.espresso,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}
