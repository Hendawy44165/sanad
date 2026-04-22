import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/presentation/providers/auth_state.dart'
    as sanad_auth_state;

class AuthNotifier extends AsyncNotifier<sanad_auth_state.AuthState> {
  @override
  Future<sanad_auth_state.AuthState> build() async {
    return sanad_auth_state.AuthState();
  }

  void togglePasswordVisibility() {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(obscurePassword: !state.value!.obscurePassword),
    );
  }

  Future<void> signIn(String email, String password) async {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(state.value!.copyWith(isLoading: false));
    } on AuthException catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, errorMessage: e.message),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isLoading: false,
          errorMessage: 'Unexpected error occurred',
        ),
      );
    }
  }

  Future<void> signUp(String email, String password) async {
    if (state.value == null) return;
    state = AsyncValue.data(
      state.value!.copyWith(isLoading: true, errorMessage: null),
    );

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );
      state = AsyncValue.data(state.value!.copyWith(isLoading: false));
    } on AuthException catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(isLoading: false, errorMessage: e.message),
      );
    } catch (e) {
      state = AsyncValue.data(
        state.value!.copyWith(
          isLoading: false,
          errorMessage: 'Unexpected error occurred',
        ),
      );
    }
  }
}

typedef AuthProvider =
    AsyncNotifierProvider<AuthNotifier, sanad_auth_state.AuthState>;
