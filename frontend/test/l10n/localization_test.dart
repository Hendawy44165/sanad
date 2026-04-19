import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:sanad/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  Widget createLocalizedWidget(Locale locale) {
    return ProviderScope(
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('ar')],
        locale: locale,
        home: const DashboardScreen(),
      ),
    );
  }

  group('Localization Tests', () {
    testWidgets('Dashboard renders in English by default', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLocalizedWidget(const Locale('en')));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Sanad'), findsOneWidget);
    });

    testWidgets('Dashboard renders in Arabic when locale is ar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLocalizedWidget(const Locale('ar')));
      await tester.pumpAndSettle();

      expect(find.text('لوحة التحكم'), findsOneWidget);
      expect(find.text('سند'), findsOneWidget);
      expect(find.text('الرئيسية'), findsOneWidget);
    });

    testWidgets('Directionality is RTL for Arabic locale', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createLocalizedWidget(const Locale('ar')));
      await tester.pumpAndSettle();

      final Directionality directionality = tester.widget(
        find.byType(Directionality).last,
      );
      expect(directionality.textDirection, TextDirection.rtl);
    });
  });
}
