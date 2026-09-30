import 'package:go_router/go_router.dart';

import '../navigation/main_shell.dart';

abstract final class AppRoutes {
  static const home = '/';
  static const portfolio = '/portfolio';
  static const booking = '/booking';
  static const gallery = '/gallery';
  static const profile = '/profile';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) {
        return const MainShell(initialIndex: 0);
      },
    ),
    GoRoute(
      path: AppRoutes.portfolio,
      builder: (context, state) {
        return const MainShell(initialIndex: 1);
      },
    ),
    GoRoute(
      path: AppRoutes.booking,
      builder: (context, state) {
        return const MainShell(initialIndex: 2);
      },
    ),
    GoRoute(
      path: AppRoutes.gallery,
      builder: (context, state) {
        return const MainShell(initialIndex: 3);
      },
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) {
        return const MainShell(initialIndex: 4);
      },
    ),
  ],
);
