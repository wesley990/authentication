import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/data/datasources/i_auth_data_source.dart';
import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';

/// Implementation of [IAuthUserRepository] that uses [IAuthDataSource] for authentication operations.
///
/// This class serves as a bridge between the data layer and the domain layer,
/// translating [AuthUserModel] from the data source into [AuthUser] domain entities.
class AuthuserRepositoryImpl implements IAuthUserRepository {
  /// The data source used for authentication operations.
  final IAuthDataSource _dataSource;

  /// Creates a new instance of [AuthuserRepositoryImpl].
  ///
  /// Requires an [IAuthDataSource] to be injected for performing authentication operations.
  ///
  /// Example:
  /// ```dart
  /// final IAuthDataSource = FirebaseIAuthDataSource();
  /// final authRepository = AuthuserRepositoryImpl(IAuthDataSource);
  /// ```
  AuthuserRepositoryImpl(this._dataSource);

  /// Creates a new user account with the provided email and password.
  ///
  /// [email] must be a valid email address.
  /// [password] must meet the minimum security requirements.
  ///
  /// Returns a [Future] that resolves to an [AuthUser] representing the newly created user.
  ///
  /// Throws an [AuthException] if the account creation fails. Possible reasons include:
  /// - The email address is already in use
  /// - The password is too weak
  /// - The email is invalid
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await repository.signUpWithCredential(
  ///     email: 'user@example.com',
  ///     password: 'securePassword123',
  ///   );
  ///   print('User created: ${user.email}');
  /// } on AuthException catch (e) {
  ///   print('Failed to create user: ${e.message}');
  /// }
  /// ```
  @override
  Future<AuthUser> signUpWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.signUpWithCredential(
        email: email,
        password: password,
      );
      return userModel.toAuthUser();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  /// Signs in a user with the provided email and password.
  ///
  /// [email] must be a registered email address.
  /// [password] must be the correct password for the given email.
  ///
  /// Returns a [Future] that resolves to an [AuthUser] representing the signed-in user.
  ///
  /// Throws an [AuthException] if the sign-in fails. Possible reasons include:
  /// - Invalid email or password
  /// - User account has been disabled
  /// - Too many failed sign-in attempts
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   final user = await repository.signInWithCredential(
  ///     email: 'user@example.com',
  ///     password: 'password123',
  ///   );
  ///   print('User signed in: ${user.email}');
  /// } on AuthException catch (e) {
  ///   print('Failed to sign in: ${e.message}');
  /// }
  /// ```
  @override
  Future<AuthUser> signInWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.signInWithCredential(
        email: email,
        password: password,
      );
      return userModel.toAuthUser();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  /// Signs out the currently authenticated user.
  ///
  /// Returns a [Future] that completes when the sign-out process is finished.
  ///
  /// Throws an [AuthException] if the sign-out process fails.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   await repository.signOut();
  ///   print('User signed out successfully');
  /// } on AuthException catch (e) {
  ///   print('Failed to sign out: ${e.message}');
  /// }
  /// ```
  @override
  Future<void> signOut() async {
    try {
      await _dataSource.signOut();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  /// Returns the currently authenticated user, if any.
  ///
  /// Returns null if there is no authenticated user.
  ///
  /// This is a synchronous operation and reflects the current state of authentication.
  ///
  /// Example:
  /// ```dart
  /// final currentUser = repository.currentUser;
  /// if (currentUser != null) {
  ///   print('Current user: ${currentUser.email}');
  /// } else {
  ///   print('No user is currently authenticated');
  /// }
  /// ```
  @override
  AuthUser? get currentUser {
    final currentUserModel = _dataSource.currentUser;
    return currentUserModel?.toAuthUser();
  }

  /// Provides a stream of authentication state changes.
  ///
  /// The stream emits an [AuthUser] when a user signs in or when their details change.
  /// It emits `null` when the user signs out.
  ///
  /// This stream can be used to reactively update the UI based on the authentication state.
  ///
  /// Example:
  /// ```dart
  /// repository.userChanges().listen((user) {
  ///   if (user != null) {
  ///     print('User state changed: ${user.email}');
  ///   } else {
  ///     print('User signed out');
  ///   }
  /// });
  /// ```
  @override
  Stream<AuthUser?> userChanges() {
    return _dataSource
        .userChanges()
        .map((userModel) => userModel?.toAuthUser());
  }

  @override
  Future<void> sendEmailVerification() async {
    try {
      await _dataSource.sendEmailVerification();
    } on AuthException {
      rethrow;
    } catch (e) {
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  // @override
  // Future<void> sendPasswordResetEmail(String email) async {
  //   try {
  //     await _dataSource.sendPasswordResetEmail(email);
  //   } on AuthException {
  //     rethrow;
  //   } catch (e) {
  //     throw AuthException('unknown');
  //   }
  // }

  // @override
  // Future<void> sendEmailVerification() async {
  //   try {
  //     await _dataSource.sendEmailVerification();
  //   } on AuthException {
  //     rethrow;
  //   } catch (e) {
  //     throw AuthException('unknown');
  //   }
  // }

  // @override
  // Future<void> updateUserProfile({String? displayName, String? photoURL}) async {
  //   try {
  //     await _dataSource.updateUserProfile(displayName: displayName, photoURL: photoURL);
  //   } on AuthException {
  //     rethrow;
  //   } catch (e) {
  //     throw AuthException('unknown');
  //   }
  // }
}
