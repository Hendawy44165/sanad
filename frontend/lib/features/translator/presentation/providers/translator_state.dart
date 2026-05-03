import 'package:sanad/core/constants/codes.dart';

/// Represents the UI state for the Translator feature.
///
/// This state handles video selection, the generated audio URL, and loading/error states.
class TranslatorState {
  /// The absolute local path of the selected video file.
  final String? selectedVideoPath;

  /// The remote URL of the translated audio file.
  final String? audioUrl;

  /// Indicates if the translation process is currently running.
  final bool isTranslating;

  /// Any error code returned by the repository.
  final Codes? error;

  /// Indicates if a video is currently being recorded.
  final bool isRecording;

  /// Creates an initial [TranslatorState].
  TranslatorState({this.selectedVideoPath, this.audioUrl, this.isTranslating = false, this.error, this.isRecording = false});

  /// Returns a copy of the state with updated fields.
  TranslatorState copyWith({String? selectedVideoPath, bool clearVideo = false, String? audioUrl, bool clearAudio = false, bool? isTranslating, Codes? error, bool? isRecording}) {
    return TranslatorState(selectedVideoPath: clearVideo ? null : (selectedVideoPath ?? this.selectedVideoPath), audioUrl: clearAudio ? null : (audioUrl ?? this.audioUrl), isTranslating: isTranslating ?? this.isTranslating, error: error, isRecording: isRecording ?? this.isRecording);
  }
}
