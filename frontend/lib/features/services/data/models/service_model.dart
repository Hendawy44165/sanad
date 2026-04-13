/// Represents a service offered within the app (e.g., Caregiver, Transport).
class ServiceModel {
  /// Unique identifier for the service.
  final String id;

  /// Title of the service.
  final String title;

  /// Description of what the service entails.
  final String? description;

  /// Name of the service provider.
  final String provider;

  /// Contact email of the service provider.
  final String? contactEmail;

  /// Category of the service.
  final String category;

  /// Average rating.
  final double rating;

  /// Total number of reviews.
  final int reviewsCount;

  /// Whether the service is currently available.
  final bool isAvailable;

  /// Creates a [ServiceModel] instance.
  ServiceModel({
    required this.id,
    required this.title,
    this.description,
    required this.provider,
    this.contactEmail,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.isAvailable,
  });

  /// Creates a [ServiceModel] instance from a JSON map.
  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      provider: json['provider'],
      contactEmail: json['contact_email'],
      category: json['category'],
      rating: (json['rating'] as num).toDouble(),
      reviewsCount: json['reviews_count'],
      isAvailable: json['is_available'],
    );
  }

  /// Converts the model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'provider': provider,
      'contact_email': contactEmail,
      'category': category,
      'rating': rating,
      'reviews_count': reviewsCount,
      'is_available': isAvailable,
    };
  }
}
