import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/features/auth/presentation/providers/auth_state.dart'
    as sanad_auth_state;

import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/core/services/error_handling_service.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends AsyncNotifier<sanad_auth_state.AuthState> {
  final AuthRepository _repository = getIt<AuthRepository>();

  @override
  Future<sanad_auth_state.AuthState> build() async {
    final response = await _repository.restoreSession();

    final subscription = _repository.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedOut && state.value?.user != null) {
        state = AsyncValue.data(sanad_auth_state.AuthState());
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    if (response.isSuccess) {
      return sanad_auth_state.AuthState(user: response.data);
    }
    return sanad_auth_state.AuthState();
  }

  void togglePasswordVisibility() {
    if (state.value == null || state.isLoading) return;
    state = AsyncValue.data(
      state.value!.copyWith(obscurePassword: !state.value!.obscurePassword),
    );
  }

  Future<void> signIn(
    String email,
    String password,
    AppLocalizations l10n,
  ) async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();

    final response = await _repository.signIn(email, password);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(user: response.data));
    } else {
      final errorMessage = ErrorHandlingService.getMessage(
        response.errorCode ?? Codes.unknown,
        l10n,
      );
      state = AsyncValue.error(errorMessage, StackTrace.current);
      state = AsyncValue.data(oldState);
    }
  }

  Future<void> signUp(
    String email,
    String password,
    AppLocalizations l10n,
  ) async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();

    final response = await _repository.signUp(email, password);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(user: response.data));
    } else {
      final errorMessage = ErrorHandlingService.getMessage(
        response.errorCode ?? Codes.unknown,
        l10n,
      );
      state = AsyncValue.error(errorMessage, StackTrace.current);
      state = AsyncValue.data(oldState);
    }
  }

  Future<void> signOut(AppLocalizations l10n) async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.signOut();

    if (response.isSuccess) {
      state = AsyncValue.data(sanad_auth_state.AuthState());
    } else {
      final errorMessage = ErrorHandlingService.getMessage(
        response.errorCode ?? Codes.unknown,
        l10n,
      );
      state = AsyncValue.error(errorMessage, StackTrace.current);
      state = AsyncValue.data(oldState);
    }
  }
}

typedef AuthProvider =
    AsyncNotifierProvider<AuthNotifier, sanad_auth_state.AuthState>;
