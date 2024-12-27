import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logging/logging.dart';

import 'signout_usecase_test.mocks.dart';

@GenerateMocks([IAuthUserRepository])
void main() {
  late SignOutUseCase useCase;
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
    useCase = SignOutUseCase(mockRepository);
    logRecords.clear();
  });

  tearDownAll(() {
    subscription.cancel();
  });

  group('SignOutUseCase', () {
    final testUser = AuthUser(
      uid: 'test_uid',
      email: 'test@example.com',
      displayName: 'Test User',
      isEmailVerified: true,
    );

    test('should sign out user successfully', () async {
      // Set up the mock to return a user initially, then null after sign out
      when(mockRepository.currentUser).thenReturn(testUser);
      when(mockRepository.signOut()).thenAnswer((_) async {
        // Update the mock to return null after sign out
        when(mockRepository.currentUser).thenReturn(null);
      });

      await useCase();

      // Wait for all microtasks to complete
      await Future.microtask(() {});

      expect(logRecords, hasLength(3));
      expect(logRecords[0].message, 'Executing use case: SignOutUseCase');
      expect(logRecords[1].message, 'Signing out user: test@example.com');
      expect(logRecords[2].message, 'User signed out successfully');
      verify(mockRepository.signOut()).called(1);
    });

    test('should handle case when no user is signed in', () async {
      when(mockRepository.currentUser).thenReturn(null);

      await useCase();

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message, 'Executing use case: SignOutUseCase');
      expect(logRecords[1].message,
          'Attempt to sign out when no user is signed in');
      verifyNever(mockRepository.signOut());
    });

    test('should throw AuthException when sign out fails', () async {
      when(mockRepository.currentUser).thenReturn(testUser);
      when(mockRepository.signOut()).thenAnswer((_) async {});
      // User still signed in after sign out attempt
      when(mockRepository.currentUser).thenReturn(testUser);

      expect(() => useCase(), throwsA(isA<AuthException>()));

      // Wait for all microtasks to complete
      await Future.microtask(() {});

      expect(logRecords, hasLength(4));
      expect(logRecords[0].message, 'Executing use case: SignOutUseCase');
      expect(logRecords[1].message, 'Signing out user: test@example.com');
      expect(logRecords[2].message, 'Sign out failed: user is still signed in');
      expect(logRecords[3].message,
          contains('Error in SignOutUseCase: AuthException:'));
      verify(mockRepository.signOut()).called(1);
    });

    test('should handle and rethrow unexpected exceptions', () async {
      when(mockRepository.currentUser).thenReturn(testUser);
      when(mockRepository.signOut()).thenThrow(Exception('Unexpected error'));

      expect(() => useCase(), throwsA(isA<Exception>()));

      // Wait for all microtasks to complete
      await Future.microtask(() {});

      expect(logRecords, hasLength(3));
      expect(logRecords[0].message, 'Executing use case: SignOutUseCase');
      expect(logRecords[1].message, 'Signing out user: test@example.com');
      expect(logRecords[2].message,
          contains('Error in SignOutUseCase: Exception: Unexpected error'));
      verify(mockRepository.signOut()).called(1);
    });
  });
}
