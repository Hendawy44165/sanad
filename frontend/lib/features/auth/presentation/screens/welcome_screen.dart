import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:sanad/features/auth/presentation/providers/auth_provider.dart';
import 'package:sanad/core/services/error_handling_service.dart';
import 'package:sanad/features/auth/presentation/widgets/auth_logo.dart';
import 'package:sanad/features/auth/presentation/widgets/animated_input_field.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  bool _isLogin = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeIn));

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutQuart));

    _animationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final authNotifier = ref.read(getIt<AuthProvider>().notifier);
      final email = _emailController.text.trim().toLowerCase();
      final password = _passwordController.text;

      if (_isLogin) {
        authNotifier.signIn(email, password);
      } else {
        authNotifier.signUp(email, password, _firstNameController.text.trim(), _lastNameController.text.trim());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(getIt<AuthProvider>());
    final l10n = AppLocalizations.of(context)!;

    ref.listen(getIt<AuthProvider>(), (previous, next) {
      final error = next.value?.error;
      if (error != null) {
        final errorMessage = ErrorHandlingService.getMessage(error, l10n);
        _showSnackBar(errorMessage, isError: true);
        ref.read(getIt<AuthProvider>().notifier).clearError();
      } else if (next.hasValue && next.value?.user != null && (previous?.value?.user == null)) {
        _showSnackBar(_isLogin ? l10n.loginSuccessful : l10n.signUpSuccessful);
        if (mounted) {
          if (next.value?.user!.disabilityType == null)
            context.go('/select_disability');
          else
            context.go('/');
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // App Logo
                    const AuthLogo(),
                    const SizedBox(height: 32),
                    Text(
                      l10n.welcomeTitle,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.text,
                        fontFamily: 'Pacifico', // Attempting script feel
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        l10n.welcomeSubtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppColors.text.withValues(alpha: 0.6), height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Solid Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, 10))],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _isLogin ? l10n.welcomeBack : l10n.createAccount,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.text, fontFamily: 'Pacifico'),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            if (!_isLogin) ...[
                              Row(
                                children: [
                                  Expanded(
                                    child: AnimatedInputField(
                                      label: l10n.firstName,
                                      icon: Icons.person_outline,
                                      controller: _firstNameController,
                                      validator: (value) {
                                        if (!_isLogin && (value == null || value.isEmpty)) {
                                          return l10n.firstNameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: AnimatedInputField(
                                      label: l10n.lastName,
                                      icon: Icons.person_outline,
                                      controller: _lastNameController,
                                      validator: (value) {
                                        if (!_isLogin && (value == null || value.isEmpty)) {
                                          return l10n.lastNameRequired;
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
                            AnimatedInputField(
                              label: l10n.emailAddress,
                              icon: Icons.email_outlined,
                              controller: _emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.emailRequired;
                                }
                                if (!value.contains('@')) {
                                  return l10n.emailInvalid;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            AnimatedInputField(
                              label: l10n.password,
                              icon: Icons.lock_outline,
                              isPassword: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return l10n.passwordRequired;
                                }
                                if (value.length < 6) {
                                  return l10n.passwordTooShort;
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            authState.maybeWhen(
                              data: (state) => ElevatedButton(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  elevation: 0,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(_isLogin ? l10n.signIn : l10n.createOne, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                              ),
                              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                              orElse: () => const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_isLogin ? l10n.noAccount : l10n.alreadyHaveAccount, style: TextStyle(color: AppColors.text.withValues(alpha: 0.6))),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isLogin = !_isLogin;
                                      _formKey.currentState?.reset();
                                    });
                                  },
                                  child: Text(
                                    _isLogin ? l10n.signUp : l10n.logIn,
                                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 16, color: AppColors.textLight),
                        const SizedBox(width: 8),
                        Text(l10n.dataSecureText, style: TextStyle(color: AppColors.text.withValues(alpha: 0.5), fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
