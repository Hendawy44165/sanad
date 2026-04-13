import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/features/onboarding/presentation/screens/select_disability_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/presentation/screens/welcome_screen.dart';
import 'package:sanad/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sanad/features/doctors/presentation/screens/doctors_screen.dart';
import 'package:sanad/features/events/presentation/screens/events_screen.dart';
import 'package:sanad/features/news/data/models/news_item.dart';
import 'package:sanad/features/news/presentation/screens/news_details_screen.dart';
import 'package:sanad/features/news/presentation/screens/news_screen.dart';
import 'package:sanad/features/services/presentation/screens/services_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      // If auth state is loading, don't redirect yet
      if (authState.isLoading) return null;

      final session = authState.value?.session;
      final isLoggingIn = state.uri.path == '/login';

      if (session == null && !isLoggingIn) return '/login';
      if (session != null && isLoggingIn) return '/';

      return null;
    },
    refreshListenable: GoRouterRefreshStream(
      Supabase.instance.client.auth.onAuthStateChange,
    ),
    routes: [
      GoRoute(
        path: '/select_disability',
        builder: (context, state) => const SelectDisabilityScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const DashboardScreen(),
        routes: [
          GoRoute(
            path: 'services',
            builder: (context, state) => const ServicesScreen(),
          ),
          GoRoute(
            path: 'events',
            builder: (context, state) => const EventsScreen(),
          ),
          GoRoute(
            path: 'news',
            builder: (context, state) => const NewsScreen(),
            routes: [
              GoRoute(
                path: 'details',
                builder: (context, state) {
                  final newsItem = state.extra as NewsItem;
                  return NewsDetailsScreen(newsItem: newsItem);
                },
              ),
            ],
          ),

          GoRoute(
            path: 'doctors',
            builder: (context, state) => const DoctorsScreen(),
          ),
        ],
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<AuthState> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
