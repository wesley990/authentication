import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:logging/logging.dart';

/// Use case for sending a verification email to the currently signed-in user.
class SendEmailVerificationUseCase implements NoParamsUseCase<void> {
  /// Repository for authentication-related operations.
  final IAuthUserRepository repository;

  /// Logger for logging information and warnings.
  final Logger _logger = Logger('SendEmailVerificationUseCase');

  /// Creates an instance of [SendEmailVerificationUseCase].
  ///
  /// [repository] is the repository for authentication-related operations.
  SendEmailVerificationUseCase(this.repository);

  /// Sends a verification email to the currently signed-in user.
  ///
  /// Throws an [AuthException] if no user is signed in or if sending the email fails.
  @override
  Future<void> execute() async {
    _logger.info('Executing use case: $runtimeType');
    final currentUser = repository.currentUser;
    if (currentUser == null) {
      _logger.warning(
          'Attempt to send verification email when no user is signed in');
      throw AuthException('no-user-signed-in');
    }

    if (currentUser.isEmailVerified) {
      _logger.info('User email is already verified: ${currentUser.email}');
      return;
    }

    _logger.info('Sending verification email to: ${currentUser.email}');
    await repository.sendEmailVerification();
    _logger.info('Verification email sent successfully');
  }

  /// Executes the use case to send a verification email to the currently signed-in user.
  ///
  /// Logs the execution process and the result.
  /// Throws an [AuthException] if sending the email fails.
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
