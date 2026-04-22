import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TranslatorStatusCard extends StatelessWidget {
  final bool isRecording;

  const TranslatorStatusCard({super.key, required this.isRecording});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFF8F5F2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              LucideIcons.handMetal,
              size: 64,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            isRecording ? 'Recording...' : 'Ready',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isRecording ? Colors.red : const Color(0xFF004D40),
            ),
          ),
        ],
      ),
    );
  }
}
