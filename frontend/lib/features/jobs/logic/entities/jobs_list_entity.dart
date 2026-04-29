import 'job_entity.dart';

/// Represents a paginated list of jobs in the business logic layer.
class JobsListEntity {
  /// The list of job entities for the current request.
  final List<JobEntity> jobs;
  
  /// Whether there are more jobs to fetch from the server.
  final bool hasNext;

  JobsListEntity({required this.jobs, required this.hasNext});
}
