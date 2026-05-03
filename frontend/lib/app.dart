import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/core/providers/locale_provider.dart';
import 'package:sanad/core/router/router.dart';
import 'package:sanad/core/theme/app_theme.dart';
import 'package:sanad/l10n/app_localizations.dart';

/// The root widget of the Sanad application.
///
/// This widget configures the global theme, routing, and localization
/// for the entire app. It uses Riverpod for state management and
/// GetIt for dependency injection.
class SanadApp extends ConsumerWidget {
  /// Creates a [SanadApp] instance.
  const SanadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(getIt<LocaleProvider>());

    return MaterialApp.router(title: 'Sanad', debugShowCheckedModeBanner: false, routerConfig: router, localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate], supportedLocales: const [Locale('en'), Locale('ar')], locale: locale, theme: AppTheme.lightTheme);
  }
}
