/// Model representing the API response after translating a sign language video.
///
/// This handles parsing the raw JSON from the backend into a strongly typed data structure.
class TranslatorResponseModel {
  final String audioUrl;
  final bool success;

  /// Creates a [TranslatorResponseModel].
  ///
  /// Variables: [audioUrl] the remote URL of the generated audio file. [success] backend success flag.
  TranslatorResponseModel({
    required this.audioUrl,
    required this.success,
  });

  /// Factory to parse JSON into a [TranslatorResponseModel].
  ///
  /// Description: Maps the 'data' structure from the backend's standard JSON wrapper.
  /// Assumptions: The backend returns `{ "success": true, "data": { "audio_url": "..." } }`.
  factory TranslatorResponseModel.fromJson(Map<String, dynamic> json) {
    return TranslatorResponseModel(
      audioUrl: json['data']?['audio_url'] ?? '',
      success: json['success'] ?? false,
    );
  }
}
