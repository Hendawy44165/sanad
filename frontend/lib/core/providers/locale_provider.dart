import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/constants/app_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends Notifier<Locale> {
  final SharedPreferences _prefs;

  LocaleNotifier(this._prefs);

  @override
  Locale build() {
    final languageCode = _prefs.getString(AppKeys.locale);

    if (languageCode != null) {
      return Locale(languageCode);
    }
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
    _prefs.setString(AppKeys.locale, locale.languageCode);
  }
}

typedef LocaleProvider = NotifierProvider<LocaleNotifier, Locale>;
