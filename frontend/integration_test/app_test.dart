import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanad/core/repositories/supabase_repository.dart';
import 'package:sanad/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:sanad/core/theme/app_theme.dart';
import 'package:sanad/core/services/notification_service.dart';
import 'mocks.dart';

class MockNotificationService extends Mock implements NotificationService {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockSupabaseRepository mockRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockRepository = MockSupabaseRepository();
    mockNotificationService = MockNotificationService();

    when(() => mockNotificationService.init()).thenAnswer((_) async {});
  });

  // Helper to pump the app with fresh provider scope
  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        supabaseRepositoryProvider.overrideWithValue(mockRepository),
        notificationServiceProvider.overrideWithValue(mockNotificationService),
      ],
      child: MaterialApp(
        title: 'Sanad Integration Test',
        theme: AppTheme.lightTheme,
        home: const DashboardScreen(),
      ),
    );
  }

  group('Sanad User Journey Tests', () {
    testWidgets('User explores core features and navigates sub-features (Happy Path)', (
      tester,
    ) async {
      // --- Setup Mock Data ---
      when(
        () => mockRepository.getMedicationAlarms(),
      ).thenAnswer((_) async => mockAlarms);
      when(
        () => mockRepository.getEvents(),
      ).thenAnswer((_) async => mockEvents);
      when(
        () => mockRepository.getServices(),
      ).thenAnswer((_) async => mockServices);
      when(() => mockRepository.getNews()).thenAnswer((_) async => mockNews);
      when(
        () => mockRepository.getDoctors(),
      ).thenAnswer((_) async => mockDoctors);
      when(
        () => mockRepository.getProfile(any()),
      ).thenAnswer((_) async => mockProfile);

      // --- Start App ---
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // --- Step 1: Verify Dashboard Loads ---
      expect(find.text('Hello, Friend! 👋'), findsOneWidget);
      expect(find.text('Medication Reminders'), findsOneWidget);
      expect(find.text('Aspirin'), findsOneWidget); // Medication Alarm

      // --- Step 2: Navigate to News (Sub-feature) ---
      // Find "View All" button near News section.
      // Since there are multiple "View All" buttons, we need to be specific.
      // We can find the DashboardSection for News and find the button descendant.
      // Alternatively, finding by key if keys were present.
      // Here we rely on order or finding the specific text associated with the section.

      // Let's scroll to find the News section first if needed
      await tester.dragUntilVisible(
        find.text('Latest News'),
        find.byType(CustomScrollView),
        const Offset(0, -200),
      );

      // Tap the View All button for News.
      // The structure is DashboardSection(title: 'Latest News', action: TextButton('View All'))
      // We'll look for the widget structure.

      // Actually simpler: Find the specific 'View All' near 'Latest News'.
      // But standard finder might be ambiguous.
      // Let's tap the News Item itself? No, we established they aren't clickable.
      // Let's try to tap the "View All" that follows "Latest News" in the widget tree order?
      // Or just tap the 4th "View All" (Events, Services, News, Doctors).
      // Indexes: 0=Events, 1=Services, 2=News, 3=Doctors.

      final viewAllButtons = find.text('View All');
      // Expect at least 4 buttons
      expect(viewAllButtons, findsAtLeastNWidgets(4));

      // Tap News (index 2)
      await tester.tap(viewAllButtons.at(2));
      await tester.pumpAndSettle();

      // --- Step 3: Verify News Screen ---
      expect(find.text('Latest News'), findsOneWidget); // AppBar title
      expect(
        find.text('New Health Guidelines'),
        findsOneWidget,
      ); // Item content

      // --- Step 4: Back to Dashboard ---
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.text('Hello, Friend! 👋'), findsOneWidget);

      // --- Step 5: Navigate to Services (Sub-feature) ---
      await tester.dragUntilVisible(
        find.text('Support Services'),
        find.byType(CustomScrollView),
        const Offset(0, -200),
      );

      // Tap Services (index 1)
      await tester.tap(viewAllButtons.at(1));
      await tester.pumpAndSettle();

      // --- Step 6: Verify Services Screen ---
      expect(find.text('Community Services'), findsOneWidget); // AppBar title
      expect(find.text('Medical Transport'), findsOneWidget); // Item
      expect(find.text('Offer Help'), findsOneWidget); // Action button

      // --- Step 7: Back to Dashboard ---
      await tester.pageBack();
      await tester.pumpAndSettle();
    });

    testWidgets('User encounters empty states (No Data)', (tester) async {
      // --- Setup Empty Data ---
      when(
        () => mockRepository.getMedicationAlarms(),
      ).thenAnswer((_) async => []);
      when(() => mockRepository.getEvents()).thenAnswer((_) async => []);
      when(() => mockRepository.getServices()).thenAnswer((_) async => []);
      when(() => mockRepository.getNews()).thenAnswer((_) async => []);
      when(() => mockRepository.getDoctors()).thenAnswer((_) async => []);
      when(
        () => mockRepository.getProfile(any()),
      ).thenAnswer((_) async => mockProfile);

      // --- Start App ---
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle(); // Settle all logic

      // --- Verify Empty Dashboard Messages ---
      expect(find.text('No reminders set'), findsOneWidget);
      expect(find.text('No upcoming events'), findsOneWidget);
      expect(find.text('No services found'), findsOneWidget);
      expect(find.text('No news available'), findsOneWidget);
      expect(find.text('No doctors found'), findsOneWidget);
    });

    testWidgets('User encounters connectivity issues (Error Handling)', (
      tester,
    ) async {
      // --- Setup Error Data ---
      final exception = Exception('Network Error');
      when(() => mockRepository.getMedicationAlarms()).thenThrow(exception);
      when(() => mockRepository.getEvents()).thenThrow(exception);
      when(() => mockRepository.getServices()).thenThrow(exception);
      when(() => mockRepository.getNews()).thenThrow(exception);
      when(() => mockRepository.getDoctors()).thenThrow(exception);
      when(
        () => mockRepository.getProfile(any()),
      ).thenAnswer((_) async => mockProfile);

      // --- Start App ---
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // --- Verify Error Messages ---
      // Use find.textContaining to capture "Error: Exception: Network Error" or simlar
      expect(find.textContaining('Network Error'), findsAtLeastNWidgets(1));
      // Dashboard sections show 'Error' as subtitle
      expect(find.text('Error'), findsAtLeastNWidgets(1));
    });
  });
}
