import 'package:flutter/material.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';

class AuthFormCard extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final bool obscurePassword;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onSignUp;

  const AuthFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.obscurePassword,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.welcomeBack,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 24),
            CustomInput(
              labelText: l10n.emailAddress,
              hintText: l10n.emailHint,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            CustomInput(
              labelText: l10n.password,
              hintText: l10n.passwordHint,
              controller: passwordController,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: AppColors.textLight,
                ),
                onPressed: onTogglePassword,
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: l10n.signIn,
              isLoading: isLoading,
              onPressed: onLogin,
            ),
            const SizedBox(height: 24),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "${l10n.noAccount} ",
                  style: const TextStyle(color: AppColors.textLight),
                ),
                GestureDetector(
                  onTap: onSignUp,
                  child: const Text(
                    'Create one', // TODO: use l10n.createOne if available, keeping as is for now
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
