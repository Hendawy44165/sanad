import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:sanad/core/theme/app_colors.dart';

class SanadFloatingButton extends StatelessWidget {
  const SanadFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          LucideIcons.heartHandshake,
          color: AppColors.secondary,
        ),
        onPressed: () {},
      ),
    );
  }
}
