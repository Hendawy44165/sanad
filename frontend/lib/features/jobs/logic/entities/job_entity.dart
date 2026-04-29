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
}

/// Enum for employment types used across the app.
enum JobType {
  fullTime,
  partTime,
  contract,
  internship,
  temporary,
}
