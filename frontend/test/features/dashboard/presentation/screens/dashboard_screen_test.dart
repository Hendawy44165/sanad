import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/dashboard/presentation/screens/dashboard_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: DashboardScreen()));
  }

  group('DashboardScreen Widget Tests', () {
    testWidgets('renders Dashboard title and Sanad app name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Sanad'), findsOneWidget);
      expect(
        find.text('Your accessible resources and benefits.'),
        findsOneWidget,
      );
    });

    testWidgets('renders all Quick Action cards', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Quick Actions'), findsOneWidget);
      expect(find.text('Find Jobs'), findsOneWidget);
      expect(find.text('Find a Doctor'), findsOneWidget);
      expect(find.text('Request a Book'), findsOneWidget);
      expect(
        find.text('Sign Language'),
        findsAtLeastNWidgets(1),
      ); // Also in banner
    });

    testWidgets('renders Opportunities section with specific jobs', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Opportunities'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Opportunities'), findsOneWidget);
      expect(find.text('Senior UX Researcher'), findsOneWidget);
      expect(find.text('Accessibility Specialist'), findsOneWidget);
      expect(find.text('VIEW ALL JOBS'), findsOneWidget);
    });

    testWidgets('renders Medical Network section with doctors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Medical Network'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Medical Network'), findsOneWidget);
      expect(find.text('Dr. Layla Khaled'), findsOneWidget);
      expect(find.text('Dr. Omar Nasser'), findsOneWidget);
      expect(find.text('FIND CARE'), findsOneWidget);
    });

    testWidgets('renders Learn & Grow section with books', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Learn & Grow'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Learn & Grow'), findsOneWidget);
      expect(find.text('The Art of Possibility'), findsOneWidget);
      expect(find.text('Disability Visibility'), findsOneWidget);
      expect(find.text('BROWSE BOOKS'), findsOneWidget);
    });

    testWidgets('renders Sign Language banner and can scroll to it', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('TRANSLATE NOW'),
        500.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Tap the button and sign your message'), findsOneWidget);
      expect(find.text('TRANSLATE NOW'), findsOneWidget);
    });

    testWidgets('bottom navigation bar has correct items and interaction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Translator'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // Tap Translator
      await tester.tap(find.text('Translator'));
      await tester.pump();
    });

    testWidgets('buttons are present and respond to taps', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // Scroll to a specific job title first to bring its button into view
      await tester.scrollUntilVisible(
        find.text('Senior UX Researcher'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Now the button for this card should be visible
      final viewDetailsButton = find.text('View Details').first;
      expect(viewDetailsButton, findsOneWidget);
      await tester.tap(viewDetailsButton);
      await tester.pump();

      // Scroll to a specific doctor name first to bring their button into view
      await tester.scrollUntilVisible(
        find.text('Dr. Layla Khaled'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      // Now the button for this card should be visible
      final bookButton = find.text('Book').first;
      expect(bookButton, findsOneWidget);
      await tester.tap(bookButton);
      await tester.pump();
    });
  });
}
