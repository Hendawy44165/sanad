import 'package:sanad/core/constants/disabilities.dart';
import '../../data/models/user_model.dart';

/// Represents a User in the business logic layer.
/// Decoupled from API-specific field types and names.
class UserEntity {
  final String id;
  final String supabaseUserId;
  final String email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final DisabilityType? disabilityType;
  final String language;
  final bool notificationsEnabled;
  final String role;
  final int profileCompletion;
  final bool isActive;

  const UserEntity({
    required this.id,
    required this.supabaseUserId,
    required this.email,
    this.fullName,
    this.phone,
    this.avatarUrl,
    this.disabilityType,
    required this.language,
    required this.notificationsEnabled,
    required this.role,
    required this.profileCompletion,
    required this.isActive,
  });

  /// Factory to create a [UserEntity] from a data layer [UserModel].
  /// 
  /// This handles the mapping of raw strings (e.g., 'visual') to logic-layer enums.
  factory UserEntity.fromModel(UserModel model) {
    return UserEntity(
      id: model.id,
      supabaseUserId: model.supabaseUserId,
      email: model.email,
      fullName: model.fullName,
      phone: model.phone,
      avatarUrl: model.avatarUrl,
      disabilityType: _mapDisabilityType(model.disabilityType),
      language: model.language,
      notificationsEnabled: model.notificationsEnabled,
      role: model.role,
      profileCompletion: model.profileCompletion,
      isActive: model.isActive,
    );
  }

  /// Maps backend string values to the DisabilityType enum.
  static DisabilityType? _mapDisabilityType(String? type) {
    if (type == null) return null;
    
    switch (type.toLowerCase()) {
      case 'visual':
        return DisabilityType.visual;
      case 'hearing':
        return DisabilityType.hearing;
      case 'mobility':
        return DisabilityType.mobility;
      case 'cognitive':
        return DisabilityType.cognitive;
      case 'chronic':
        return DisabilityType.chronic;
      default:
        return null;
    }
  }

  /// Returns a copy of the entity with updated fields.
  UserEntity copyWith({
    String? id,
    String? supabaseUserId,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    DisabilityType? disabilityType,
    String? language,
    bool? notificationsEnabled,
    String? role,
    int? profileCompletion,
    bool? isActive,
  }) {
    return UserEntity(
      id: id ?? this.id,
      supabaseUserId: supabaseUserId ?? this.supabaseUserId,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      disabilityType: disabilityType ?? this.disabilityType,
      language: language ?? this.language,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      role: role ?? this.role,
      profileCompletion: profileCompletion ?? this.profileCompletion,
      isActive: isActive ?? this.isActive,
    );
  }
}
