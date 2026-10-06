import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/main_shell.dart';
import '../../features/studio/studio_galleries_screen.dart';
import '../../features/studio/studio_gallery_manager_screen.dart';

import '../../features/auth/auth_gate.dart';
import '../../features/auth/photographer_shell.dart';
import '../../features/booking/booking_screen.dart';
import '../../features/booking/packages_screen.dart';
import '../../features/gallery/client_gallery_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/inquiries/inquiries_screen.dart';
import '../../features/portfolio/portfolio_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/studio/studio_dashboard_screen.dart';

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
          path: '/profile',
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/client-gallery/:token',
      name: 'client-gallery',
      builder: (context, state) {
        return ClientGalleryScreen(token: state.pathParameters['token']!);
      },
    ),

    ShellRoute(
      builder: (context, state, child) {
        return AuthGate(
          builder: (context, session, logout) {
            final Widget studioPage;

            if (state.uri.path == '/studio/inquiries') {
              studioPage = InquiriesScreen(session: session);
            } else if (state.uri.path == '/studio/galleries') {
              studioPage = StudioGalleriesScreen(session: session);
            } else if (state.uri.path.startsWith('/studio/galleries/')) {
              final galleryId = int.parse(state.pathParameters['galleryId']!);

              studioPage = StudioGalleryManagerScreen(
                session: session,
                galleryId: galleryId,
              );
            } else {
              studioPage = const StudioDashboardScreen();
            }

            return PhotographerShell(
              session: session,
              onLogout: logout,
              child: studioPage,
            );
          },
        );
      },
      routes: [
        GoRoute(
          path: '/studio',
          name: 'studio',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: '/studio/inquiries',
          name: 'studio-inquiries',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: '/studio/galleries',
          name: 'studio-galleries',
          builder: (context, state) => const SizedBox.shrink(),
        ),
        GoRoute(
          path: '/studio/galleries/:galleryId',
          name: 'studio-gallery-manager',
          builder: (context, state) => const SizedBox.shrink(),
        ),
      ],
    ),
  ],
);
