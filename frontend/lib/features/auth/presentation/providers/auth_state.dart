import 'package:sanad/features/auth/logic/entities/user_entity.dart';
import 'package:sanad/core/constants/codes.dart';

class AuthState {
  final bool isLoading;
  final bool obscurePassword;
  final Codes? error;
  final UserEntity? user;

  AuthState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.error,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    Codes? error,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      error: error,
      user: user ?? this.user,
    );
  }
}

