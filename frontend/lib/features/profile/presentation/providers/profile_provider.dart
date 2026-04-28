import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanad/features/profile/logic/repositories/profile_repository.dart';
import 'package:sanad/core/constants/codes.dart';
import 'profile_state.dart';

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

    return ProfileState(
      name: name,
      profilePicturePath: pic,
      userEmail: 'mocked@example.com',
      notificationsEnabled: notifications,
      language: language,
    );
  }

  void updateName(String name) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.username, name);
    state = AsyncValue.data(state.value!.copyWith(name: name));
  }

  void updateProfilePicture(String path) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.profilePicturePath, path);
    state = AsyncValue.data(state.value!.copyWith(profilePicturePath: path));
  }

  void toggleNotifications(bool enabled) {
    if (state.isLoading || state.value == null) return;
    _prefs.setBool(AppKeys.notificationsEnabled, enabled);
    state = AsyncValue.data(
      state.value!.copyWith(notificationsEnabled: enabled),
    );
  }

  void updateLanguage(String language) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(AppKeys.locale, language);
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  Future<void> uploadCv(String cvPath) async {
    // TODO: implement when the DB is ready
    throw UnimplementedError();
  }

  Future<void> logout() async {
    final oldState = state.value;
    if (oldState == null) return;

    state = const AsyncLoading();
    final response = await _repository.logout();

    if (response.isSuccess) {
      await _prefs.remove(AppKeys.username);
      await _prefs.remove(AppKeys.profilePicturePath);
      state = AsyncValue.data(oldState); // Auth listener will handle redirection
    } else {
      state = AsyncValue.data(
        oldState.copyWith(error: response.errorCode ?? Codes.unknown),
      );
    }
  }

  void clearError() {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(error: null));
  }
}

typedef ProfileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileState>;
