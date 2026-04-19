import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

/// A Notifier that manages the current locale of the application.
class LocaleNotifier extends Notifier<Locale> {
  static const _localeKey = 'app_locale';

  @override
  Locale build() {
    final prefs = ref.watch(sharedPrefsProvider);
    final languageCode = prefs.getString(_localeKey);
    
    if (languageCode != null) {
      return Locale(languageCode);
    }
    // Default to English
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
    ref.read(sharedPrefsProvider).setString(_localeKey, locale.languageCode);
  }
}

/// Provider that manages the current locale of the application.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
