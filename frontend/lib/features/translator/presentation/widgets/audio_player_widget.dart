import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/l10n/app_localizations.dart';

/// Widget for displaying and interacting with the generated audio URL.
///
/// Description: Renders a UI component that informs the user the translation is ready
/// and provides a button to open the audio file using a system-handled URL.
class AudioPlayerWidget extends StatelessWidget {
  /// The remote URL of the generated audio file.
  final String audioUrl;

  /// Creates an [AudioPlayerWidget].
  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
  });

  /// Opens the audio URL in an external browser or media player.
  ///
  /// Description: Uses [url_launcher] to handle the remote audio link.
  /// Side Effects: Navigates away from the app to a browser or system player.
  /// Variables:
  ///   [context] used for showing feedback on failure.
  /// Assumptions: [audioUrl] is a valid, accessible URI.
  Future<void> _openAudioUrl(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final uri = Uri.parse(audioUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.err_couldNotOpenAudio)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Card(
      color: AppColors.secondary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(Icons.audiotrack, size: 48, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              l10n.translationReady,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _openAudioUrl(context),
              icon: const Icon(Icons.play_arrow),
              label: Text(l10n.openAudio),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
