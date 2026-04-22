import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';

class OnboardingFooter extends StatelessWidget {
  final VoidCallback? onContinue;
  final bool isLoading;

  const OnboardingFooter({
    super.key,
    this.onContinue,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
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
              text: 'Continue',
              onPressed: isLoading ? null : onContinue,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'You can change this anytime in settings',
            style: TextStyle(color: AppColors.textLight, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
