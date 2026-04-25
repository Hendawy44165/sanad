import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:sanad/core/providers/locale_provider.dart';
import 'package:sanad/core/router/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env["SUPABASE_URL"]!,
    anonKey: dotenv.env["SUPABASE_ANON_KEY"]!,
  );

  await configureDependencies();

  runApp(ProviderScope(child: const SanadApp()));
}

class SanadApp extends ConsumerWidget {
  const SanadApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: remove the user of go router, use the normal navigation instead
    final router = ref.watch(routerProvider);
    final locale = ref.watch(getIt<LocaleProvider>());

    return MaterialApp.router(
      title: 'Sanad',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: locale,
      theme: AppTheme.lightTheme,
    );
  }
}
