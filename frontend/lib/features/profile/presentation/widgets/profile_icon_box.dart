import 'package:flutter/material.dart';

class ProfileIconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color fg;

  const ProfileIconBox({
    super.key,
    required this.icon,
    required this.bg,
    required this.fg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: fg, size: 20),
    );
  }
}
