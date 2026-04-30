/// Data model for Jobs as received from the API.
class JobModel {
  final String id;
  final String title;
  final String company;
  final String? location;
  final String description;
  final String? employmentType;
  final bool isRemote;
  final String? sourceUrl;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final String accessibilityMatch;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    this.location,
    required this.description,
    this.employmentType,
    required this.isRemote,
    this.sourceUrl,
    this.publishedAt,
    required this.createdAt,
    required this.accessibilityMatch,
  });

  /// Factory to create a [JobModel] from JSON data.
  /// Matches the backend schema in backend/src/models/Job.js.
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      company: json['company'] as String,
      location: json['location'] as String?,
      description: json['description'] as String,
      employmentType: json['employment_type'] as String?,
      isRemote: json['is_remote'] as bool? ?? false,
      sourceUrl: json['source_url'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      accessibilityMatch: json['accessibility_match'] as String? ?? 'unknown',
    );
  }
}

/// Response wrapper for job list API calls.
class JobsResponse {
  final List<JobModel> jobs;
  final int total;
  final bool hasNext;

  JobsResponse({
    required this.jobs,
    required this.total,
    required this.hasNext,
  });

  /// Creates a [JobsResponse] from the API's standard success response.
  factory JobsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    
    return JobsResponse(
      jobs: data.map((j) => JobModel.fromJson(j as Map<String, dynamic>)).toList(),
      total: meta['total'] as int? ?? 0,
      hasNext: meta['has_next'] as bool? ?? false,
    );
  }
}
