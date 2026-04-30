import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

import 'package:sanad/features/auth/logic/entities/user_entity.dart';

/// Repository for Profile related operations.
class ProfileRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final JobsRemoteDataSource _jobsRemoteDataSource;

  ProfileRepository(this._authRemoteDataSource, this._jobsRemoteDataSource);

  Future<ResponseModel<UserEntity>> getProfile() async {
    try {
      final userModel = await _authRemoteDataSource.getProfile();
      return ResponseModel.success(UserEntity.fromModel(userModel));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }

  Future<ResponseModel<void>> updateProfile(Map<String, dynamic> data) async {
    try {
      await _authRemoteDataSource.updateProfile(data);
      return const ResponseModel.success(null);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }

  /// Performs a sign out operation.
  Future<ResponseModel<void>> logout() async {
    try {
      await _authRemoteDataSource.signOut();
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }

  /// Uploads a CV file and returns the remote URL.
  ///
  /// Description: Validates the local file before delegating to the JobsRemoteDataSource.
  /// Side Effects: Makes a POST request to the backend.
  /// Variables: [cvPath] Local file path.
  Future<ResponseModel<String>> uploadCv(String cvPath) async {
    try {
      final file = File(cvPath);

      // 1. Check if file exists
      if (!(await file.exists())) {
        return const ResponseModel.failure(Codes.fileNotFound);
      }

      // 2. Check for supported extensions
      final extension = path.extension(cvPath).toLowerCase();
      final allowedExtensions = ['.pdf', '.doc', '.docx'];
      if (!allowedExtensions.contains(extension)) {
        return const ResponseModel.failure(Codes.invalidFileType);
      }

      // 3. Attempt to read (check for permissions)
      try {
        await file.openRead(0, 1).first;
      } catch (e) {
        return const ResponseModel.failure(Codes.permissionDenied);
      }

      final url = await _jobsRemoteDataSource.uploadCv(cvPath);
      return ResponseModel.success(url);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
