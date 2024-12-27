import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/data/datasources/i_auth_data_source.dart';
import 'package:authentication/src/data/models/auth_user_model.dart';
import 'package:authentication/src/data/repositories/authuser_repository_impl.dart';
import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'authuser_repository_impl_test.mocks.dart';

@GenerateMocks([IAuthDataSource])
void main() {
  late AuthuserRepositoryImpl repository;
  late MockIAuthDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockIAuthDataSource();
    repository = AuthuserRepositoryImpl(mockDataSource);
  });

  group('signUpWithCredential', () {
    test('should return AuthUser when the call to data source is successful',
        () async {
      final authUserModel =
          AuthUserModel(uid: '123', email: 'test@example.com');
      when(mockDataSource.signUpWithCredential(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => authUserModel);

      final result = await repository.signUpWithCredential(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, isA<AuthUser>());
      expect(result.uid, authUserModel.uid);
      expect(result.email, authUserModel.email);
    });

    test('should throw AuthException when the call to data source fails',
        () async {
      when(mockDataSource.signUpWithCredential(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(AuthException('email-already-in-use'));

      expect(
        () => repository.signUpWithCredential(
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signInWithCredential', () {
    test('should return AuthUser when the call to data source is successful',
        () async {
      final authUserModel =
          AuthUserModel(uid: '123', email: 'test@example.com');
      when(mockDataSource.signInWithCredential(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => authUserModel);

      final result = await repository.signInWithCredential(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(result, isA<AuthUser>());
      expect(result.uid, authUserModel.uid);
      expect(result.email, authUserModel.email);
    });

    test('should throw AuthException when the call to data source fails',
        () async {
      when(mockDataSource.signInWithCredential(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(AuthException('user-not-found'));

      expect(
        () => repository.signInWithCredential(
          email: 'test@example.com',
          password: 'password123',
        ),
        throwsA(isA<AuthException>()),
      );
    });
  });

  group('signOut', () {
    test(
        'should complete successfully when the call to data source is successful',
        () async {
      when(mockDataSource.signOut()).thenAnswer((_) async {});

      expect(repository.signOut(), completes);
    });

    test('should throw AuthException when the call to data source fails',
        () async {
      when(mockDataSource.signOut())
          .thenThrow(AuthException('sign-out-failed'));

      expect(repository.signOut(), throwsA(isA<AuthException>()));
    });
  });

  group('currentUser', () {
    test('should return AuthUser when there is a current user', () {
      final authUserModel =
          AuthUserModel(uid: '123', email: 'test@example.com');
      when(mockDataSource.currentUser).thenReturn(authUserModel);

      final result = repository.currentUser;

      expect(result, isA<AuthUser>());
      expect(result?.uid, authUserModel.uid);
      expect(result?.email, authUserModel.email);
    });

    test('should return null when there is no current user', () {
      when(mockDataSource.currentUser).thenReturn(null);

      final result = repository.currentUser;

      expect(result, isNull);
    });
  });

  group('userChanges', () {
    test('should emit AuthUser when the data source emits AuthUserModel', () {
      final authUserModel =
          AuthUserModel(uid: '123', email: 'test@example.com');
      when(mockDataSource.userChanges())
          .thenAnswer((_) => Stream.value(authUserModel));

      expect(
        repository.userChanges(),
        emitsInOrder([
          isA<AuthUser>(),
          emitsDone,
        ]),
      );
    });

    test('should emit null when the data source emits null', () {
      when(mockDataSource.userChanges()).thenAnswer((_) => Stream.value(null));

      expect(
        repository.userChanges(),
        emitsInOrder([
          null,
          emitsDone,
        ]),
      );
    });
  });

  // group('sendPasswordResetEmail', () {
  //   test(
  //       'should complete successfully when the call to data source is successful',
  //       () async {
  //     when(mockDataSource.sendPasswordResetEmail(any)).thenAnswer((_) async {});

  //     expect(repository.sendPasswordResetEmail('test@example.com'), completes);
  //   });

  //   test('should throw AuthException when the call to data source fails',
  //       () async {
  //     when(mockDataSource.sendPasswordResetEmail(any))
  //         .thenThrow(AuthException('invalid-email'));

  //     expect(
  //       () => repository.sendPasswordResetEmail('test@example.com'),
  //       throwsA(isA<AuthException>()),
  //     );
  //   });
  // });

  // group('sendEmailVerification', () {
  //   test(
  //       'should complete successfully when the call to data source is successful',
  //       () async {
  //     when(mockDataSource.sendEmailVerification()).thenAnswer((_) async {});

  //     expect(repository.sendEmailVerification(), completes);
  //   });

  //   test('should throw AuthException when the call to data source fails',
  //       () async {
  //     when(mockDataSource.sendEmailVerification())
  //         .thenThrow(AuthException('user-not-found'));

  //     expect(repository.sendEmailVerification(), throwsA(isA<AuthException>()));
  //   });
  // });

  // group('updateUserProfile', () {
  //   test(
  //       'should complete successfully when the call to data source is successful',
  //       () async {
  //     when(mockDataSource.updateUserProfile(
  //       displayName: anyNamed('displayName'),
  //       photoURL: anyNamed('photoURL'),
  //     )).thenAnswer((_) async {});

  //     expect(
  //         repository.updateUserProfile(
  //             displayName: 'New Name', photoURL: 'new_photo_url'),
  //         completes);
  //   });

  //   test('should throw AuthException when the call to data source fails',
  //       () async {
  //     when(mockDataSource.updateUserProfile(
  //       displayName: anyNamed('displayName'),
  //       photoURL: anyNamed('photoURL'),
  //     )).thenThrow(AuthException('network-request-failed'));

  //     expect(
  //       () => repository.updateUserProfile(
  //           displayName: 'New Name', photoURL: 'new_photo_url'),
  //       throwsA(isA<AuthException>()),
  //     );
  //   });
  // });
}
