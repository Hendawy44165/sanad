import 'package:sanad/core/constants/disabilities.dart';
import 'package:sanad/features/auth/logic/entities/user_entity.dart';

// TODO: this needs fixing to align with the database

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.supabaseUserId,
    required super.email,
    super.fullName,
    super.phone,
    super.avatarUrl,
    super.disabilityType,
    required super.language,
    required super.notificationsEnabled,
    required super.role,
    required super.profileCompletion,
    required super.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? '',
      supabaseUserId: json['supabase_user_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      disabilityType: json['disability_type'] as DisabilityType?,
      language: json['language'] as String? ?? 'ar',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      role: json['role'] as String? ?? 'user',
      profileCompletion: json['profile_completion'] as int? ?? 10,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'supabase_user_id': supabaseUserId,
      'email': email,
      'full_name': fullName,
      'phone': phone,
      'avatar_url': avatarUrl,
      'disability_type': disabilityType,
      'language': language,
      'notifications_enabled': notificationsEnabled,
      'role': role,
      'profile_completion': profileCompletion,
      'is_active': isActive,
    };
  }
}
