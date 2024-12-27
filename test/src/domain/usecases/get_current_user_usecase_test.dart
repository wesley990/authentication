import 'dart:async';

import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:authentication/src/domain/usecases/get_current_user_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logging/logging.dart';

import 'get_current_user_usecase_test.mocks.dart';

@GenerateMocks([IAuthUserRepository])
void main() {
  late GetCurrentUserUseCase useCase;
  late MockIAuthUserRepository mockRepository;
  late List<LogRecord> logRecords;
  late StreamSubscription<LogRecord> subscription;

  setUpAll(() {
    Logger.root.level = Level.ALL;
    logRecords = [];
    subscription = Logger.root.onRecord.listen((record) {
      logRecords.add(record);
    });
  });

  setUp(() {
    mockRepository = MockIAuthUserRepository();
    useCase = GetCurrentUserUseCase(mockRepository);
    logRecords.clear();
  });

  tearDownAll(() {
    subscription.cancel();
  });

  group('GetCurrentUserUseCase', () {
    test('should return current user when user is authenticated', () {
      final authUser = AuthUser(
        uid: 'test_uid',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      when(mockRepository.currentUser).thenReturn(authUser);

      final result = useCase();

      expect(result, equals(authUser));
      expect(logRecords, hasLength(2));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'Current user retrieved: test@example.com');
      verify(mockRepository.currentUser).called(1);
    });

    test('should return null when no user is authenticated', () {
      when(mockRepository.currentUser).thenReturn(null);

      final result = useCase();

      expect(result, isNull);
      expect(logRecords, hasLength(2));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'No current user');
      verify(mockRepository.currentUser).called(1);
    });

    test('should log warning when user has empty UID', () {
      final authUser = AuthUser(
        uid: '',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      when(mockRepository.currentUser).thenReturn(authUser);

      final result = useCase();

      expect(result, equals(authUser));
      expect(logRecords, hasLength(3));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'Current user has an empty UID');
      expect(logRecords[2].message, 'Current user retrieved: test@example.com');
      verify(mockRepository.currentUser).called(1);
    });

    test('should log warning when user has empty email', () {
      final authUser = AuthUser(
        uid: 'test_uid',
        email: '',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      when(mockRepository.currentUser).thenReturn(authUser);

      final result = useCase();

      expect(result, equals(authUser));
      expect(logRecords, hasLength(3));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'Current user has an empty email');
      expect(logRecords[2].message, 'Current user retrieved: ');
      verify(mockRepository.currentUser).called(1);
    });

    test('should log warnings when user has empty UID and email', () {
      final authUser = AuthUser(
        uid: '',
        email: '',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      when(mockRepository.currentUser).thenReturn(authUser);

      final result = useCase();

      expect(result, equals(authUser));
      expect(logRecords, hasLength(4));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'Current user has an empty UID');
      expect(logRecords[2].message, 'Current user has an empty email');
      expect(logRecords[3].message, 'Current user retrieved: ');
      verify(mockRepository.currentUser).called(1);
    });

    test('should log info when user has non-empty UID and email', () {
      final authUser = AuthUser(
        uid: 'test_uid',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      when(mockRepository.currentUser).thenReturn(authUser);

      final result = useCase();

      expect(result, equals(authUser));
      expect(logRecords, hasLength(2));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(logRecords[1].message, 'Current user retrieved: test@example.com');
      verify(mockRepository.currentUser).called(1);
    });

    test('should handle and rethrow exceptions', () {
      when(mockRepository.currentUser).thenThrow(Exception('Test exception'));

      expect(() => useCase(), throwsException);
      expect(logRecords, hasLength(2));
      expect(
          logRecords[0].message, 'Executing use case: GetCurrentUserUseCase');
      expect(
          logRecords[1].message,
          contains(
              'Error in GetCurrentUserUseCase: Exception: Test exception'));
      verify(mockRepository.currentUser).called(1);
    });
  });
}
