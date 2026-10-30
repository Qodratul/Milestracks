import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/auth/presentation/auth_screen.dart';
import 'package:milestracks/features/auth/presentation/welcome_screen.dart';
import 'package:milestracks/features/friends/presentation/friends_screen.dart';
import 'package:milestracks/features/history/presentation/history_detail_screen.dart';
import 'package:milestracks/features/history/presentation/history_screen.dart';
import 'package:milestracks/features/home/presentation/notifications_screen.dart';
import 'package:milestracks/features/league/presentation/league_screen.dart';
import 'package:milestracks/features/onboarding/presentation/onboarding_screens.dart';
import 'package:milestracks/features/profile/presentation/profile_screen.dart';
import 'package:milestracks/features/run/presentation/run_mode_screen.dart';
import 'package:milestracks/features/run/presentation/run_recovery_screen.dart';
import 'package:milestracks/features/run/presentation/run_result_screen.dart';
import 'package:milestracks/features/settings/presentation/settings_screen.dart';
import 'package:milestracks/features/shop/presentation/shop_screen.dart';
import 'package:milestracks/features/streak/presentation/streak_screen.dart';
import 'package:milestracks/features/track/presentation/generating_screen.dart';
import 'package:milestracks/features/track/presentation/track_preparation_screen.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refresh = _RouterRefreshNotifier();
  final router = GoRouter(
    initialLocation: '/welcome',
    refreshListenable: refresh,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isPublic = location == '/welcome' || location == '/auth';
      final isOnboarding = location.startsWith('/onboarding');
      final authenticated = ref.read(sessionControllerProvider);
      final onboardingComplete = ref.read(onboardingControllerProvider);

      if (!authenticated) return isPublic ? null : '/welcome';
      if (!onboardingComplete && !isOnboarding) {
        return '/onboarding/readiness';
      }
      if (onboardingComplete &&
          (location == '/welcome' || location == '/auth' || isOnboarding)) {
        return '/home';
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => AuthScreen(
          initialSignUp: state.uri.queryParameters['mode'] == 'signup',
        ),
      ),
      GoRoute(
        path: '/onboarding/readiness',
        builder: (context, state) => const ReadinessScreen(),
      ),
      GoRoute(
        path: '/onboarding/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      GoRoute(
        path: '/onboarding/finish',
        builder: (context, state) => const OnboardingFinishScreen(),
      ),
      GoRoute(
        path: '/run-recovery',
        builder: (context, state) => const RunRecoveryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/streak',
        builder: (context, state) => const StreakScreen(),
      ),
      GoRoute(
        path: '/generating',
        builder: (context, state) => const GeneratingScreen(),
      ),
      GoRoute(
        path: '/prepare/:trackId',
        builder: (context, state) =>
            TrackPreparationScreen(trackId: state.pathParameters['trackId']!),
      ),
      GoRoute(
        path: '/run/:trackId',
        builder: (context, state) =>
            RunModeScreen(trackId: state.pathParameters['trackId']!),
      ),
      GoRoute(
        path: '/run-result',
        builder: (context, state) => const RunResultScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            _MainTabShell(location: state.matchedLocation, child: child),
        routes: <RouteBase>[
          GoRoute(
            path: '/home',
            builder: (context, state) => const RunRecoveryScreen(),
            routes: <RouteBase>[
              GoRoute(
                path: 'notifications',
                builder: (context, state) =>
                    const NotificationsScreen(showBottomNavigation: false),
              ),
            ],
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) =>
                const NotificationsScreen(showBottomNavigation: false),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) =>
                const HistoryScreen(showBottomNavigation: false),
            routes: <RouteBase>[
              GoRoute(
                path: ':runId',
                builder: (context, state) =>
                    HistoryDetailScreen(runId: state.pathParameters['runId']!),
              ),
            ],
          ),
          GoRoute(
            path: '/shop',
            builder: (context, state) =>
                const ShopScreen(showBottomNavigation: false),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) =>
                const ProfileScreen(showBottomNavigation: false),
          ),
          GoRoute(
            path: '/league',
            builder: (context, state) =>
                const LeagueScreen(showBottomNavigation: false),
          ),
          GoRoute(
            path: '/friends',
            builder: (context, state) =>
                const FriendsScreen(showBottomNavigation: false),
          ),
        ],
      ),
    ],
  );

  ref.listen(sessionControllerProvider, (previous, next) => refresh.ping());
  ref.listen(onboardingControllerProvider, (previous, next) => refresh.ping());
  ref.onDispose(() {
    router.dispose();
    refresh.dispose();
  });
  return router;
}

/// Keeps the main tab dock mounted while route content above it changes.
class _MainTabShell extends StatelessWidget {
  const _MainTabShell({required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selected = switch (location) {
      final path when path.startsWith('/history') => MainDestination.history,
      '/shop' => MainDestination.shop,
      '/league' => MainDestination.league,
      '/friends' => MainDestination.friends,
      '/profile' => MainDestination.profile,
      _ => MainDestination.home,
    };
    return Scaffold(
      backgroundColor: context.milestracksTokens.background,
      body: child,
      bottomNavigationBar: MilestracksBottomNavigation(
        selected: selected,
        homeStyle: true,
      ),
    );
  }
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void ping() => notifyListeners();
}
