import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/constants/api_constants.dart';
import 'package:sanad/core/models/app_exception.dart';

/// Data source for managing the initial onboarding and profile setup.
/// 
/// This class handles updating the user's personal information and preferences
/// in the backend after they first sign up.
class OnboardingRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final Dio _dio;
  final ApiConfig _apiConfig;

  /// Creates an [OnboardingRemoteDataSource] instance.
  /// 
  /// Variables: [_supabaseClient] for session management. [_dio] for HTTP requests.
  /// [_apiConfig] for endpoint configurations.
  OnboardingRemoteDataSource(this._supabaseClient, this._dio, this._apiConfig);

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final session = _supabaseClient.auth.currentSession;
    if (session == null) throw const AppException(Codes.noAuthorization);

    final url = _apiConfig.profile.me;

    try {
      final response = await _dio.patch(
        url,
        data: data,
        options: Options(headers: {'Authorization': 'Bearer ${session.accessToken}', 'Content-Type': 'application/json'}),
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        final decoded = response.data;
        if (decoded['success'] != true) {
          throw const AppException(Codes.unexpectedFailure);
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const AppException(Codes.reauthenticationNeeded);
      } else {
        throw const AppException(Codes.unexpectedFailure);
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const AppException(Codes.requestTimeout);
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        throw const AppException(Codes.reauthenticationNeeded);
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
