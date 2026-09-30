import 'package:go_router/go_router.dart';

import '../../features/booking/booking_screen.dart';
import '../../features/gallery/gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/portfolio/portfolio_screen.dart';
import '../../features/profile/profile_screen.dart';

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
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.portfolio,
      builder: (context, state) => const PortfolioScreen(),
    ),
    GoRoute(
      path: AppRoutes.booking,
      builder: (context, state) => const BookingScreen(),
    ),
    GoRoute(
      path: AppRoutes.gallery,
      builder: (context, state) => const GalleryScreen(),
    ),
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
