class AuthState {
  final bool isLoading;
  final bool obscurePassword;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.obscurePassword = true,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? obscurePassword,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      errorMessage: errorMessage,
    );
  }
}
