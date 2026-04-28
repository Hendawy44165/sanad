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

  UserModel copyWith({
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
    return UserModel(
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
