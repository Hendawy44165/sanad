/// Data model representing the user in the data layer.
/// This class is strictly decoupled from the logic layer and mirrors the backend schema.
class UserModel {
  final String id;
  final String supabaseUserId;
  final String email;
  final String? fullName;
  final String? phone;
  final String? avatarUrl;
  final String? disabilityType;
  final String language;
  final bool notificationsEnabled;
  final String role;
  final int profileCompletion;
  final bool isActive;

  const UserModel({
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

  /// Factory to create a [UserModel] from backend JSON.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] as String? ?? '',
      supabaseUserId: json['supabase_user_id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['full_name'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      disabilityType: json['disability_type'] as String?,
      language: json['language'] as String? ?? 'ar',
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      role: json['role'] as String? ?? 'user',
      profileCompletion: json['profile_completion'] as int? ?? 10,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  /// Converts the model back to JSON for API requests.
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

  /// Returns a copy of the model with updated fields.
  UserModel copyWith({
    String? id,
    String? supabaseUserId,
    String? email,
    String? fullName,
    String? phone,
    String? avatarUrl,
    String? disabilityType,
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
