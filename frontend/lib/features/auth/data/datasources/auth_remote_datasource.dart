import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/features/auth/data/models/user_model.dart';

class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  final Dio _dio;
  final String _baseUrl = dotenv.env['API_BASE_URL']!;

  AuthRemoteDataSource(this._supabaseClient, this._dio);

  Stream<AuthState> get onAuthStateChange => _supabaseClient.auth.onAuthStateChange;

  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      final authResponse = await _supabaseClient.auth.signInWithPassword(email: email, password: password);

      if (authResponse.session == null) {
        throw const AppException(Codes.unexpectedFailure);
      }

      final userModel = await _syncProfile(authResponse.session!.accessToken);
      return userModel;
    } on AuthException catch (_) {
      rethrow;
    } on SocketException {
      throw const AppException(Codes.requestTimeout);
    } on TimeoutException {
      throw const AppException(Codes.requestTimeout);
    } catch (e) {
      if (e is AuthException || e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }

  Future<UserModel> signUp(String email, String password, String firstName, String lastName) async {
    try {
      final authResponse = await _supabaseClient.auth.signUp(email: email, password: password);

      if (authResponse.session == null) {
        throw const AppException(Codes.emailNotConfirmed);
      }

      try {
        final userModel = await _syncProfile(authResponse.session!.accessToken);

        // Update full name in the profile
        final url = '$_baseUrl/profile/me';
        await _dio.patch(
          url,
          data: {'full_name': '$firstName $lastName'},
          options: Options(headers: {'Authorization': 'Bearer ${authResponse.session!.accessToken}', 'Content-Type': 'application/json'}),
        );

        return userModel.copyWith(fullName: '$firstName $lastName');
      } catch (_) {
        await signOut();
        rethrow;
      }
    } on AuthException catch (_) {
      rethrow;
    } on SocketException {
      throw const AppException(Codes.requestTimeout);
    } on TimeoutException {
      throw const AppException(Codes.requestTimeout);
    } catch (e) {
      if (e is AuthException || e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }

  Future<UserModel?> restoreSession() async {
    try {
      final session = _supabaseClient.auth.currentSession;
      if (session == null) return null;

      final userModel = await _syncProfile(session.accessToken);
      return userModel;
    } on AppException catch (e) {
      if (e.code == Codes.reauthenticationNeeded) {
        await signOut();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> _syncProfile(String accessToken) async {
    final url = '$_baseUrl/auth/sync-profile';

    try {
      final response = await _dio.post(url, options: Options(headers: {'Authorization': 'Bearer $accessToken', 'Content-Type': 'application/json'}));

      final decoded = response.data;

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        if (decoded['success'] == true) {
          return UserModel.fromJson(decoded['data']);
        } else {
          signOut();
          throw const AppException(Codes.unexpectedFailure);
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        signOut();
        throw const AppException(Codes.reauthenticationNeeded);
      } else {
        signOut();
        throw const AppException(Codes.unexpectedFailure);
      }
    } on DioException catch (e) {
      signOut();
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.receiveTimeout) {
        throw const AppException(Codes.requestTimeout);
      }
      if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
        signOut();
        throw const AppException(Codes.reauthenticationNeeded);
      }
      signOut();
      throw const AppException(Codes.unexpectedFailure);
    } catch (e) {
      signOut();
      if (e is AppException) rethrow;
      throw const AppException(Codes.unexpectedFailure);
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
