import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';

class MainShell extends StatelessWidget {
  const MainShell({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Stack(
        fit: StackFit.expand,
        children: [
          child,

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _WebsiteHeader(path: path),
          ),
        ],
      ),
    );
  }
}

class _WebsiteHeader extends StatelessWidget {
  const _WebsiteHeader({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;

        return SafeArea(
          bottom: false,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cream.withValues(alpha: 0.96),
              border: const Border(
                bottom: BorderSide(color: AppColors.border, width: 0.7),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 22 : 48,
              vertical: isMobile ? 17 : 19,
            ),
            child: isMobile
                ? _MobileHeader(path: path)
                : _DesktopHeader(path: path),
          ),
        );
      },
    );
  }
}

class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(),
        const Spacer(),

        _NavLink(
          label: 'GALLERY',
          route: '/portfolio',
          active: path == '/portfolio',
        ),
        const SizedBox(width: 28),

        _NavLink(label: 'ABOUT', route: '/profile', active: path == '/profile'),
        const SizedBox(width: 28),

        _NavLink(
          label: 'PACKAGES',
          route: '/packages',
          active: path == '/packages',
        ),
        const SizedBox(width: 28),

        _NavLink(label: 'BOOK', route: '/booking', active: path == '/booking'),
        const SizedBox(width: 34),

        _InquireLink(),
      ],
    );
  }
}

class _MobileHeader extends StatelessWidget {
  const _MobileHeader({required this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _BrandMark(),
        const Spacer(),
        IconButton(
          onPressed: () => _showMobileMenu(context),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: const Icon(
            Icons.menu_rounded,
            color: AppColors.espresso,
            size: 27,
          ),
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
            padding: const EdgeInsets.fromLTRB(28, 10, 28, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MobileMenuItem(label: 'GALLERY', route: '/portfolio'),
                _MobileMenuItem(label: 'ABOUT', route: '/profile'),
                _MobileMenuItem(label: 'PACKAGES', route: '/packages'),

                _MobileMenuItem(label: 'BOOK', route: '/booking'),
                const SizedBox(height: 12),
                _MobileMenuItem(
                  label: 'INQUIRE →',
                  route: '/booking',
                  accent: true,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: const Text(
        'KALLYGRAPHY',
        style: TextStyle(
          color: AppColors.espresso,
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
  });

  final String label;
  final String route;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go(route),
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.mocha : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          border: active
              ? null
              : Border.all(color: AppColors.border, width: .8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? AppColors.ivory : AppColors.espresso,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class _InquireLink extends StatelessWidget {
  const _InquireLink();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/booking'),
      borderRadius: BorderRadius.circular(999),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.mocha,
          borderRadius: BorderRadius.circular(999),
        ),
        child: const Text(
          'INQUIRE →',
          style: TextStyle(
            color: AppColors.ivory,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
      ),
    );
  }
}

class _MobileMenuItem extends StatelessWidget {
  const _MobileMenuItem({
    required this.label,
    required this.route,
    this.accent = false,
  });

  final String label;
  final String route;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop();
          context.go(route);
        },
        borderRadius: BorderRadius.circular(999),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          decoration: BoxDecoration(
            color: accent ? AppColors.mocha : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            border: accent
                ? null
                : Border.all(color: AppColors.border, width: .8),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: accent ? AppColors.ivory : AppColors.espresso,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}
