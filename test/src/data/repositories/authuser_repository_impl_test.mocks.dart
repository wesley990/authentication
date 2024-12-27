// Mocks generated by Mockito 5.4.4 from annotations
// in authentication/test/src/data/repositories/authuser_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:authentication/src/data/datasources/i_auth_data_source.dart'
    as _i3;
import 'package:authentication/src/data/models/auth_user_model.dart' as _i2;
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

class _FakeAuthUserModel_0 extends _i1.SmartFake implements _i2.AuthUserModel {
  _FakeAuthUserModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IAuthDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockIAuthDataSource extends _i1.Mock implements _i3.IAuthDataSource {
  MockIAuthDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.AuthUserModel> signInWithCredential({
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
        returnValue: _i4.Future<_i2.AuthUserModel>.value(_FakeAuthUserModel_0(
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
      ) as _i4.Future<_i2.AuthUserModel>);

  @override
  _i4.Future<_i2.AuthUserModel> signUpWithCredential({
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
        returnValue: _i4.Future<_i2.AuthUserModel>.value(_FakeAuthUserModel_0(
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
      ) as _i4.Future<_i2.AuthUserModel>);

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
  _i4.Stream<_i2.AuthUserModel?> userChanges() => (super.noSuchMethod(
        Invocation.method(
          #userChanges,
          [],
        ),
        returnValue: _i4.Stream<_i2.AuthUserModel?>.empty(),
      ) as _i4.Stream<_i2.AuthUserModel?>);

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
