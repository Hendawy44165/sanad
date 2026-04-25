import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/dependency_injection.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockDio extends Mock implements Dio {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late AuthRemoteDataSource dataSource;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockGoTrue;
  late MockDio mockDio;

  setUpAll(() async {
    await getIt.reset();
    registerFallbackValue(FakeAuthState());
    registerFallbackValue(Options());
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockGoTrue = MockGoTrueClient();
    mockDio = MockDio();

    when(() => mockSupabase.auth).thenReturn(mockGoTrue);

    dataSource = AuthRemoteDataSource(mockSupabase, mockDio);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tToken = 'token123';
  const tUserJson = {
    '_id': '1',
    'supabase_user_id': 'sub123',
    'email': tEmail,
    'language': 'ar',
    'notifications_enabled': true,
    'role': 'user',
    'profile_completion': 10,
    'is_active': true,
  };
  const tResponseJson = {'success': true, 'data': tUserJson};

  group('AuthRemoteDataSource', () {
    group('signInWithPassword', () {
      test(
        'should return UserModel when sign in and sync are successful',
        () async {
          // arrange
          final authResponse = AuthResponse(
            session: Session(
              accessToken: tToken,
              tokenType: 'bearer',
              user: User(
                id: 'sub123',
                appMetadata: {},
                userMetadata: {},
                aud: 'aud',
                createdAt: '2023-01-01',
              ),
            ),
          );
          when(
            () => mockGoTrue.signInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          when(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).thenAnswer(
            (_) async => Response(
              data: tResponseJson,
              statusCode: 200,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          // act
          final result = await dataSource.signInWithPassword(tEmail, tPassword);

          // assert
          expect(result.email, tEmail);
          verify(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).called(1);
        },
      );

      test(
        'should throw AppException(unexpectedFailure) when session is null',
        () async {
          // arrange
          final authResponse = AuthResponse();
          when(
            () => mockGoTrue.signInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          // act & assert
          await expectLater(
            () => dataSource.signInWithPassword(tEmail, tPassword),
            throwsA(
              isA<AppException>().having(
                (e) => e.code,
                'code',
                Codes.unexpectedFailure,
              ),
            ),
          );
        },
      );
    });

    group('signUp', () {
      test(
        'should throw AuthException(email_not_confirmed) when session is null',
        () async {
          // arrange
          final authResponse = AuthResponse();
          when(
            () => mockGoTrue.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          // act & assert
          await expectLater(
            () => dataSource.signUp(tEmail, tPassword),
            throwsA(
              isA<AppException>().having(
                (e) => e.code,
                'code',
                Codes.emailNotConfirmed,
              ),
            ),
          );
        },
      );

      test(
        'should call signOut and rethrow when sync profile fails during signUp',
        () async {
          // arrange
          final authResponse = AuthResponse(
            session: Session(
              accessToken: tToken,
              tokenType: 'bearer',
              user: User(
                id: 'sub123',
                appMetadata: {},
                userMetadata: {},
                aud: 'aud',
                createdAt: '2023-01-01',
              ),
            ),
          );
          when(
            () => mockGoTrue.signUp(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          when(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).thenThrow(
            DioException(
              requestOptions: RequestOptions(path: ''),
              type: DioExceptionType.connectionTimeout,
            ),
          );
          when(() => mockGoTrue.signOut()).thenAnswer((_) async => {});

          // act & assert
          await expectLater(
            () => dataSource.signUp(tEmail, tPassword),
            throwsA(
              isA<AppException>().having(
                (e) => e.code,
                'code',
                Codes.requestTimeout,
              ),
            ),
          );
          // Verify signOut was called
          verify(() => mockGoTrue.signOut()).called(1);
        },
      );
    });

    group('syncProfile edge cases', () {
      test(
        'should throw AppException(unexpectedFailure) on 400 status',
        () async {
          // arrange
          final authResponse = AuthResponse(
            session: Session(
              accessToken: tToken,
              tokenType: 'bearer',
              user: User(
                id: 'sub123',
                appMetadata: {},
                userMetadata: {},
                aud: 'aud',
                createdAt: '2023-01-01',
              ),
            ),
          );
          when(
            () => mockGoTrue.signInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          when(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).thenAnswer(
            (_) async => Response(
              data: {'success': false},
              statusCode: 400,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          // act & assert
          await expectLater(
            () => dataSource.signInWithPassword(tEmail, tPassword),
            throwsA(
              isA<AppException>().having(
                (e) => e.code,
                'code',
                Codes.unexpectedFailure,
              ),
            ),
          );
        },
      );

      test(
        'should throw AuthException(reauthentication_needed) on 401 status',
        () async {
          // arrange
          final authResponse = AuthResponse(
            session: Session(
              accessToken: tToken,
              tokenType: 'bearer',
              user: User(
                id: 'sub123',
                appMetadata: {},
                userMetadata: {},
                aud: 'aud',
                createdAt: '2023-01-01',
              ),
            ),
          );
          when(
            () => mockGoTrue.signInWithPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => authResponse);

          when(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).thenAnswer(
            (_) async => Response(
              data: {'success': false},
              statusCode: 401,
              requestOptions: RequestOptions(path: ''),
            ),
          );

          // act & assert
          await expectLater(
            () => dataSource.signInWithPassword(tEmail, tPassword),
            throwsA(
              isA<AppException>().having(
                (e) => e.code,
                'code',
                Codes.reauthenticationNeeded,
              ),
            ),
          );
        },
      );
    });

    group('restoreSession', () {
      test('should return null when there is no current session', () async {
        when(() => mockGoTrue.currentSession).thenReturn(null);
        final result = await dataSource.restoreSession();
        expect(result, isNull);
      });

      test(
        'should call signOut and return null when reauthentication_needed is thrown',
        () async {
          final session = Session(
            accessToken: tToken,
            tokenType: 'bearer',
            user: User(
              id: 'sub123',
              appMetadata: {},
              userMetadata: {},
              aud: 'aud',
              createdAt: '2023-01-01',
            ),
          );
          when(() => mockGoTrue.currentSession).thenReturn(session);
          when(
            () => mockDio.post(any(), options: any(named: 'options')),
          ).thenAnswer(
            (_) async => Response(
              data: {'success': false},
              statusCode: 401,
              requestOptions: RequestOptions(path: ''),
            ),
          );
          when(() => mockGoTrue.signOut()).thenAnswer((_) async => {});

          final result = await dataSource.restoreSession();

          expect(result, isNull);
          verify(() => mockGoTrue.signOut()).called(1);
        },
      );

      test('should return null but NOT sign out on network error', () async {
        final session = Session(
          accessToken: tToken,
          tokenType: 'bearer',
          user: User(
            id: 'sub123',
            appMetadata: {},
            userMetadata: {},
            aud: 'aud',
            createdAt: '2023-01-01',
          ),
        );
        when(() => mockGoTrue.currentSession).thenReturn(session);
        when(
          () => mockDio.post(any(), options: any(named: 'options')),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        final result = await dataSource.restoreSession();

        expect(result, isNull);
        verifyNever(() => mockGoTrue.signOut());
      });
    });
  });
}
