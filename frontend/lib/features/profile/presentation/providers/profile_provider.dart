import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/providers/shared_prefs_provider.dart';
import 'profile_state.dart';

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileState>> {
  final SharedPreferences _prefs;

  ProfileNotifier(this._prefs) : super(const AsyncValue.loading()) {
    _init();
  }

  // TODO: move to enum in the pref service in the core
  static const _notificationsKey = 'notifications_enabled';
  static const _localeKey = 'app_locale';
  static const _nameKey = 'user_name';
  static const _profilePicKey = 'profile_picture_path';

  void _init() {
    final name = _prefs.getString(_nameKey) ?? 'UNKOWN';
    final pic = _prefs.getString(_profilePicKey);
    final notifications = _prefs.getBool(_notificationsKey) ?? true;
    final language = _prefs.getString(_localeKey) ?? 'en';

    state = AsyncValue.data(
      ProfileState(
        name: name,
        profilePicturePath: pic,
        userEmail: 'mocked@example.com',
        notificationsEnabled: notifications,
        language: language,
      ),
    );
  }

  void updateName(String name) {
    final current = state.value;
    if (current != null) {
      _prefs.setString(_nameKey, name);
      state = AsyncValue.data(current.copyWith(name: name));
    }
  }

  void updateProfilePicture(String path) {
    if (state.isLoading || state.value == null) return;
    state = AsyncLoading();
    _prefs.setString(_profilePicKey, path);
    state = AsyncValue.data(state.value!.copyWith(profilePicturePath: path));
  }

  void toggleNotifications(bool enabled) {
    if (state.value == null) return;
    _prefs.setBool(_notificationsKey, enabled);
    state = AsyncValue.data(
      state.value!.copyWith(notificationsEnabled: enabled),
    );
  }

  void updateLanguage(String language) {
    if (state.isLoading || state.value == null) return;
    _prefs.setString(_localeKey, language);
    state = AsyncValue.data(state.value!.copyWith(language: language));
  }

  Future<void> uploadCv(String cvPath) async {
    // TODO: implement when the DB is ready
    throw UnimplementedError();
  }

  Future<void> logout() async {
    // TODO: add when the auth system is implemented
    throw UnimplementedError();
  }
}

StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileState>>
getProfileProvider(SharedPreferences sharedPrefsProvider) =>
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileState>>((ref) {
      // TODO: update to use get it
      return ProfileNotifier(sharedPrefsProvider);
    });

final profileProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileState>>((ref) {
      final prefs = ref.watch(sharedPrefsProvider);
      return ProfileNotifier(prefs);
    });
