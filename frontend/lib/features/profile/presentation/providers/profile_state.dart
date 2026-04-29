import 'package:sanad/core/constants/codes.dart';

/// Represents the UI state for the User Profile.
class ProfileState {
  final String name;
  final String? profilePicturePath;
  final String userEmail;
  final bool notificationsEnabled;
  final String language;
  final bool cvUploaded;
  final String? cvPath;
  final Codes? error;

  ProfileState({
    required this.name,
    this.profilePicturePath,
    required this.userEmail,
    required this.notificationsEnabled,
    required this.language,
    this.cvUploaded = false,
    this.cvPath,
    this.error,
  });

  /// Returns a copy of the state with updated fields.
  ProfileState copyWith({
    String? name,
    String? profilePicturePath,
    String? userEmail,
    bool? notificationsEnabled,
    String? language,
    bool? cvUploaded,
    String? cvPath,
    Codes? error,
  }) {
    return ProfileState(
      name: name ?? this.name,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      userEmail: userEmail ?? this.userEmail,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      cvUploaded: cvUploaded ?? this.cvUploaded,
      cvPath: cvPath ?? this.cvPath,
      error: error,
    );
  }
}
