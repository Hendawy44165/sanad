import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

class TranslatorRecordingButton extends ConsumerStatefulWidget {
  final bool isRecording;
  final VoidCallback onRecordingStart;
  final VoidCallback onRecordingEnd;

  const TranslatorRecordingButton({
    super.key,
    required this.isRecording,
    required this.onRecordingStart,
    required this.onRecordingEnd,
  });

  @override
  ConsumerState<TranslatorRecordingButton> createState() => _TranslatorRecordingButtonState();
}

class _TranslatorRecordingButtonState extends ConsumerState<TranslatorRecordingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => widget.onRecordingStart(),
          onLongPressEnd: (_) => widget.onRecordingEnd(),
          child: ScaleTransition(
            scale: widget.isRecording
                ? _pulseController.drive(Tween(begin: 1.0, end: 1.2))
                : const AlwaysStoppedAnimation(1.0),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFF004D40),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF004D40).withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(LucideIcons.mic, color: Colors.white, size: 40),
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Press & Hold to Record',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
