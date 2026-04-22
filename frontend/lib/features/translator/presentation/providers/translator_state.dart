class TranslatorState {
  final bool isRecording;

  TranslatorState({
    this.isRecording = false,
  });

  TranslatorState copyWith({
    bool? isRecording,
  }) {
    return TranslatorState(
      isRecording: isRecording ?? this.isRecording,
    );
  }
}
