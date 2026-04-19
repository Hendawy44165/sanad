import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A Notifier that manages the current locale of the application.
class LocaleNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    // Default to English
    return const Locale('en');
  }

  void setLocale(Locale locale) {
    state = locale;
  }
}

/// Provider that manages the current locale of the application.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(() {
  return LocaleNotifier();
});
