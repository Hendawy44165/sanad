import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/books/presentation/screens/books_screen.dart';

void main() {
  Widget createWidgetUnderTest() {
    return const ProviderScope(child: MaterialApp(home: BooksScreen()));
  }

  group('BooksScreen Widget Tests', () {
    testWidgets('renders Request a Book title', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Request a Book'), findsOneWidget);
    });

    testWidgets('renders search field with correct hint', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Search books...'), findsOneWidget);
    });

    testWidgets('renders formats banner', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Available in Multiple Formats'), findsOneWidget);
      expect(
        find.text(
          'Request any book in audio, Braille, large print, or e-book format.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders book filters', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('All Formats'), findsOneWidget);
      expect(find.text('Audio Book'), findsAtLeastNWidgets(1));
      expect(find.text('Braille'), findsAtLeastNWidgets(1));
      expect(find.text('Large Print'), findsAtLeastNWidgets(1));
      expect(find.text('E-Book'), findsAtLeastNWidgets(1));
    });

    testWidgets('renders book cards with titles and authors', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('The Art of Possibility'), findsOneWidget);
      expect(find.text('Rosamund Stone Zander'), findsOneWidget);
      expect(find.text('Personal Growth'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('The Brain That Changes Itself'),
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('A Still Small Voice'), findsOneWidget);
      expect(find.text('Echo Bodine'), findsOneWidget);

      expect(find.text('The Brain That Changes Itself'), findsOneWidget);
      expect(find.text('Norman Doidge'), findsOneWidget);
    });

    testWidgets('renders Request Book buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.scrollUntilVisible(
        find.text('Request Book').last,
        200.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Request Book'), findsAtLeastNWidgets(3));
    });
  });

  group('BooksScreen Directionality Tests', () {
    testWidgets('app bar layout flips in RTL mode', (WidgetTester tester) async {
      double getX(Finder finder) => tester.getCenter(finder).dx;

      // 1. Test LTR
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.ltr,
              child: BooksScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonLtr = find.byType(IconButton);
      final titleLtr = find.text('Request a Book');

      expect(getX(backButtonLtr) < getX(titleLtr), isTrue);

      // 2. Test RTL
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Directionality(
              textDirection: TextDirection.rtl,
              child: BooksScreen(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final backButtonRtl = find.byType(IconButton);
      final titleRtl = find.text('Request a Book');

      expect(getX(backButtonRtl) > getX(titleRtl), isTrue);
    });
  });
}
