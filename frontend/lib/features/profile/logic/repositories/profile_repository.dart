import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/constants/codes.dart';

class ProfileRepository {
  final AuthRemoteDataSource _authRemoteDataSource;

  ProfileRepository(this._authRemoteDataSource);

  Future<ResponseModel<void>> logout() async {
    try {
      await _authRemoteDataSource.signOut();
      return const ResponseModel.success(null);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }
}
