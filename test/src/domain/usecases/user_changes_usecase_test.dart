import 'dart:async';

import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:authentication/src/domain/usecases/user_changes_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logging/logging.dart';

import 'user_changes_usecase_test.mocks.dart';

@GenerateMocks([IAuthUserRepository])
void main() {
  late UserChangesUseCase useCase;
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
    useCase = UserChangesUseCase(mockRepository);
    logRecords.clear();
  });

  tearDownAll(() {
    subscription.cancel();
  });

  group('UserChangesUseCase', () {
    test('should emit user changes', () async {
      final user1 = AuthUser(uid: 'uid1', email: 'user1@example.com');
      final user2 = AuthUser(uid: 'uid2', email: 'user2@example.com');

      when(mockRepository.userChanges())
          .thenAnswer((_) => Stream.fromIterable([user1, user2, null]));

      final stream = useCase();
      expect(stream, emitsInOrder([user1, user2, null]));

      await stream.toList();

      expect(logRecords, hasLength(5));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');
      expect(logRecords[2].message, 'User state changed: user1@example.com');
      expect(logRecords[3].message, 'User state changed: user2@example.com');
      expect(logRecords[4].message, 'User signed out');

      verify(mockRepository.userChanges()).called(1);
    });

    test('should handle empty stream', () async {
      when(mockRepository.userChanges()).thenAnswer((_) => Stream.empty());

      final stream = useCase();
      expect(stream, emitsDone);

      await stream.toList();

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');

      verify(mockRepository.userChanges()).called(1);
    });

    test('should handle and rethrow errors', () {
      when(mockRepository.userChanges())
          .thenAnswer((_) => Stream.error(Exception('Test error')));

      final stream = useCase();
      expect(stream, emitsError(isA<Exception>()));

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');

      verify(mockRepository.userChanges()).called(1);
    });

    test('should handle and rethrow exceptions', () {
      when(mockRepository.userChanges()).thenThrow(Exception('Test exception'));

      expect(() => useCase().listen((event) {}), throwsException);

      expect(logRecords, hasLength(3));
      expect(logRecords[0].message, contains('Starting user changes stream'));
      expect(logRecords[1].message, contains('Executing UserChangesUseCase'));
      expect(logRecords[2].message,
          contains('Error in UserChangesUseCase: Exception: Test exception'));
    });

    test('should handle empty stream', () async {
      when(mockRepository.userChanges()).thenAnswer((_) => Stream.empty());

      final stream = useCase();
      expect(stream, emitsDone);

      await stream.toList();

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');

      verify(mockRepository.userChanges()).called(1);
    });

    test('should handle and rethrow errors', () {
      when(mockRepository.userChanges())
          .thenAnswer((_) => Stream.error(Exception('Test error')));

      final stream = useCase();
      expect(stream, emitsError(isA<Exception>()));

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');

      verify(mockRepository.userChanges()).called(1);
    });

    test('should log severe error when exception occurs', () {
      when(mockRepository.userChanges()).thenThrow(Exception('Test error'));

      expect(() => useCase(), throwsException);

      expect(logRecords, hasLength(3));
      expect(logRecords[0].message, 'Starting user changes stream');
      expect(logRecords[1].message, 'Executing UserChangesUseCase');
      expect(logRecords[2].message,
          contains('Error in UserChangesUseCase: Exception: Test error'));

      verify(mockRepository.userChanges()).called(1);
    });
  });
}
