import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.favorite, color: AppColors.primary, size: 40),
    );
  }
}
