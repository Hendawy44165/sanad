// TODO: make this align with the database

class UserEntity {
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
}
