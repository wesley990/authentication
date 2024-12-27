import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logging/logging.dart';

import 'signin_usecase_test.mocks.dart';

@GenerateMocks([IAuthUserRepository])
void main() {
  late SignInUseCase useCase;
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
    useCase = SignInUseCase(mockRepository);
    logRecords.clear();
  });

  tearDownAll(() {
    subscription.cancel();
  });

  group('SignInUseCase', () {
    final testEmail = 'test@example.com';
    final testPassword = 'password123';
    final testUser = AuthUser(
      uid: 'test_uid',
      email: testEmail,
      displayName: 'Test User',
      isEmailVerified: true,
    );

    test('should sign in user successfully', () async {
      when(mockRepository.signInWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => testUser);

      await useCase(SignInParams(email: testEmail, password: testPassword));

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignInUseCase with email: $testEmail');
      expect(logRecords[1].message, 'User signed in successfully: $testEmail');
      verify(mockRepository.signInWithCredential(
              email: testEmail, password: testPassword))
          .called(1);
    });

    test('should throw AuthException when repository throws', () async {
      when(mockRepository.signInWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenThrow(AuthException('invalid-email'));

      await expectLater(
        () => useCase(SignInParams(email: testEmail, password: testPassword)),
        throwsA(isA<AuthException>()),
      );

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignInUseCase with email: $testEmail');
      expect(
          logRecords[1].message,
          contains(
              'Error in SignInUseCase: AuthException: AuthException: [invalidEmail] 1000: The email address is not valid.'));
    });

    test('should handle and rethrow unexpected exceptions', () async {
      when(mockRepository.signInWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenThrow(Exception('Unexpected error'));

      await expectLater(
        () => useCase(SignInParams(email: testEmail, password: testPassword)),
        throwsA(isA<Exception>()),
      );

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignInUseCase with email: $testEmail');
      expect(logRecords[1].message,
          contains('Error in SignInUseCase: Exception: Unexpected error'));
    });
  });
}
