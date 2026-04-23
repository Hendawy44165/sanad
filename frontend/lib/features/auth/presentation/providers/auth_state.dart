import 'package:sanad/features/auth/logic/entities/user_entity.dart';

class AuthState {
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;
  final UserEntity? user;

  AuthState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.errorMessage,
    this.user,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? errorMessage,
    UserEntity? user,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage,
      user: user ?? this.user,
    );
  }
}

