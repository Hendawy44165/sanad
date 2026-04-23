import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sanad/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:sanad/features/auth/data/models/user_model.dart';
import 'package:sanad/features/auth/logic/repositories/auth_repository.dart';
import 'package:sanad/core/models/app_exception.dart';
import 'package:sanad/core/constants/codes.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepository repository;
  late MockAuthRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAuthRemoteDataSource();
    repository = AuthRepository(mockDataSource);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tUser = UserModel(
    id: '1',
    supabaseUserId: 'sub123',
    email: tEmail,
    language: 'ar',
    notificationsEnabled: true,
    role: 'user',
    profileCompletion: 10,
    isActive: true,
  );

  group('AuthRepository', () {
    group('signIn', () {
      test('should return success response when data source is successful', () async {
        // arrange
        when(() => mockDataSource.signInWithPassword(any(), any()))
            .thenAnswer((_) async => tUser);

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result.isSuccess, isTrue);
        expect(result.data, tUser);
        verify(() => mockDataSource.signInWithPassword(tEmail, tPassword)).called(1);
      });

      test('should return failure response when data source throws AuthException', () async {
        // arrange
        when(() => mockDataSource.signInWithPassword(any(), any()))
            .thenThrow(const AuthException('invalid_credentials'));

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.invalidCredentials);
      });

      test('should return failure response when data source throws AppException', () async {
        // arrange
        when(() => mockDataSource.signInWithPassword(any(), any()))
            .thenThrow(const AppException(Codes.requestTimeout));

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.requestTimeout);
      });

      test('should return failure response when data source throws generic Exception', () async {
        // arrange
        when(() => mockDataSource.signInWithPassword(any(), any()))
            .thenThrow(Exception('Generic error'));

        // act
        final result = await repository.signIn(tEmail, tPassword);

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.unknown);
      });
    });

    group('signUp', () {
      test('should return success response when data source is successful', () async {
        // arrange
        when(() => mockDataSource.signUp(any(), any()))
            .thenAnswer((_) async => tUser);

        // act
        final result = await repository.signUp(tEmail, tPassword);

        // assert
        expect(result.isSuccess, isTrue);
        expect(result.data, tUser);
        verify(() => mockDataSource.signUp(tEmail, tPassword)).called(1);
      });

      test('should return failure response when data source throws AuthException', () async {
        // arrange
        when(() => mockDataSource.signUp(any(), any()))
            .thenThrow(const AuthException('email_exists'));

        // act
        final result = await repository.signUp(tEmail, tPassword);

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.emailExists);
      });

      test('should return failure response when data source throws AppException', () async {
        // arrange
        when(() => mockDataSource.signUp(any(), any()))
            .thenThrow(const AppException(Codes.unexpectedFailure));

        // act
        final result = await repository.signUp(tEmail, tPassword);

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.unexpectedFailure);
      });
    });

    group('signOut', () {
      test('should return success response when data source is successful', () async {
        // arrange
        when(() => mockDataSource.signOut()).thenAnswer((_) async {});

        // act
        final result = await repository.signOut();

        // assert
        expect(result.isSuccess, isTrue);
        verify(() => mockDataSource.signOut()).called(1);
      });

      test('should return failure response when data source throws', () async {
        // arrange
        when(() => mockDataSource.signOut()).thenThrow(Exception());

        // act
        final result = await repository.signOut();

        // assert
        expect(result.isFailure, isTrue);
        expect(result.errorCode, Codes.unknown);
      });
    });
  });
}
