import 'package:go_router/go_router.dart';

import '../navigation/main_shell.dart';
import '../../features/home/home_screen.dart';
import '../../features/portfolio/portfolio_screen.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/booking/packages_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/profile/profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/portfolio',
          name: 'portfolio',
          builder: (context, state) => const PortfolioScreen(),
        ),
        GoRoute(
          path: '/booking',
          name: 'booking',
          builder: (context, state) => const BookingScreen(),
        ),
        GoRoute(
          path: '/packages',
          name: 'packages',
          builder: (context, state) => const PackagesScreen(),
        ),
        GoRoute(
          path: '/gallery',
          name: 'gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
