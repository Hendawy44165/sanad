import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/constants/api_constants.dart';
import 'package:sanad/core/models/app_exception.dart';
import '../models/translator_request_model.dart';
import '../models/translator_response_model.dart';

/// Low-level data source for Translator API interactions.
///
/// This class handles direct HTTP communication with the dedicated backend for video translation.
/// It uses [Dio] for networking and [SupabaseClient] for authentication session management.
class TranslatorRemoteDataSource {
  final Dio _dio;
  final ApiConfig _apiConfig;

  /// Creates a [TranslatorRemoteDataSource] with necessary dependencies.
  ///
  /// Variables: [_supabaseClient] for sessions. [_dio] for HTTP. [_apiConfig] for endpoints.
  TranslatorRemoteDataSource(this._dio, this._apiConfig);

  /// Uploads a video for translation to audio.
  ///
  /// Description: Performs a multipart POST request to the translation endpoint.
  /// Side Effects: Network I/O.
  /// Variables: [request] The model containing the video file path.
  /// Assumptions:Backend accepts multipart/form-data.
  Future<TranslatorResponseModel> translateVideo(TranslatorRequestModel request) async {
    final url = _apiConfig.translator.translateVideo;

    try {
      final formData = FormData.fromMap({'video': await MultipartFile.fromFile(request.videoFilePath)});

      final response = await _dio.post(url, data: formData);

      final decoded = response.data;

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (decoded['success'] == true) {
          return TranslatorResponseModel.fromJson(decoded);
        } else {
          throw const AppException(Codes.unexpectedFailure);
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const AppException(Codes.reauthenticationNeeded);
      } else {
        throw const AppException(Codes.unexpectedFailure);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw const AppException(Codes.reauthenticationNeeded);
      }
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const AppException(Codes.requestTimeout);
      }
      throw const AppException(Codes.unexpectedFailure);
    } on SocketException {
      throw const AppException(Codes.requestTimeout);
    } on TimeoutException {
      throw const AppException(Codes.requestTimeout);
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }
}
