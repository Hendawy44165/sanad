import 'package:flutter/material.dart';
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
          bg: const Color(0xFFD1FAE5),
          fg: const Color(0xFF065F46),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}
