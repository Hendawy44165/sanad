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
    final response = await _repository.getProfile();
    
    if (response.isSuccess) {
      final user = response.data!;
      return ProfileState(
        name: user.fullName ?? 'UNKNOWN',
        userEmail: user.email,
        notificationsEnabled: user.notificationsEnabled,
        language: user.language,
        cvUploaded: user.id.isNotEmpty, // Adjust logic if needed
        cvPath: null, // Fetched from UserCv separately if needed
      );
    } else {
      // Fallback to cached data if offline/error
      final name = _prefs.getString(AppKeys.username) ?? 'UNKNOWN';
      final notifications = _prefs.getBool(AppKeys.notificationsEnabled) ?? true;
      final language = _prefs.getString(AppKeys.locale) ?? 'en';

      return ProfileState(
        name: name,
        userEmail: '---',
        notificationsEnabled: notifications,
        language: language,
        error: response.errorCode,
      );
    }
  }

  /// Updates the user's display name.
  Future<void> updateName(String name) async {
    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.updateProfile({'full_name': name});

    if (response.isSuccess) {
      _prefs.setString(AppKeys.username, name);
      state = AsyncValue.data(oldState.copyWith(name: name));
    } else {
      state = AsyncValue.data(oldState.copyWith(error: response.errorCode));
    }
  }

  /// Updates the profile picture path.
  void updateProfilePicture(String path) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.profilePicturePath, path);
    state = AsyncValue.data(state.value!.copyWith(profilePicturePath: path));
  }

  /// Toggles global notification settings.
  Future<void> toggleNotifications(bool enabled) async {
    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.updateProfile({'notifications_enabled': enabled});

    if (response.isSuccess) {
      _prefs.setBool(AppKeys.notificationsEnabled, enabled);
      state = AsyncValue.data(oldState.copyWith(notificationsEnabled: enabled));
    } else {
      state = AsyncValue.data(oldState.copyWith(error: response.errorCode));
    }
  }

  /// Updates the application language.
  void updateLanguage(String language) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.locale, language);
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  /// Handles CV file upload and persists the remote URL.
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
      state = AsyncValue.data(oldState); 
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
