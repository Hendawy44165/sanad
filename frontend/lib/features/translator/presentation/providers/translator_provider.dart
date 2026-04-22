import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'translator_state.dart';

class TranslatorNotifier extends AsyncNotifier<TranslatorState> {
  @override
  Future<TranslatorState> build() async {
    return TranslatorState();
  }

  void setRecording(bool isRecording) {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(isRecording: isRecording));
  }
}

typedef TranslatorProvider = AsyncNotifierProvider<TranslatorNotifier, TranslatorState>;
