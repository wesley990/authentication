import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:logging/logging.dart';

/// Use case for signing out the currently authenticated user.
class SignOutUseCase implements NoParamsUseCase<void> {
  /// Repository for authentication-related operations.
  final IAuthUserRepository repository;

  /// Logger for logging information and warnings.
  final Logger _logger = Logger('SignOutUseCase');

  /// Creates an instance of [SignOutUseCase].
  ///
  /// [repository] is the repository for authentication-related operations.
  SignOutUseCase(this.repository);

  /// Signs out the currently authenticated user.
  ///
  /// Logs a warning if no user is signed in.
  /// Logs the email of the user being signed out.
  /// Throws an [AuthException] if sign out fails.
  @override
  Future<void> execute() async {
    _logger.info('Executing use case: $runtimeType');
    final currentUser = repository.currentUser;
    if (currentUser == null) {
      _logger.warning('Attempt to sign out when no user is signed in');
      return; // No need to throw an exception, just return as the end state is achieved
    }

    _logger.info('Signing out user: ${currentUser.email}');
    await repository.signOut();

    // Verify sign out was successful
    if (repository.currentUser != null) {
      _logger.severe('Sign out failed: user is still signed in');
      throw AuthException('sign-out-failed');
    } else {
      _logger.info('User signed out successfully');
    }
  }

  /// Executes the use case to sign out the currently authenticated user.
  ///
  /// Logs the execution process and the result.
  /// Throws an [AuthException] if sign out fails.
  @override
  Future<void> call() async {
    try {
      await execute();
    } catch (e) {
      _logger.severe(
          'Error in $runtimeType: ${e is AuthException ? "AuthException: " : ""}${e.toString()}');
      rethrow;
    }
  }
}
