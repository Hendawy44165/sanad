import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProfile {
  final String name;
  final String? profilePicturePath;

  UserProfile({required this.name, this.profilePicturePath});

  UserProfile copyWith({String? name, String? profilePicturePath}) {
    return UserProfile(
      name: name ?? this.name,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
    );
  }
}

class UserProfileNotifier extends Notifier<UserProfile> {
  @override
  UserProfile build() {
    return UserProfile(name: 'Ahmed Al-Rashidi');
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateProfilePicture(String? path) {
    state = state.copyWith(profilePicturePath: path);
  }
}

final userProfileProvider = NotifierProvider<UserProfileNotifier, UserProfile>(
  () {
    return UserProfileNotifier();
  },
);
