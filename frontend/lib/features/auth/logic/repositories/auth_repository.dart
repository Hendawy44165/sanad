import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/features/auth/logic/entities/user_entity.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/services/error_handling_service.dart';

/// Repository for authentication operations.
/// 
/// Bridges the AuthRemoteDataSource with the presentation layer by mapping
/// data models to business entities.
class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  /// Stream of authentication state changes from Supabase.
  Stream<AuthState> get onAuthStateChange =>
      _remoteDataSource.onAuthStateChange;

  /// Attempts to restore a previous session.
  /// 
  /// Returns a [UserEntity] if successful, or null if no session exists.
  Future<ResponseModel<UserEntity?>> restoreSession() async {
    try {
      final userModel = await _remoteDataSource.restoreSession();
      if (userModel == null) return const ResponseModel.success(null);
      
      return ResponseModel.success(UserEntity.fromModel(userModel));
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }

  /// Signs in a user with email and password.
  Future<ResponseModel<UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signInWithPassword(
        email,
        password,
      );

      return ResponseModel.success(UserEntity.fromModel(userModel));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } on AuthException catch (e) {
      final errorCode = ErrorHandlingService.getErrorCode(e.message);
      return ResponseModel.failure(errorCode);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }

  /// Signs up a new user and synchronizes their profile.
  Future<ResponseModel<UserEntity>> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final userModel = await _remoteDataSource.signUp(
        email,
        password,
        firstName,
        lastName,
      );

      return ResponseModel.success(UserEntity.fromModel(userModel));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } on AuthException catch (e) {
      final errorCode = ErrorHandlingService.getErrorCode(e.message);
      return ResponseModel.failure(errorCode);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }

  /// Signs out the current user.
  Future<ResponseModel<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }
}
