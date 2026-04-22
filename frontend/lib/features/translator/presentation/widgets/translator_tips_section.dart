import 'package:flutter/material.dart';

class TranslatorTipsSection extends StatelessWidget {
  const TranslatorTipsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tips for best results',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 16),
          _buildTipItem('Ensure good lighting'),
          _buildTipItem('Keep your hands in frame'),
          _buildTipItem('Sign clearly and steadily'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF004D40),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}
