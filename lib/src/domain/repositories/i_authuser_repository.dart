import 'package:authentication/src/domain/entities/auth_user.dart';

/// Repository interface for handling authentication-related operations.
abstract interface class IAuthUserRepository {
  /// Signs in a user with the given email and password.
  ///
  /// [email] is the user's email address.
  /// [password] is the user's password.
  ///
  /// Returns an [AuthUser] if the sign-in is successful, otherwise throws an [AuthException].
  Future<AuthUser> signInWithCredential({
    required String email,
    required String password,
  });

  /// Signs up a new user with the given email and password.
  ///
  /// [email] is the user's email address.
  /// [password] is the user's password.
  ///
  /// Returns an [AuthUser] if the sign-up is successful, otherwise throws an [AuthException].
  Future<AuthUser> signUpWithCredential({
    required String email,
    required String password,
  });

  /// Signs out the currently signed-in user.
  ///
  /// Throws an [AuthException] if sign out fails.
  Future<void> signOut();

  /// A stream that emits the current authenticated user whenever the user changes.
  ///
  /// Returns a [Stream] of [AuthUser?] which emits the current authenticated user or `null` if no user is authenticated.
  Stream<AuthUser?> userChanges();

  /// Gets the currently authenticated user
  ///
  /// Returns an [AuthUser] if a user is currently authenticated, otherwise null
  AuthUser? get currentUser;

  /// Sends a password reset email to the given email address
  ///
  /// Throws an [AuthException] if the operation fails
  // Future<void> sendPasswordResetEmail(String email);

  /// Verifies the email of the current user
  ///
  /// Throws an [AuthException] if the operation fails or if no user is signed in
  Future<void> sendEmailVerification();

  /// Updates the user's profile information
  ///
  /// Throws an [AuthException] if the operation fails or if no user is signed in
  // Future<void> updateProfile({String? displayName, String? photoUrl});

  /// Refreshes the current user's authentication token
  ///
  /// Throws an [AuthException] if the operation fails or if no user is signed in
  // Future<void> refreshToken();

  /// Signs in a user with Google
  ///
  /// Returns an [AuthUser] if the sign-in is successful, otherwise throws an [AuthException]
  // Future<AuthUser> signInWithGoogle();

  /// Links the current user account with Google
  ///
  /// Throws an [AuthException] if the operation fails or if no user is signed in
  // Future<void> linkWithGoogle();

  /// Unlinks the current user account from Google
  ///
  /// Throws an [AuthException] if the operation fails or if no user is signed in
  // Future<void> unlinkFromGoogle();
}
