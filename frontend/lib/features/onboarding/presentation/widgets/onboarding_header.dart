import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';

import '../../../../l10n/app_localizations.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.onboardingWelcome,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.onboardingQuestion,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          l10n.onboardingSubtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textLight,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
