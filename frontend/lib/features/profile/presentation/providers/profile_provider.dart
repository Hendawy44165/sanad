import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/app_keys.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sanad/features/profile/logic/repositories/profile_repository.dart';
import 'profile_state.dart';

class ProfileNotifier extends AsyncNotifier<ProfileState> {
  @override
  Future<ProfileState> build() async {
    final prefs = getIt<SharedPreferences>();
    final name = prefs.getString(AppKeys.username) ?? 'UNKOWN';
    final pic = prefs.getString(AppKeys.profilePicturePath);
    final notifications = prefs.getBool(AppKeys.notificationsEnabled) ?? true;
    final language = prefs.getString(AppKeys.locale) ?? 'en';

    return ProfileState(
      name: name,
      profilePicturePath: pic,
      userEmail: 'mocked@example.com',
      notificationsEnabled: notifications,
      language: language,
    );
  }

  void updateName(String name) {
    if (state.isLoading) return;
    state = AsyncLoading();
    final prefs = getIt<SharedPreferences>();
    if (state.value == null) return;
    prefs.setString(AppKeys.username, name);
    state = AsyncValue.data(state.value!.copyWith(name: name));
  }

  void updateProfilePicture(String path) {
    if (state.isLoading || state.value == null) return;
    state = AsyncLoading();
    final prefs = getIt<SharedPreferences>();
    prefs.setString(AppKeys.profilePicturePath, path);
    state = AsyncValue.data(state.value!.copyWith(profilePicturePath: path));
  }

  void toggleNotifications(bool enabled) {
    if (state.isLoading || state.value == null) return;
    state = AsyncLoading();
    final prefs = getIt<SharedPreferences>();
    prefs.setBool(AppKeys.notificationsEnabled, enabled);
    state = AsyncValue.data(
      state.value!.copyWith(notificationsEnabled: enabled),
    );
  }

  void updateLanguage(String language) {
    if (state.isLoading || state.value == null) return;
    state = AsyncLoading();
    final prefs = getIt<SharedPreferences>();
    prefs.setString(AppKeys.locale, language);
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  Future<void> uploadCv(String cvPath) async {
    // TODO: implement when the DB is ready
    throw UnimplementedError();
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    final repository = getIt<ProfileRepository>();
    final response = await repository.logout();

    if (response.isSuccess) {
      final prefs = getIt<SharedPreferences>();
      await prefs.remove(AppKeys.username);
      await prefs.remove(AppKeys.profilePicturePath);
      // Note: Navigation to login is typically handled by the Auth listener in the app root
    } else {
      state = AsyncError(response.error ?? 'Logout failed', StackTrace.current);
    }
  }
}

typedef ProfileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileState>;
