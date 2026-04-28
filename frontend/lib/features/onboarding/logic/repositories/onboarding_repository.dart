import 'package:sanad/features/onboarding/data/datasources/onboarding_datasource.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

class OnboardingRepository {
  final OnboardingRemoteDataSource _remoteDataSource;

  OnboardingRepository(this._remoteDataSource);

  Future<ResponseModel<void>> updateDisabilityType(String disabilityId) async {
    try {
      await _remoteDataSource.updateProfile({
        'disability_type': disabilityId,
      });
      return const ResponseModel.success(null);
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return ResponseModel.failure(Codes.unknown);
    }
  }
}
