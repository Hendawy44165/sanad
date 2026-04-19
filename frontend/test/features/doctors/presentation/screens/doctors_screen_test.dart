import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/doctors/presentation/screens/doctors_screen.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(
      child: MaterialApp(
        home: DoctorsScreen(),
      ),
    );
  }

  group('DoctorsScreen Widget Tests', () {
    testWidgets('renders Find a Doctor title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Find a Doctor'), findsOneWidget);
    });

    testWidgets('renders search field with correct hint', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Search specialists...'), findsOneWidget);
      expect(find.byIcon(LucideIcons.search), findsOneWidget);
    });

    testWidgets('renders doctor filters', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Neurology'), findsOneWidget);
      expect(find.text('Physical'), findsOneWidget);
      expect(find.text('Occupational'), findsOneWidget);
      expect(find.text('Speech'), findsOneWidget);
    });

    testWidgets('renders doctor cards with names and details', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Dr. Layla Khaled'), findsOneWidget);
      expect(find.text('Neurology Specialist'), findsOneWidget);
      expect(find.text('4.9 (120 reviews)'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Dr. Sarah Ahmed'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Dr. Omar Nasser'), findsOneWidget);
      expect(find.text('Physical Therapy'), findsOneWidget);

      expect(find.text('Dr. Sarah Ahmed'), findsOneWidget);
      expect(find.text('Occupational Therapy'), findsOneWidget);
    });

    testWidgets('renders accessibility badges on doctor cards', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Audio Aids').last,
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Wheelchair Access'), findsAtLeastNWidgets(1));
      expect(find.text('Sign Language'), findsAtLeastNWidgets(1));
      expect(find.text('Audio Aids'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders Book Appointment buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Book Appointment').last,
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Book Appointment'), findsAtLeastNWidgets(3));
    });
  });

  group('DoctorsScreen Directionality Tests', () {
    testWidgets('app bar layout flips in RTL mode', (WidgetTester tester) async {
      double getX(Finder finder) => tester.getCenter(finder).dx;

      // 1. Test LTR
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: DoctorsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonLtr = find.byType(IconButton);
      final titleLtr = find.text('Find a Doctor');

      expect(getX(backButtonLtr) < getX(titleLtr), isTrue);

      // 2. Test RTL
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: DoctorsScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonRtl = find.byType(IconButton);
      final titleRtl = find.text('Find a Doctor');

      expect(getX(backButtonRtl) > getX(titleRtl), isTrue);
    });
  });
}
