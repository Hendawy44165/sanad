import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/features/auth/presentation/providers/auth_state.dart'
    as sanad_auth;

import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends AsyncNotifier<sanad_auth.AuthState> {
  final AuthRepository _repository = getIt<AuthRepository>();

  @override
  Future<sanad_auth.AuthState> build() async {
    final response = await _repository.restoreSession();

    final subscription = _repository.onAuthStateChange.listen((data) {
      final event = data.event;
      if (event == AuthChangeEvent.signedOut && state.value?.user != null) {
        state = AsyncValue.data(sanad_auth.AuthState());
      }
    });

    ref.onDispose(() {
      subscription.cancel();
    });

    if (response.isSuccess && response.data != null) {
      return sanad_auth.AuthState(user: response.data);
    }
    return sanad_auth.AuthState();
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
  ) async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();

    final response = await _repository.signIn(email, password);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(user: response.data));
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unknown),
      );
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();

    final response = await _repository.signUp(
      email,
      password,
      firstName,
      lastName,
    );

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(user: response.data));
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unknown),
      );
    }
  }

  Future<void> signOut() async {
    if (state.isLoading) return;

    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.signOut();

    if (response.isSuccess) {
      state = AsyncValue.data(sanad_auth.AuthState());
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unknown),
      );
    }
  }

  void clearError() {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

typedef AuthProvider =
    AsyncNotifierProvider<AuthNotifier, sanad_auth.AuthState>;
