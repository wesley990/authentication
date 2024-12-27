// Mocks generated by Mockito 5.4.4 from annotations
// in authentication/test/src/domain/usecases/signin_usecase_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:authentication/src/domain/entities/auth_user.dart' as _i2;
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAuthUser_0 extends _i1.SmartFake implements _i2.AuthUser {
  _FakeAuthUser_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IAuthUserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAuthUserRepository extends _i1.Mock
    implements _i3.IAuthUserRepository {
  MockIAuthUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.AuthUser> signInWithCredential({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signInWithCredential,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.AuthUser>.value(_FakeAuthUser_0(
          this,
          Invocation.method(
            #signInWithCredential,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.AuthUser>);

  @override
  _i4.Future<_i2.AuthUser> signUpWithCredential({
    required String? email,
    required String? password,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #signUpWithCredential,
          [],
          {
            #email: email,
            #password: password,
          },
        ),
        returnValue: _i4.Future<_i2.AuthUser>.value(_FakeAuthUser_0(
          this,
          Invocation.method(
            #signUpWithCredential,
            [],
            {
              #email: email,
              #password: password,
            },
          ),
        )),
      ) as _i4.Future<_i2.AuthUser>);

  @override
  _i4.Future<void> signOut() => (super.noSuchMethod(
        Invocation.method(
          #signOut,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Stream<_i2.AuthUser?> userChanges() => (super.noSuchMethod(
        Invocation.method(
          #userChanges,
          [],
        ),
        returnValue: _i4.Stream<_i2.AuthUser?>.empty(),
      ) as _i4.Stream<_i2.AuthUser?>);

  @override
  _i4.Future<void> sendEmailVerification() => (super.noSuchMethod(
        Invocation.method(
          #sendEmailVerification,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
