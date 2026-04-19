import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sanad/l10n/app_localizations.dart';
import 'package:sanad/features/jobs/presentation/screens/jobs_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en'), Locale('ar')],
        home: JobsScreen(),
      ),
    );
  }

  group('JobsScreen Widget Tests', () {
    testWidgets('renders Find Jobs title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Find Jobs'), findsOneWidget);
    });

    testWidgets('renders search field with correct hint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Search jobs...'), findsOneWidget);
    });

    testWidgets('renders upload CV banner', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Upload Your CV'), findsOneWidget);
      expect(find.text('Upload CV'), findsOneWidget);
    });

    testWidgets('renders job filters', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('All Jobs'), findsOneWidget);
      expect(find.text('Remote'), findsAtLeastNWidgets(1));
      expect(find.text('Full-Time'), findsAtLeastNWidgets(1));
      expect(find.text('Hybrid'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders available jobs count', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('5 Available Jobs'), findsOneWidget);
    });

    testWidgets('renders job cards with titles and companies', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Senior UX Researcher'), findsOneWidget);
      expect(find.text('TechFlow Innovations'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Remote Data Analyst'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Accessibility Specialist'), findsOneWidget);
      expect(find.text('Global Health Corp'), findsOneWidget);

      expect(find.text('Remote Data Analyst'), findsOneWidget);
      expect(find.text('DataMind Labs'), findsOneWidget);
    });

    testWidgets('renders Verified badge on job cards', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Verified').last,
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Verified'), findsAtLeastNWidgets(3));
    });

    testWidgets('renders Apply Now buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Apply Now').last,
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Apply Now'), findsAtLeastNWidgets(3));
    });
  });

  group('JobsScreen Directionality Tests', () {
    testWidgets('upload banner layout flips in RTL mode', (
      WidgetTester tester,
    ) async {
      double getX(Finder finder) => tester.getCenter(finder).dx;

      // 1. Test LTR
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            locale: Locale('en'),
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: JobsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconLtr = find.byIcon(LucideIcons.fileText);
      final titleLtr = find.text('Upload Your CV').first;

      expect(getX(iconLtr) < getX(titleLtr), isTrue);

      // 2. Test RTL
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [Locale('en'), Locale('ar')],
            locale: Locale('ar'),
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: JobsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final iconRtl = find.byIcon(LucideIcons.fileText);
      final titleRtl = find.text('ارفع سيرتك الذاتية').first;

      expect(getX(iconRtl) > getX(titleRtl), isTrue);
    });
  });
}
