import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:logging/logging.dart';

import 'signup_usecase_test.mocks.dart';

@GenerateMocks([IAuthUserRepository])
void main() {
  late SignUpUseCase useCase;
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
    useCase = SignUpUseCase(mockRepository);
    logRecords.clear();
  });

  tearDownAll(() {
    subscription.cancel();
  });

  group('SignUpUseCase', () {
    final testEmail = 'test@example.com';
    final testPassword = 'password123';
    final testUser = AuthUser(
      uid: 'test_uid',
      email: testEmail,
      displayName: 'Test User',
      isEmailVerified: false,
    );

    test('should sign up user successfully', () async {
      when(mockRepository.signUpWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenAnswer((_) async => testUser);

      final result =
          await useCase(SignUpParams(email: testEmail, password: testPassword));

      expect(result, equals(testUser));
      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignUpUseCase with email: $testEmail');
      expect(logRecords[1].message, 'User signed up successfully: $testEmail');
      verify(mockRepository.signUpWithCredential(
              email: testEmail, password: testPassword))
          .called(1);
    });

    test('should throw AuthException when repository throws', () async {
      when(mockRepository.signUpWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenThrow(AuthException('email-already-in-use'));

      await expectLater(
        () => useCase(SignUpParams(email: testEmail, password: testPassword)),
        throwsA(isA<AuthException>()),
      );

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignUpUseCase with email: $testEmail');
      expect(
        logRecords[1].message,
        contains(
            'Error in SignUpUseCase: AuthException: AuthException: [emailAlreadyInUse] 1004: The email address is already in use.'),
      );
    });

    test('should handle and rethrow unexpected exceptions', () async {
      when(mockRepository.signUpWithCredential(
        email: testEmail,
        password: testPassword,
      )).thenThrow(Exception('Unexpected error'));

      await expectLater(
        () => useCase(SignUpParams(email: testEmail, password: testPassword)),
        throwsA(isA<Exception>()),
      );

      expect(logRecords, hasLength(2));
      expect(logRecords[0].message,
          'Executing use case: SignUpUseCase with email: $testEmail');
      expect(logRecords[1].message,
          contains('Error in SignUpUseCase: Exception: Unexpected error'));
    });
  });
}
