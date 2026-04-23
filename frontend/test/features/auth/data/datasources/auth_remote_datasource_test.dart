import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';
import 'package:sanad/core/dependency_injection.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class FakeStreamTransformer extends Fake
    implements StreamTransformer<List<int>, String> {}

class FakeAuthState extends Fake implements AuthState {}

void main() {
  late AuthRemoteDataSource dataSource;
  late MockSupabaseClient mockSupabase;
  late MockGoTrueClient mockGoTrue;
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest mockRequest;
  late MockHttpClientResponse mockResponse;
  late MockHttpHeaders mockHeaders;

  setUpAll(() async {
    await getIt.reset();
    registerFallbackValue(
      Uri.parse('http://localhost:4000/api/v1/auth/sync-profile'),
    );
    registerFallbackValue(utf8.decoder);
    registerFallbackValue(FakeAuthState());
  });

  setUp(() {
    mockSupabase = MockSupabaseClient();
    mockGoTrue = MockGoTrueClient();
    mockHttpClient = MockHttpClient();
    mockRequest = MockHttpClientRequest();
    mockResponse = MockHttpClientResponse();
    mockHeaders = MockHttpHeaders();

    when(() => mockSupabase.auth).thenReturn(mockGoTrue);
    when(() => mockRequest.headers).thenReturn(mockHeaders);
    when(() => mockRequest.close()).thenAnswer((_) async => mockResponse);
    when(
      () => mockHttpClient.postUrl(any()),
    ).thenAnswer((_) async => mockRequest);

    dataSource = AuthRemoteDataSource(mockSupabase, mockHttpClient);
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

          when(() => mockResponse.statusCode).thenReturn(200);
          when(
            () => mockResponse.transform(
              any<StreamTransformer<List<int>, String>>(),
            ),
          ).thenAnswer((_) => Stream.fromIterable([jsonEncode(tResponseJson)]));

          // act
          final result = await dataSource.signInWithPassword(tEmail, tPassword);

          // assert
          expect(result.email, tEmail);
          verify(() => mockHttpClient.postUrl(any())).called(1);
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
            () => mockHttpClient.postUrl(any()),
          ).thenThrow(const SocketException('timeout'));
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

          when(() => mockResponse.statusCode).thenReturn(400);
          when(
            () => mockResponse.transform(
              any<StreamTransformer<List<int>, String>>(),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              jsonEncode({'success': false}),
            ]),
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

          when(() => mockResponse.statusCode).thenReturn(401);
          when(
            () => mockResponse.transform(
              any<StreamTransformer<List<int>, String>>(),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              jsonEncode({'success': false}),
            ]),
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
          when(() => mockResponse.statusCode).thenReturn(401);
          when(
            () => mockResponse.transform(
              any<StreamTransformer<List<int>, String>>(),
            ),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              jsonEncode({'success': false}),
            ]),
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
          () => mockHttpClient.postUrl(any()),
        ).thenThrow(const SocketException('timeout'));

        final result = await dataSource.restoreSession();

        expect(result, isNull);
        verifyNever(() => mockGoTrue.signOut());
      });
    });
  });
}
