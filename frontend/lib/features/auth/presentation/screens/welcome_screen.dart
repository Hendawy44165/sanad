import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../widgets/auth_logo.dart';
import '../widgets/auth_form_card.dart';
import '../widgets/auth_footer.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(getIt<AuthProvider>());
    final authNotifier = ref.read(getIt<AuthProvider>().notifier);

    ref.listen(getIt<AuthProvider>(), (previous, next) {
      next.whenData((state) {
        if (state.errorMessage != null) {
          _showSnackBar(state.errorMessage!, isError: true);
        }
      });
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: authState.when(
            data: (state) => Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AuthLogo(),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.welcomeTitle,
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.welcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: AppColors.textLight, height: 1.5),
                    ),
                    const SizedBox(height: 48),
                    AuthFormCard(
                      emailController: _emailController,
                      passwordController: _passwordController,
                      isLoading: state.isLoading,
                      obscurePassword: state.obscurePassword,
                      onTogglePassword: () => authNotifier.togglePasswordVisibility(),
                      onLogin: () => authNotifier.signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                      onSignUp: () => authNotifier.signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const AuthFooter(),
                  ],
                ),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ),
      ),
    );
  }
}
