import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Welcome, Friend!',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'How can we best support you?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Select your primary need so we can personalize your experience and show relevant resources.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
