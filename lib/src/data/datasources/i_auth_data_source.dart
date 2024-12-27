import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/data/models/auth_user_model.dart';

/// Abstract class defining the contract for authentication data sources.
///
/// This class outlines the core operations required for user authentication,
/// including sign-in, sign-up, sign-out, and user state management.
abstract interface class IAuthDataSource {
  /// Signs in a user with the provided email and password.
  ///
  /// [email] must be a valid email address.
  /// [password] must be at least 6 characters long.
  ///
  /// Returns an [AuthUserModel] containing the user's ID, email, and other relevant information.
  /// Throws an [AuthException] if sign-in fails, which could be due to:
  /// - Invalid email or password
  /// - User not found
  /// - User account disabled
  Future<AuthUserModel> signInWithCredential({
    required String email,
    required String password,
  });

  /// Creates a new user account with the provided email and password.
  ///
  /// [email] must be a valid email address that is not already in use.
  /// [password] must be at least 8 characters long and meet complexity requirements.
  ///
  /// Returns an [AuthUserModel] for the newly created user.
  /// Throws an [AuthException] if account creation fails, which could be due to:
  /// - Email already in use
  /// - Weak password
  /// - Invalid email format
  Future<AuthUserModel> signUpWithCredential({
    required String email,
    required String password,
  });

  /// Signs out the current user.
  ///
  /// Throws an [AuthException] if sign-out fails.
  Future<void> signOut();

  /// Provides a stream of authentication state changes.
  ///
  /// Emits an [AuthUserModel] when a user signs in or when their details change.
  /// Emits `null` when the user signs out.
  Stream<AuthUserModel?> userChanges();

  /// Returns the current authenticated user, if any.
  ///
  /// Returns `null` if no user is currently authenticated.
  AuthUserModel? get currentUser;

  // @todo: Implement password reset functionality
  // Future<void> sendPasswordResetEmail(String email);

  // @todo: Implement email verification
  Future<void> sendEmailVerification();

  // @todo: Implement user profile update
  // Future<void> updateUserProfile({String? displayName, String? photoURL});

  // @todo: Consider adding social media sign-in methods
  // Future<AuthUserModel> signInWithGoogle();
  // Future<AuthUserModel> signInWithFacebook();

  // @todo: Consider adding token refresh method
  // Future<void> refreshAuthToken();
}
