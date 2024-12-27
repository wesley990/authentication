import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/data/datasources/firebase_auth_data_source.dart';
import 'package:authentication/src/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'firebase_auth_data_source_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCredential, User])
void main() {
  late FirebaseIAuthDataSource dataSource;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCredential mockUserCredential;
  late MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
    dataSource = FirebaseIAuthDataSource(firebaseAuth: mockFirebaseAuth);
  });

  group('FirebaseIAuthDataSource', () {
    group('signUpWithCredential', () {
      test('should return AuthUserModel when user creation is successful',
          () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.displayName).thenReturn('Test User');

        final result = await dataSource.signUpWithCredential(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<AuthUserModel>());
        expect(result.uid, 'test_uid');
        expect(result.email, 'test@example.com');
        expect(result.isEmailVerified, false);
        expect(result.displayName, 'Test User');
      });

      test('should throw AuthException when FirebaseAuthException occurs',
          () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => dataSource.signUpWithCredential(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test(
          'should throw AuthException with "unknown" code for non-FirebaseAuthException errors',
          () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Unknown error'));

        expect(
          () => dataSource.signUpWithCredential(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(predicate(
              (e) => e is AuthException && e.code == ErrorCode.unknown)),
        );
      });

      test('should handle edge case with null user', () async {
        when(mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(null);

        expect(
          () => dataSource.signUpWithCredential(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthException>()),
        );
      });
    });

    group('signInWithCredential', () {
      test('should return AuthUserModel when sign in is successful', () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenAnswer((_) async => mockUserCredential);
        when(mockUserCredential.user).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.emailVerified).thenReturn(true);
        when(mockUser.displayName).thenReturn('Test User');

        final result = await dataSource.signInWithCredential(
          email: 'test@example.com',
          password: 'password123',
        );

        expect(result, isA<AuthUserModel>());
        expect(result.uid, 'test_uid');
        expect(result.email, 'test@example.com');
        expect(result.isEmailVerified, true);
        expect(result.displayName, 'Test User');
      });

      test('should throw AuthException when FirebaseAuthException occurs',
          () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => dataSource.signInWithCredential(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(isA<AuthException>()),
        );
      });

      test('should handle different FirebaseAuthException codes', () async {
        final exceptionCodes = [
          'invalid-email',
          'user-disabled',
          'wrong-password'
        ];

        for (final code in exceptionCodes) {
          when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          )).thenThrow(FirebaseAuthException(code: code));

          expect(
            () => dataSource.signInWithCredential(
              email: 'test@example.com',
              password: 'password123',
            ),
            throwsA(predicate((e) =>
                e is AuthException &&
                e.code.name.toLowerCase() == code.replaceAll('-', ''))),
          );
        }
      });

      test(
          'should throw AuthException with "unknown" code for non-FirebaseAuthException errors',
          () async {
        when(mockFirebaseAuth.signInWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        )).thenThrow(Exception('Unknown error'));

        expect(
          () => dataSource.signInWithCredential(
            email: 'test@example.com',
            password: 'password123',
          ),
          throwsA(predicate(
              (e) => e is AuthException && e.code == ErrorCode.unknown)),
        );
      });
    });

    group('signOut', () {
      test('should complete successfully when sign out is successful',
          () async {
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        expect(dataSource.signOut(), completes);
      });

      test('should throw AuthException when FirebaseAuthException occurs',
          () async {
        when(mockFirebaseAuth.signOut())
            .thenThrow(FirebaseAuthException(code: 'sign-out-failed'));

        expect(dataSource.signOut(), throwsA(isA<AuthException>()));
      });

      test(
          'should throw AuthException with "unknown" code for non-FirebaseAuthException errors',
          () async {
        when(mockFirebaseAuth.signOut()).thenThrow(Exception('Unknown error'));

        expect(
          dataSource.signOut(),
          throwsA(predicate(
              (e) => e is AuthException && e.code == ErrorCode.unknown)),
        );
      });
    });

    group('currentUser', () {
      test('should return AuthUserModel when there is a current user', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.emailVerified).thenReturn(true);
        when(mockUser.displayName).thenReturn('Test User');

        final result = dataSource.currentUser;

        expect(result, isA<AuthUserModel>());
        expect(result?.uid, 'test_uid');
        expect(result?.email, 'test@example.com');
        expect(result?.isEmailVerified, true);
        expect(result?.displayName, 'Test User');
      });

      test('should return null when there is no current user', () {
        when(mockFirebaseAuth.currentUser).thenReturn(null);

        final result = dataSource.currentUser;

        expect(result, isNull);
      });

      test('should handle edge case with null email', () {
        when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn(null);

        final result = dataSource.currentUser;

        expect(result, isNull);
      });
    });

    group('userChanges', () {
      test('should emit AuthUserModel when Firebase emits User', () {
        when(mockFirebaseAuth.userChanges())
            .thenAnswer((_) => Stream.value(mockUser));
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn('test@example.com');
        when(mockUser.emailVerified).thenReturn(true);
        when(mockUser.displayName).thenReturn('Test User');

        expect(
          dataSource.userChanges(),
          emitsInOrder([
            isA<AuthUserModel>()
                .having((u) => u.uid, 'uid', 'test_uid')
                .having((u) => u.email, 'email', 'test@example.com')
                .having((u) => u.isEmailVerified, 'isEmailVerified', true)
                .having((u) => u.displayName, 'displayName', 'Test User'),
          ]),
        );
      });

      test('should emit null when Firebase emits null', () {
        when(mockFirebaseAuth.userChanges())
            .thenAnswer((_) => Stream.value(null));

        expect(dataSource.userChanges(), emits(null));
      });

      test('should handle edge case with null email', () {
        when(mockFirebaseAuth.userChanges())
            .thenAnswer((_) => Stream.value(mockUser));
        when(mockUser.uid).thenReturn('test_uid');
        when(mockUser.email).thenReturn(null);

        expect(dataSource.userChanges(), emits(null));
      });
    });
  });
}
