import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sanad/core/dependency_injection.dart';
import 'package:sanad/features/auth/logic/entities/user_entity.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/features/auth/presentation/providers/auth_provider.dart';
import 'package:sanad/features/auth/presentation/providers/auth_state.dart';
import 'package:sanad/core/models/response_model.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/l10n/app_localizations.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAuthRepository mockRepository;
  late MockAppLocalizations mockL10n;

  setUpAll(() async {
    await getIt.reset();
    mockRepository = MockAuthRepository();
    mockL10n = MockAppLocalizations();

    // Register mock repository in GetIt
    if (!getIt.isRegistered<AuthRepository>()) {
      getIt.registerSingleton<AuthRepository>(mockRepository);
    }
    if (!getIt.isRegistered<AuthProvider>()) {
      getIt.registerLazySingleton<AuthProvider>(
        () => AuthProvider(AuthNotifier.new),
      );
    }

    // Mock l10n strings
    when(
      () => mockL10n.err_invalidCredentials,
    ).thenReturn('Invalid credentials');
    when(() => mockL10n.err_unknown).thenReturn('Unknown error');
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

  setUp(() {
    when(
      () => mockRepository.restoreSession(),
    ).thenAnswer((_) async => const ResponseModel.success(null));
    when(
      () => mockRepository.onAuthStateChange,
    ).thenAnswer((_) => const Stream.empty());
  });

  group('AuthNotifier', () {
    test('initial state should be AuthState with default values', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final state = await container.read(getIt<AuthProvider>().future);

      expect(state.isLoading, isFalse);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('signIn should update state with user on success', () async {
      // arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      when(
        () => mockRepository.signIn(any(), any()),
      ).thenAnswer((_) async => const ResponseModel.success(tUser));

      final notifier = container.read(getIt<AuthProvider>().notifier);
      await container.read(getIt<AuthProvider>().future);

      // act
      await notifier.signIn('email', 'password', mockL10n);

      // assert
      final state = container.read(getIt<AuthProvider>()).value;
      expect(state?.user, tUser);
      expect(state?.isLoading, isFalse);
    });

    test(
      'signIn should emit error then return to old state on failure',
      () async {
        // arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        when(() => mockRepository.signIn(any(), any())).thenAnswer(
          (_) async => const ResponseModel.failure(Codes.invalidCredentials),
        );

        final notifier = container.read(getIt<AuthProvider>().notifier);
        await container.read(getIt<AuthProvider>().future);

        final states = <AsyncValue<AuthState>>[];
        container.listen(
          getIt<AuthProvider>(),
          (previous, next) => states.add(next),
          fireImmediately: true,
        );

        // act
        await notifier.signIn('email', 'password', mockL10n);

        // assert
        // States should be: data(initial), loading, error('Invalid credentials'), data(initial)
        expect(states.any((s) => s is AsyncLoading), isTrue);
        expect(
          states.any((s) => s.hasError && s.error == 'Invalid credentials'),
          isTrue,
        );
        expect(container.read(getIt<AuthProvider>()).value?.user, isNull);
      },
    );

    test('signUp should update state with user on success', () async {
      // arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      when(
        () => mockRepository.signUp(any(), any()),
      ).thenAnswer((_) async => const ResponseModel.success(tUser));

      final notifier = container.read(getIt<AuthProvider>().notifier);
      await container.read(getIt<AuthProvider>().future);

      // act
      await notifier.signUp('email', 'password', mockL10n);

      // assert
      final state = container.read(getIt<AuthProvider>()).value;
      expect(state?.user, tUser);
    });

    test('signOut should reset state on success', () async {
      // arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      when(
        () => mockRepository.signOut(),
      ).thenAnswer((_) async => const ResponseModel.success(null));

      final notifier = container.read(getIt<AuthProvider>().notifier);
      await container.read(getIt<AuthProvider>().future);

      // act
      await notifier.signOut(mockL10n);

      // assert
      final state = container.read(getIt<AuthProvider>()).value;
      expect(state?.user, isNull);
    });
  });
}
