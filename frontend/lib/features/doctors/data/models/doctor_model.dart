/// Data model for Doctors as received from the API.
class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String? description;
  final num rating;
  final int ratingCount;
  final String? city;
  final String? address;
  final String? contactPhone;
  final String? contactEmail;
  final String? imageUrl;
  final bool isActive;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    this.description,
    this.rating = 0,
    this.ratingCount = 0,
    this.city,
    this.address,
    this.contactPhone,
    this.contactEmail,
    this.imageUrl,
    this.isActive = true,
  });

  /// Factory to create a [DoctorModel] from JSON data.
  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    final location = json['location'] as Map<String, dynamic>?;
    
    return DoctorModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      description: json['description'] as String?,
      rating: json['rating'] as num? ?? 0,
      ratingCount: json['rating_count'] as int? ?? 0,
      city: location?['city'] as String?,
      address: location?['address'] as String?,
      contactPhone: json['contact_phone'] as String?,
      contactEmail: json['contact_email'] as String?,
      imageUrl: json['image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Response wrapper for doctor list API calls.
class DoctorsResponse {
  final List<DoctorModel> doctors;
  final int total;
  final bool hasNext;

  DoctorsResponse({
    required this.doctors,
    required this.total,
    required this.hasNext,
  });

  /// Creates a [DoctorsResponse] from the API's standard success response.
  factory DoctorsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as List? ?? [];
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    
    return DoctorsResponse(
      doctors: data.map((d) => DoctorModel.fromJson(d as Map<String, dynamic>)).toList(),
      total: meta['total'] as int? ?? 0,
      hasNext: meta['has_next'] as bool? ?? false,
    );
  }
}
