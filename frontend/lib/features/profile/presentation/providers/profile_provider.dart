import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanad/features/profile/logic/repositories/profile_repository.dart';
import 'package:sanad/core/constants/codes.dart';
import 'profile_state.dart';

/// Notifier for managing the User Profile state.
/// 
/// Handles name updates, language settings, notification toggles, and CV uploads.
class ProfileNotifier extends AsyncNotifier<ProfileState> {
  final ProfileRepository _repository;
  final SharedPreferences _prefs;

  ProfileNotifier(this._repository, this._prefs);

  @override
  Future<ProfileState> build() async {
    final name = _prefs.getString(AppKeys.username) ?? 'UNKNOWN';
    final pic = _prefs.getString(AppKeys.profilePicturePath);
    final notifications = _prefs.getBool(AppKeys.notificationsEnabled) ?? true;
    final language = _prefs.getString(AppKeys.locale) ?? 'en';
    final cvPath = _prefs.getString(AppKeys.cvPath);

    return ProfileState(
      name: name,
      profilePicturePath: pic,
      userEmail: 'mocked@example.com',
      notificationsEnabled: notifications,
      language: language,
      cvPath: cvPath,
      cvUploaded: cvPath != null,
    );
  }

  /// Updates the user's display name.
  void updateName(String name) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.username, name);
    state = AsyncValue.data(state.value!.copyWith(name: name));
  }

  /// Updates the profile picture path.
  void updateProfilePicture(String path) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.profilePicturePath, path);
    state = AsyncValue.data(state.value!.copyWith(profilePicturePath: path));
  }

  /// Toggles global notification settings.
  void toggleNotifications(bool enabled) {
    if (state.isLoading || state.value == null) return;
    _prefs.setBool(AppKeys.notificationsEnabled, enabled);
    state = AsyncValue.data(
      state.value!.copyWith(notificationsEnabled: enabled),
    );
  }

  /// Updates the application language.
  void updateLanguage(String language) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.locale, language);
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  /// Handles CV file upload and persists the remote URL.
  /// 
  /// Description: Uploads the file at [cvPath] to the backend and saves the URL locally.
  /// Side Effects: Triggers network I/O and updates local preferences.
  /// Variables: [cvPath] Local path to the CV file.
  Future<void> uploadCv(String cvPath) async {
    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.uploadCv(cvPath);

    if (response.isSuccess && response.data != null) {
      final remoteUrl = response.data!;
      await _prefs.setString(AppKeys.cvPath, remoteUrl);
      state = AsyncValue.data(oldState.copyWith(
        cvPath: remoteUrl,
        cvUploaded: true,
      ));
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unexpectedFailure),
      );
    }
  }

  /// Logs out the user and clears sensitive profile data.
  Future<void> logout() async {
    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.logout();

    if (response.isSuccess) {
      await _prefs.remove(AppKeys.username);
      await _prefs.remove(AppKeys.profilePicturePath);
      await _prefs.remove(AppKeys.cvPath);
      state = AsyncValue.data(oldState); // Auth listener will handle redirection
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unknown),
      );
    }
  }

  /// Clears any active error codes.
  void clearError() {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

/// Provider instance for the User Profile.
typedef ProfileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileState>;
