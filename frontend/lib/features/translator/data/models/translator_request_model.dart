/// Model representing the request payload for translating a sign language video.
///
/// This separates the concerns of the API payload format from the business logic.
class TranslatorRequestModel {
  final String videoFilePath;

  /// Creates a [TranslatorRequestModel].
  ///
  /// Variables: [videoFilePath] is the local absolute path of the silent sign language video.
  TranslatorRequestModel({required this.videoFilePath});
}
