/// Represents a medical specialist or doctor in the Sanad application.
class Doctor {
  /// Unique identifier for the doctor.
  final String id;

  /// Full name of the doctor.
  final String name;

  /// Medical specialty (e.g., Cardiologist, Pediatrician).
  final String? specialty;

  /// Hospital or clinic affiliation.
  final String? hospital;

  /// Average rating based on user reviews.
  final double rating;

  /// Total number of reviews received.
  final int reviewsCount;

  /// Indicates if the doctor is currently available for appointments/chat.
  final bool isAvailable;

  /// List of languages spoken by the doctor.
  final List<String> languages;

  /// URL to the doctor's profile image.
  final String? imageUrl;

  /// Email address for contacting the doctor.
  final String? contactEmail;

  /// Creates a [Doctor] instance.
  Doctor({
    required this.id,
    required this.name,
    this.specialty,
    this.hospital,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailable,
    this.languages = const [],
    this.imageUrl,
    this.contactEmail,
  });

  /// Creates a [Doctor] instance from a JSON map.
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      specialty: json['specialty'],
      hospital: json['hospital'],
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'],
      isAvailable: json['is_available'],
      languages: List<String>.from(json['languages'] ?? []),
      imageUrl: json['image_url'],
      contactEmail: json['contact_email'],
    );
  }
}
