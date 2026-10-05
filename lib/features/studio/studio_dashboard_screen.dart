import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

class StudioDashboardScreen extends StatelessWidget {
  const StudioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        return SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? AppSpacing.md : AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _WelcomeSection(isMobile: isMobile),
              const SizedBox(height: AppSpacing.xl),
              const _StatsRow(),
              const SizedBox(height: AppSpacing.xl),
              _SectionHeading(
                eyebrow: 'QUICK ACCESS',
                title: 'Your studio, at a glance.',
                isMobile: isMobile,
              ),
              const SizedBox(height: AppSpacing.md),
              _QuickActions(isMobile: isMobile),
              const SizedBox(height: AppSpacing.xl),
              _ActivitySection(isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xl),
      decoration: const BoxDecoration(color: AppColors.cream),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _welcomeEyebrow(),
                const SizedBox(height: AppSpacing.sm),
                _welcomeTitle(),
                const SizedBox(height: AppSpacing.md),
                _welcomeDescription(),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _welcomeEyebrow(),
                      const SizedBox(height: AppSpacing.sm),
                      _welcomeTitle(),
                      const SizedBox(height: AppSpacing.md),
                      _welcomeDescription(),
                    ],
                  ),
                ),
                const Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.mocha,
                  size: 52,
                ),
              ],
            ),
    );
  }

  Widget _welcomeEyebrow() {
    return const Text(
      'KALLYGRAPHY STUDIO / OVERVIEW',
      style: TextStyle(
        color: AppColors.brown,
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.2,
      ),
    );
  }

  Widget _welcomeTitle() {
    return Text(
      'Welcome back, Ryan.',
      style: TextStyle(
        color: AppColors.espresso,
        fontSize: isMobile ? 34 : 46,
        height: .98,
        fontWeight: FontWeight.w400,
        letterSpacing: -1,
      ),
    );
  }

  Widget _welcomeDescription() {
    return const Text(
      'Everything you need to manage your photography business, '
      'client relationships and private galleries.',
      style: TextStyle(color: AppColors.muted, fontSize: 14, height: 1.7),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 700;

        final cards = const [
          _StatCard(
            number: '—',
            label: 'NEW INQUIRIES',
            icon: Icons.mail_outline_rounded,
          ),
          _StatCard(
            number: '2',
            label: 'CLIENT GALLERIES',
            icon: Icons.photo_library_outlined,
          ),
          _StatCard(
            number: '1',
            label: 'PUBLISHED',
            icon: Icons.check_circle_outline_rounded,
          ),
          _StatCard(
            number: '—',
            label: 'UPCOMING',
            icon: Icons.calendar_today_outlined,
          ),
        ];

        if (isMobile) {
          return Column(
            children: [
              for (final card in cards) ...[
                card,
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          );
        }

        return Row(
          children: [
            for (var i = 0; i < cards.length; i++) ...[
              Expanded(child: cards[i]),
              if (i != cards.length - 1) const SizedBox(width: AppSpacing.sm),
            ],
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.number,
    required this.label,
    required this.icon,
  });

  final String number;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.ivory,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.mocha, size: 22),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                number,
                style: const TextStyle(
                  color: AppColors.espresso,
                  fontSize: 27,
                  height: 1,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.isMobile,
  });

  final String eyebrow;
  final String title;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: AppColors.brown,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            color: AppColors.espresso,
            fontSize: isMobile ? 26 : 32,
            fontWeight: FontWeight.w400,
            letterSpacing: -.5,
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final actions = [
      _ActionData(
        number: '01',
        title: 'VIEW INQUIRIES',
        description: 'Review messages and booking requests.',
        icon: Icons.mail_outline_rounded,
        route: '/studio/inquiries',
      ),
      _ActionData(
        number: '02',
        title: 'CLIENT GALLERIES',
        description: 'Manage private galleries and photographs.',
        icon: Icons.photo_library_outlined,
        route: '/studio/galleries',
      ),
      _ActionData(
        number: '03',
        title: 'VIEW WEBSITE',
        description: 'See the public KALLYGRAPHY experience.',
        icon: Icons.open_in_new_rounded,
        route: '/',
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (final action in actions) ...[
            _ActionCard(data: action),
            const SizedBox(height: AppSpacing.sm),
          ],
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          Expanded(child: _ActionCard(data: actions[i])),
          if (i != actions.length - 1) const SizedBox(width: AppSpacing.sm),
        ],
      ],
    );
  }
}

class _ActionData {
  const _ActionData({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
  });

  final String number;
  final String title;
  final String description;
  final IconData icon;
  final String route;
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({required this.data});

  final _ActionData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cream,
      child: InkWell(
        onTap: () => context.go(data.route),
        child: Container(
          constraints: const BoxConstraints(minHeight: 190),
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    data.number,
                    style: const TextStyle(
                      color: AppColors.mocha,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Spacer(),
                  Icon(data.icon, color: AppColors.brown, size: 22),
                ],
              ),
              const Spacer(),
              Text(
                data.title,
                style: const TextStyle(
                  color: AppColors.espresso,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data.description,
                style: const TextStyle(
                  color: AppColors.muted,
                  fontSize: 12,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Icon(
                Icons.arrow_forward_rounded,
                color: AppColors.mocha,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  const _ActivitySection({required this.isMobile});

  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeading(
          eyebrow: 'RECENT ACTIVITY',
          title: 'What needs your attention.',
          isMobile: isMobile,
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.ivory,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            children: [
              _ActivityRow(
                icon: Icons.photo_library_outlined,
                title: 'KALLIGRAPHY Test Gallery',
                detail: 'Published client gallery · 1 photograph',
                action: 'GALLERIES',
                route: '/studio/galleries',
              ),
              const Divider(height: 30),
              _ActivityRow(
                icon: Icons.mail_outline_rounded,
                title: 'Client inquiries',
                detail: 'Keep an eye on new booking requests.',
                action: 'VIEW',
                route: '/studio/inquiries',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.detail,
    required this.action,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String detail;
  final String action;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.sand,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.espresso, size: 19),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.espresso,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                detail,
                style: const TextStyle(color: AppColors.muted, fontSize: 11),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () => context.go(route),
          child: Text(
            action,
            style: const TextStyle(
              color: AppColors.mocha,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ],
    );
  }
}
