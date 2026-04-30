import 'doctor_entity.dart';

/// Thin wrapper for paginated doctors list.
class DoctorsListEntity {
  final List<DoctorEntity> doctors;
  final int totalCount;
  final bool hasNextPage;

  DoctorsListEntity({
    required this.doctors,
    required this.totalCount,
    required this.hasNextPage,
  });
}
