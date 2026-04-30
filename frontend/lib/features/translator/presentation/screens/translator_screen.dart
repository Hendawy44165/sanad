import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/translator_provider.dart';
import '../widgets/translator_app_bar.dart';
import '../widgets/translator_status_card.dart';
import '../widgets/translator_recording_button.dart';
import '../widgets/translator_tips_section.dart';

/// Screen for the Sign Language Translation feature.
/// 
/// Allows users to record video or capture signs and see real-time 
/// translations (future implementation).
class TranslatorScreen extends ConsumerWidget {
  /// Creates a [TranslatorScreen] instance.
  const TranslatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatorState = ref.watch(getIt<TranslatorProvider>());
    final translatorNotifier = ref.read(getIt<TranslatorProvider>().notifier);

    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F5F2),
      body: SafeArea(
        child: translatorState.when(
          data: (state) => Column(
            children: [
              const TranslatorAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        l10n.tapToSign,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TranslatorStatusCard(isRecording: state.isRecording),
                      const SizedBox(height: 60),
                      TranslatorRecordingButton(
                        isRecording: state.isRecording,
                        onRecordingStart: () =>
                            translatorNotifier.setRecording(true),
                        onRecordingEnd: () =>
                            translatorNotifier.setRecording(false),
                      ),
                      const SizedBox(height: 40),
                      const TranslatorTipsSection(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        ),
      ),
    );
  }
}
