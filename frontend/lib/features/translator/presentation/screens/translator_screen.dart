import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';
import '../providers/translator_provider.dart';
import '../providers/translator_state.dart';
import '../widgets/translator_app_bar.dart';
import '../widgets/video_picker_widget.dart';
import '../widgets/audio_player_widget.dart';

/// Screen for the Sign Language Translation feature.
///
/// Description: Allows users to select a video and see real-time translations via audio playback.
/// This screen coordinates the video selection flow and handles the display of translation results.
class TranslatorScreen extends ConsumerWidget {
  /// Creates a [TranslatorScreen] instance.
  const TranslatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final translatorState = ref.watch(getIt<TranslatorProvider>());
    final translatorNotifier = ref.read(getIt<TranslatorProvider>().notifier);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: translatorState.when(
          data: (state) => Column(
            children: [
              const TranslatorAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      Text(
                        l10n.tapToSign,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textLight,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildVideoPicker(state, translatorNotifier),
                      const SizedBox(height: 24),
                      if (state.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: Text(
                            state.error.toString(),
                            style: const TextStyle(color: AppColors.error),
                          ),
                        ),
                      if (state.selectedVideoPath != null &&
                          !state.isTranslating &&
                          state.audioUrl == null)
                        ElevatedButton.icon(
                          onPressed: () => translatorNotifier.translateVideo(),
                          icon: const Icon(Icons.translate),
                          label: Text(l10n.translateVideo),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.onPrimary,
                          ),
                        ),
                      if (state.isTranslating)
                        const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      if (state.audioUrl != null && state.audioUrl!.isNotEmpty)
                        _buildAudioPlayer(state.audioUrl!),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(
              color: AppColors.primary,
            ),
          ),
          error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        ),
      ),
    );
  }

  /// Builds the video picker section of the screen.
  ///
  /// Description: Renders the [VideoPickerWidget] with state-driven callbacks.
  /// Variables:
  ///   [state] the current [TranslatorState].
  ///   [translatorNotifier] the notifier to handle user actions.
  Widget _buildVideoPicker(
      TranslatorState state, TranslatorNotifier translatorNotifier) {
    return VideoPickerWidget(
      selectedVideoPath: state.selectedVideoPath,
      onVideoSelected: (path) => translatorNotifier.selectVideo(path),
      onClear: () => translatorNotifier.clearSelection(),
    );
  }

  /// Builds the audio player section of the screen.
  ///
  /// Description: Renders the [AudioPlayerWidget] when a translation is available.
  /// Variables:
  ///   [url] the remote URL of the translated audio.
  Widget _buildAudioPlayer(String url) {
    return AudioPlayerWidget(audioUrl: url);
  }
}
