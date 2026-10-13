import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/discovery/presentation/discovery_screen.dart';
import '../features/puzzle/presentation/screens/achievements_screen.dart';
import '../features/puzzle/presentation/screens/daily_screen.dart';
import '../features/puzzle/presentation/screens/home_screen.dart';
import '../features/puzzle/presentation/screens/legal_screen.dart';
import '../features/puzzle/presentation/screens/levels_screen.dart';
import '../features/puzzle/presentation/screens/onboarding_screen.dart';
import '../features/puzzle/presentation/screens/play_screen.dart';
import '../features/puzzle/presentation/screens/premium_screen.dart';
import '../features/puzzle/presentation/screens/profile_screen.dart';
import '../features/puzzle/presentation/screens/settings_screen.dart';
import '../features/puzzle/presentation/screens/speed_screen.dart';
import '../features/puzzle/presentation/screens/splash_screen.dart';
import '../features/puzzle/presentation/screens/stats_screen.dart';
import '../features/puzzle/presentation/screens/worlds_screen.dart';
import 'providers.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (c, s) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (c, s) => const OnboardingScreen()),
      GoRoute(path: '/home', builder: (c, s) => const HomeScreen()),
      GoRoute(path: '/worlds', builder: (c, s) => const WorldsScreen()),
      GoRoute(
        path: '/worlds/:id',
        builder: (c, s) => LevelsScreen(worldId: s.pathParameters['id']!),
      ),
      GoRoute(
        path: '/play/:id',
        builder: (c, s) => PlayScreen(puzzleId: s.pathParameters['id']!),
      ),
      GoRoute(path: '/daily', builder: (c, s) => const DailyScreen()),
      GoRoute(path: '/speed', builder: (c, s) => const SpeedScreen()),
      GoRoute(path: '/discovery', builder: (c, s) => const DiscoveryScreen()),
      GoRoute(path: '/stats', builder: (c, s) => const StatsScreen()),
      GoRoute(path: '/achievements', builder: (c, s) => const AchievementsScreen()),
      GoRoute(path: '/settings', builder: (c, s) => const SettingsScreen()),
      GoRoute(path: '/profile', builder: (c, s) => const ProfileScreen()),
      GoRoute(
        path: '/premium',
        redirect: (c, s) {
          final enabled = ProviderScope.containerOf(c).read(appConfigProvider).monetizationEnabled;
          if (!enabled) return '/home';
          return null;
        },
        builder: (c, s) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/legal/:kind',
        builder: (c, s) => LegalScreen(kind: s.pathParameters['kind']!),
      ),
    ],
  );
});
