import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';
import '../../data/datasources/translator_remote_data_source.dart';
import '../../data/models/translator_request_model.dart';
import '../entities/translator_entity.dart';

/// Repository responsible for handling Translator-related data operations.
///
/// This class serves as the single source of truth for translator data,
/// coordinating between the remote data source and the presentation layer.
class TranslatorRepository {
  final TranslatorRemoteDataSource _remoteDataSource;

  /// Creates a [TranslatorRepository] with the required data source.
  ///
  /// Variables: [_remoteDataSource] used for API network calls.
  TranslatorRepository(this._remoteDataSource);

  /// Translates a silent sign language video into pure audio.
  ///
  /// Description: Validates the local video file before sending it to the backend.
  /// Side Effects: Makes a POST request to the backend.
  /// Variables: [filePath] The absolute local path to the video.
  /// Assumptions: The file at [filePath] exists and is in a supported format (MP4, MOV, AVI).
  Future<ResponseModel<TranslatorEntity>> translateVideo(String filePath) async {
    try {
      final file = File(filePath);

      // 1. Check if file exists
      if (!(await file.exists())) {
        return const ResponseModel.failure(Codes.fileNotFound);
      }

      // 2. Check for supported extensions
      final extension = path.extension(filePath).toLowerCase();
      final allowedExtensions = ['.mp4', '.mov', '.avi'];
      if (!allowedExtensions.contains(extension)) {
        return const ResponseModel.failure(Codes.invalidFileType);
      }

      // 3. Attempt to read (check for permissions)
      try {
        await file.openRead(0, 1).first;
      } catch (e) {
        return const ResponseModel.failure(Codes.permissionDenied);
      }

      final request = TranslatorRequestModel(videoFilePath: filePath);
      final responseModel = await _remoteDataSource.translateVideo(request);
      
      final entity = TranslatorEntity.fromModel(responseModel);
      return ResponseModel.success(entity);
      
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
