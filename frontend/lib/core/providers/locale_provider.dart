import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/app_keys.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    final prefs = getIt<SharedPreferences>();
    final languageCode = prefs.getString(AppKeys.locale);

    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
    final prefs = getIt<SharedPreferences>();
    prefs.setString(AppKeys.locale, locale.languageCode);
  }
}

typedef LocaleProvider = NotifierProvider<LocaleNotifier, Locale>;
