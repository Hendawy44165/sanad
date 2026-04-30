import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/features/onboarding/presentation/screens/select_disability_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/presentation/screens/welcome_screen.dart';
import 'package:sanad/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sanad/features/doctors/presentation/screens/doctors_screen.dart';
import 'package:sanad/features/jobs/presentation/screens/jobs_screen.dart';
import 'package:sanad/features/books/presentation/screens/books_screen.dart';
import 'package:sanad/features/translator/presentation/screens/translator_screen.dart';
import 'package:sanad/features/profile/presentation/screens/profile_screen.dart';

/// Provides the [GoRouter] configuration for the application.
/// 
/// Handles initial location, authentication-based redirects, and route definitions.
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggingIn = state.uri.path == '/login';

      if (session == null && !isLoggingIn) return '/login';

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
            path: 'jobs',
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: 'books',
            builder: (context, state) => const BooksScreen(),
          ),
          GoRoute(
            path: 'translator',
            builder: (context, state) => const TranslatorScreen(),
          ),

          GoRoute(
            path: 'doctors',
            builder: (context, state) => const DoctorsScreen(),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
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
