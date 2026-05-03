import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';

class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(24)),
      child: const Icon(Icons.favorite_border, color: AppColors.primary, size: 40),
    );
  }
}
