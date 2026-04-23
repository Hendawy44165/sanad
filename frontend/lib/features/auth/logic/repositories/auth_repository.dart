import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/features/auth/logic/entities/user_entity.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/services/error_handling_service.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepository(this._remoteDataSource);

  Stream<AuthState> get onAuthStateChange =>
      _remoteDataSource.onAuthStateChange;

  Future<ResponseModel<UserEntity?>> restoreSession() async {
    try {
      final userModel = await _remoteDataSource.restoreSession();
      if (userModel == null)
        // TODO: make the messages here localized
        return ResponseModel.failure(Codes.userNotFound, 'No user found');
      return ResponseModel.success(userModel);
    } catch (e) {
      return ResponseModel.failure(
        Codes.unknown,
        'An unexpected error occurred during session restore: $e',
      );
    }
  }

  Future<ResponseModel<UserEntity>> signIn(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signInWithPassword(
        email,
        password,
      );

      return ResponseModel.success(userModel);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code, e.message);
    } on AuthException catch (e) {
      final errorCode = ErrorHandlingService.getErrorCode(e.message);
      return ResponseModel.failure(errorCode, e.message);
    } catch (e) {
      return ResponseModel.failure(
        Codes.unknown,
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<ResponseModel<UserEntity>> signUp(
    String email,
    String password,
  ) async {
    try {
      final userModel = await _remoteDataSource.signUp(email, password);

      return ResponseModel.success(userModel);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code, e.message);
    } on AuthException catch (e) {
      final errorCode = ErrorHandlingService.getErrorCode(e.message);
      return ResponseModel.failure(errorCode, e.message);
    } catch (e) {
      return ResponseModel.failure(
        Codes.unknown,
        'An unexpected error occurred: $e',
      );
    }
  }

  Future<ResponseModel<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(
        Codes.unknown,
        'An unexpected error occurred: $e',
      );
    }
  }
}
