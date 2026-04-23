import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/features/auth/data/models/user_model.dart';

// TODO: make the private methods and variables at the end of the class so the latter is more readable

class AuthRemoteDataSource {
  final SupabaseClient _supabaseClient;
  // TODO: make this client fed via get it
  final HttpClient? _httpClient;
  final String _baseUrl =
      'http://localhost:4000/api/v1'; // Change this for production

  AuthRemoteDataSource(this._supabaseClient, [this._httpClient]);

  Stream<AuthState> get onAuthStateChange =>
      _supabaseClient.auth.onAuthStateChange;

  Future<UserModel> signInWithPassword(String email, String password) async {
    try {
      final authResponse = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

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

  Future<UserModel> signUp(String email, String password) async {
    try {
      final authResponse = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
      );

      if (authResponse.session == null) {
        // If email confirmation is required, session might be null.
        // For now, assume it returns a session or we can't sync.
        throw const AppException(Codes.emailNotConfirmed);
      }

      try {
        final userModel = await _syncProfile(authResponse.session!.accessToken);
        return userModel;
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
    // TODO: Make this atomic via Supabase Functions instead of a manual HTTP call from the client
    final url = Uri.parse('$_baseUrl/auth/sync-profile');
    final client = _httpClient ?? HttpClient();

    try {
      final request = await client.postUrl(url);
      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $accessToken',
      );
      request.headers.set(HttpHeaders.contentTypeHeader, 'application/json');

      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();
      final decoded = jsonDecode(responseBody);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (decoded['success'] == true) {
          return UserModel.fromJson(decoded['data']);
        } else {
          throw const AppException(Codes.unexpectedFailure);
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw const AppException(Codes.reauthenticationNeeded);
      } else {
        throw const AppException(Codes.unexpectedFailure);
      }
    } on SocketException {
      throw const AppException(Codes.requestTimeout);
    } on TimeoutException {
      throw const AppException(Codes.requestTimeout);
    } on FormatException {
      throw const AppException(Codes.unexpectedFailure);
    } finally {
      client.close();
    }
  }

  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
}
