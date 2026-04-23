import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/widgets/custom_button.dart';

import '../../../../l10n/app_localizations.dart';

class OnboardingFooter extends StatelessWidget {
  final VoidCallback? onContinue;
  final bool isLoading;

  const OnboardingFooter({super.key, this.onContinue, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: CustomButton(
              text: l10n.continueButton,
              onPressed: isLoading ? null : onContinue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.changeAnytime,
            style: const TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
