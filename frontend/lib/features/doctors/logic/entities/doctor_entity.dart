import '../../data/models/doctor_model.dart';

/// Represents a Doctor in the business logic layer.
class DoctorEntity {
  final String id;
  final String name;
  final String specialty;
  final String? description;
  final double rating;
  final int ratingCount;
  final String? city;
  final String? address;
  final String? contactPhone;
  final String? contactEmail;
  final String? imageUrl;
  final bool isActive;

  DoctorEntity({
    required this.id,
    required this.name,
    required this.specialty,
    this.description,
    required this.rating,
    required this.ratingCount,
    this.city,
    this.address,
    this.contactPhone,
    this.contactEmail,
    this.imageUrl,
    required this.isActive,
  });

  /// Factory to create a [DoctorEntity] from a data layer [DoctorModel].
  factory DoctorEntity.fromModel(DoctorModel model) {
    return DoctorEntity(
      id: model.id,
      name: model.name,
      specialty: model.specialty,
      description: model.description,
      rating: model.rating.toDouble(),
      ratingCount: model.ratingCount,
      city: model.city,
      address: model.address,
      contactPhone: model.contactPhone,
      contactEmail: model.contactEmail,
      imageUrl: model.imageUrl,
      isActive: model.isActive,
    );
  }
}
