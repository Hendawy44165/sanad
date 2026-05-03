import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'profile_icon_box.dart';

class ProfileSectionLabel extends StatelessWidget {
  final String label;
  final IconData icon;

  const ProfileSectionLabel({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ProfileIconBox(
          icon: icon,
          bg: AppColors.secondary,
          fg: AppColors.primary,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: AppColors.text,
          ),
        ),
      ],
    );
  }
}
