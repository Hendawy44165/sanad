import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

class SettingsState {
  final bool notificationsEnabled;

  SettingsState({required this.notificationsEnabled});

  SettingsState copyWith({bool? notificationsEnabled}) {
    return SettingsState(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

class SettingsNotifier extends Notifier<SettingsState> {
  static const _notificationsKey = 'notifications_enabled';

  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final enabled = prefs.getBool(_notificationsKey) ?? true;
    return SettingsState(notificationsEnabled: enabled);
  }

  void toggleNotifications(bool enabled) {
    state = state.copyWith(notificationsEnabled: enabled);
    ref.read(sharedPrefsProvider).setBool(_notificationsKey, enabled);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});
