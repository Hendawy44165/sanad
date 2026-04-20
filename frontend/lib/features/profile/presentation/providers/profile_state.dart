class ProfileState {
  final String name;
  final String? profilePicturePath;
  final String userEmail;
  final bool notificationsEnabled;
  final String language;
  final bool cvUploaded;

  ProfileState({
    required this.name,
    this.profilePicturePath,
    required this.userEmail,
    required this.notificationsEnabled,
    required this.language,
    this.cvUploaded = false,
  });

  ProfileState copyWith({
    String? name,
    String? profilePicturePath,
    String? userEmail,
    bool? notificationsEnabled,
    String? language,
    bool? isLoading,
    bool? cvUploaded,
  }) {
    return ProfileState(
      name: name ?? this.name,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      userEmail: userEmail ?? this.userEmail,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      language: language ?? this.language,
      cvUploaded: cvUploaded ?? this.cvUploaded,
    );
  }
}
