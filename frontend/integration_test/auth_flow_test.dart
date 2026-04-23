import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/main.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/features/auth/logic/entities/user_entity.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    if (getIt.isRegistered<AuthRepository>()) {
      getIt.unregister<AuthRepository>();
    }
    getIt.registerSingleton<AuthRepository>(mockRepository);
  });

  const tUser = UserEntity(
    id: '1',
    supabaseUserId: 'sub123',
    email: 'test@example.com',
    language: 'ar',
    notificationsEnabled: true,
    role: 'user',
    profileCompletion: 10,
    isActive: true,
  );

  testWidgets('Auth Flow Integration Test: Successful Login', (
    WidgetTester tester,
  ) async {
    // arrange
    when(
      () => mockRepository.signIn(any(), any()),
    ).thenAnswer((_) async => const ResponseModel.success(tUser));

    await tester.pumpWidget(const ProviderScope(child: SanadApp()));
    await tester.pumpAndSettle();

    // Verify we are on WelcomeScreen
    expect(find.text('Sign In'), findsOneWidget);

    // act
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).last, 'password123');
    await tester.tap(find.text('Sign In'));

    await tester.pumpAndSettle();

    // assert
    // Since context.go('/') is used, we expect to see Dashboard elements
    // Note: If redirect is used, it might be different.
    // In our router.dart, '/' maps to DashboardScreen.
    expect(find.text('Login Successful'), findsOneWidget);
    // expect(find.byType(DashboardScreen), findsOneWidget); // Depends on implementation
  });
}
