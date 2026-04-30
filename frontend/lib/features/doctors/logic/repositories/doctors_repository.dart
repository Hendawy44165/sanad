import 'package:sanad/features/doctors/data/datasources/doctors_remote_data_source.dart';
import 'package:sanad/features/doctors/logic/entities/doctor_entity.dart';
import 'package:sanad/features/doctors/logic/entities/doctors_list_entity.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

/// Repository for the Doctors feature.
/// Translates data-layer models into domain-layer entities.
class DoctorsRepository {
  final DoctorsRemoteDataSource _remoteDataSource;

  DoctorsRepository(this._remoteDataSource);

  /// Fetches doctors and maps the response to [DoctorsListEntity].
  Future<ResponseModel<DoctorsListEntity>> getDoctors({String? query, String? specialty, int page = 1, int limit = 20}) async {
    try {
      final response = await _remoteDataSource.getDoctors(query: query, specialty: specialty, page: page, limit: limit);

      final entities = response.doctors.map((m) => DoctorEntity.fromModel(m)).toList();
      return ResponseModel.success(DoctorsListEntity(doctors: entities, totalCount: response.total, hasNextPage: response.hasNext));
    } on AppException catch (e) {
      return ResponseModel.failure(e.code);
    } catch (e) {
      return const ResponseModel.failure(Codes.unknown);
    }
  }
}
