import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/data/models/auth_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logging/logging.dart';
import 'i_auth_data_source.dart';

/// A Firebase implementation of [IAuthDataSource].
///
/// This class uses Firebase Authentication to handle all authentication operations.
/// It translates Firebase-specific operations and errors into application-specific
/// models and exceptions.
class FirebaseIAuthDataSource implements IAuthDataSource {
  final FirebaseAuth _firebaseAuth;
  final _logger = Logger('FirebaseIAuthDataSource');

  /// Creates an instance of [FirebaseIAuthDataSource].
  ///
  /// If [firebaseAuth] is not provided, the default instance of [FirebaseAuth] is used.
  FirebaseIAuthDataSource({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  /// Converts a [User] from Firebase to an [AuthUserModel].
  ///
  /// Returns `null` if the [user] or [user.email] is `null`.
  AuthUserModel? _userFromFirebase(User? user) {
    if (user == null || user.email == null) return null;
    return AuthUserModel(
      uid: user.uid,
      email: user.email!,
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws an [AuthException] if the user creation fails.
  ///
  /// Returns an [AuthUserModel] representing the newly created user.
  @override
  Future<AuthUserModel> signUpWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebase(credential.user);
      if (user == null) {
        _logger.severe('Error creating user: user is null');
        throw AuthException(ErrorCode.unknown.name);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      _logger.severe('Unknown error during signing up: ${e.toString()}');
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  /// Signs in a user with the provided [email] and [password].
  ///
  /// Throws an [AuthException] if the sign-in fails.
  ///
  /// Returns an [AuthUserModel] representing the signed-in user.
  @override
  Future<AuthUserModel> signInWithCredential({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = _userFromFirebase(credential.user);
      if (user == null) {
        _logger.severe('Error signing in: user is null');
        throw AuthException(ErrorCode.unknown.name);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      _logger.severe('Unknown error during signing in: ${e.toString()}');
      throw AuthException(ErrorCode.unknown.name);
    }
  }

  /// Gets the currently signed-in user.
  ///
  /// Returns an [AuthUserModel] representing the current user, or `null` if no user is signed in.
  @override
  AuthUserModel? get currentUser =>
      _userFromFirebase(_firebaseAuth.currentUser);

  /// Signs out the current user.
  ///
  /// Throws an [AuthException] if the sign-out fails.
  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      _logger.severe('Unknown error during signing out: ${e.toString()}');
      throw AuthException(ErrorCode.signOutFailed.name);
    }
  }

  /// A stream of authentication state changes.
  ///
  /// Emits an [AuthUserModel] representing the current user, or `null` if no user is signed in.
  @override
  Stream<AuthUserModel?> userChanges() {
    return _firebaseAuth.userChanges().map((firebaseUser) {
      try {
        return _userFromFirebase(firebaseUser);
      } catch (e) {
        // Log the error or handle it as appropriate for your app
        _logger.severe(
            'Unknown error during getting user changes ${e.toString()}');
        return null;
      }
    });
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      _logger.severe('Error sending email verification: no user is signed in');
      throw AuthException(ErrorCode.noUserSignedIn.name);
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.code);
    } catch (e) {
      _logger.severe(
          'Unknown error during sending email verification: ${e.toString()}');
      throw AuthException(ErrorCode.unknown.name);
    }
  }
}
