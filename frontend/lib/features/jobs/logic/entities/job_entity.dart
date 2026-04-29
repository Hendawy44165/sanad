import '../../data/models/job_model.dart';

/// Represents a Job in the business logic layer.
/// This object is clean and decoupled from API-specific field names.
class JobEntity {
  final String id;
  final String title;
  final String company;
  final String? location;
  final String description;
  final JobType type;
  final bool isRemote;
  final String? applyUrl;
  final DateTime postedAt;

  JobEntity({
    required this.id,
    required this.title,
    required this.company,
    this.location,
    required this.description,
    required this.type,
    required this.isRemote,
    this.applyUrl,
    required this.postedAt,
  });

  /// Factory to create a [JobEntity] from a data layer [JobModel].
  /// 
  /// This decouples the data layer from logic requirements while allowing
  /// the logic layer to define its own transformations.
  factory JobEntity.fromModel(JobModel model) {
    return JobEntity(
      id: model.id,
      title: model.title,
      company: model.company,
      location: model.location,
      description: model.description,
      type: _mapEmploymentType(model.employmentType),
      isRemote: model.isRemote,
      applyUrl: model.sourceUrl,
      postedAt: model.publishedAt ?? model.createdAt,
    );
  }

  /// Maps backend string enums to logic layer JobType enums.
  static JobType _mapEmploymentType(String? type) {
    switch (type) {
      case 'full_time':
        return JobType.fullTime;
      case 'part_time':
        return JobType.partTime;
      case 'contract':
        return JobType.contract;
      case 'internship':
        return JobType.internship;
      case 'temporary':
        return JobType.temporary;
      default:
        return JobType.fullTime;
    }
  }
}

/// Enum for employment types used across the app.
enum JobType {
  fullTime,
  partTime,
  contract,
  internship,
  temporary,
}
