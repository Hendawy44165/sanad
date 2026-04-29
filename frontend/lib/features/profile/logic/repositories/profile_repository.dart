import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/features/jobs/data/datasources/jobs_remote_data_source.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

/// Repository for Profile related operations.
class ProfileRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final JobsRemoteDataSource _jobsRemoteDataSource;

  ProfileRepository(this._authRemoteDataSource, this._jobsRemoteDataSource);

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
  /// Description: Delegates to the JobsRemoteDataSource for the actual network call.
  /// Side Effects: Makes a POST request to the backend.
  /// Variables: [cvPath] Local file path.
  Future<ResponseModel<String>> uploadCv(String cvPath) async {
    try {
      final url = await _jobsRemoteDataSource.uploadCv(cvPath);
      return ResponseModel.success(url);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
