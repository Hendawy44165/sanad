import '../../data/models/translator_response_model.dart';

/// Represents a Translator Result in the business logic layer.
/// This object is clean and decoupled from API-specific field names.
class TranslatorEntity {
  final String audioUrl;

  TranslatorEntity({
    required this.audioUrl,
  });

  /// Factory to create a [TranslatorEntity] from a data layer [TranslatorResponseModel].
  /// 
  /// This decouples the data layer from logic requirements while allowing
  /// the logic layer to define its own transformations.
  factory TranslatorEntity.fromModel(TranslatorResponseModel model) {
    return TranslatorEntity(
      audioUrl: model.audioUrl,
    );
  }
}
