import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/codes.dart';
import '../../logic/repositories/translator_repository.dart';
import 'translator_state.dart';

/// Notifier for the Translator feature that handles video selection and translation.
class TranslatorNotifier extends AsyncNotifier<TranslatorState> {
  final TranslatorRepository _repository;

  /// Injects the required repository via constructor.
  ///
  /// Variables: [_repository] used for API interactions.
  TranslatorNotifier(this._repository);

  @override
  Future<TranslatorState> build() async {
    return TranslatorState();
  }

  /// Sets the selected video path.
  void selectVideo(String path) {
    final oldState = state.value;
    if (oldState == null) return;

    // Clear the previous audio URL when a new video is selected
    state = AsyncValue.data(oldState.copyWith(selectedVideoPath: path, clearAudio: true, error: null));
  }

  /// Clears the selected video and audio.
  void clearSelection() {
    final oldState = state.value;
    if (oldState == null) return;

    state = AsyncValue.data(oldState.copyWith(clearVideo: true, clearAudio: true, error: null));
  }

  /// Translates the currently selected video.
  Future<void> translateVideo() async {
    final oldState = state.value;
    if (oldState == null || oldState.selectedVideoPath == null || oldState.isTranslating) return;

    state = AsyncValue.data(oldState.copyWith(isTranslating: true, error: null));

    final response = await _repository.translateVideo(oldState.selectedVideoPath!);

    if (response.isSuccess) {
      state = AsyncValue.data(oldState.copyWith(audioUrl: response.data!.audioUrl, isTranslating: false));
    } else {
      state = AsyncValue.data(oldState.copyWith(isTranslating: false, error: response.errorCode ?? Codes.unknown));
    }
  }

  /// Resets the error code in the state.
  void clearError() {
    final oldState = state.value;
    if (oldState == null) return;
    state = AsyncValue.data(oldState.copyWith(error: null));
  }
}

/// Typedef for the global Translator notifier provider.
typedef TranslatorProvider = AsyncNotifierProvider<TranslatorNotifier, TranslatorState>;
