import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide MultipartFile;
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/constants/api_constants.dart';
import 'package:sanad/core/models/app_exception.dart';
import '../models/job_model.dart';

/// Low-level data source for Jobs API interactions.
/// 
/// This class handles direct HTTP communication with the dedicated Sanad backend.
/// It uses [Dio] for networking and [SupabaseClient] for authentication session management.
class JobsRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final Dio _dio;
  final ApiConfig _apiConfig;

  /// Creates a [JobsRemoteDataSource] with necessary dependencies.
  /// 
  /// Variables: [_supabaseClient] for sessions. [_dio] for HTTP. [_apiConfig] for endpoints.
  JobsRemoteDataSource(this._supabaseClient, this._dio, this._apiConfig);

  /// Fetches a paginated list of jobs from the server.
  /// 
  /// Description: Executes a GET request to the jobs list endpoint with optional filters.
  /// Side Effects: Network I/O.
  /// Variables: [query] search text. [isRemote] filter. [page] pagination. [limit] results per page.
  /// Assumptions: [url] is properly formatted in [ApiConfig].
  Future<JobsResponse> getJobs({
    String? query, 
    bool? isRemote, 
    int page = 1, 
    int limit = 20,
  }) async {
    final url = _apiConfig.jobs.list;

    try {
      final response = await _dio.get(
        url, 
        queryParameters: {
          if (query != null && query.isNotEmpty) 'q': query, 
          if (isRemote != null) 'is_remote': isRemote, 
          'page': page, 
          'limit': limit,
        },
      );

      final decoded = response.data;

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (decoded['success'] == true) {
          return JobsResponse.fromJson(decoded);
        } else {
          throw const AppException(Codes.unexpectedFailure);
        }
      } else {
        throw const AppException(Codes.unexpectedFailure);
      }
    } on DioException catch (e) {
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

  /// Uploads a file as a CV to the backend.
  /// 
  /// Description: Performs a multipart POST request with the user's Bearer token.
  /// Side Effects: Uploads file to server, updates user profile metadata on backend.
  /// Variables: [filePath] path to the file.
  /// Assumptions: User is logged in to Supabase. Backend accepts multipart/form-data.
  Future<String> uploadCv(String filePath) async {
    final url = _apiConfig.jobs.uploadCv;
    final session = _supabaseClient.auth.currentSession;

    if (session == null) {
      _supabaseClient.auth.signOut();
      throw const AppException(Codes.reauthenticationNeeded);
    }

    try {
      final formData = FormData.fromMap({
        'cv': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer ${session.accessToken}'}),
      );

      final decoded = response.data;

      if (response.statusCode == 201) {
        if (decoded['success'] == true) {
          final data = decoded['data'] as Map<String, dynamic>;
          return data['cv_file_url'] as String;
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
    } catch (e) {
      if (e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }
}
