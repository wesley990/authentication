import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:logging/logging.dart';

/// Use case for signing up a new user with email and password.
class SignUpUseCase implements ParamsUseCase<AuthUser, SignUpParams> {
  /// Repository for authentication-related operations.
  final IAuthUserRepository repository;

  /// Logger for logging information and warnings.
  final Logger _logger = Logger('SignUpUseCase');

  /// Creates an instance of [SignUpUseCase].
  ///
  /// [repository] is the repository for authentication-related operations.
  SignUpUseCase(this.repository);

  /// Signs up a new user with the given email and password.
  ///
  /// [params] contains the email and password for signing up.
  ///
  /// Returns an [AuthUser] if the sign-up is successful, otherwise throws an [ArgumentError] or [AuthException].
  @override
  Future<AuthUser> execute(SignUpParams params) async {
    _logger
        .info('Executing use case: $runtimeType with email: ${params.email}');
    final user = await repository.signUpWithCredential(
        email: params.email, password: params.password);
    _logger.info('User signed up successfully: ${user.email}');

    return user;
  }

  @override
  Future<AuthUser> call(SignUpParams params) async {
    try {
      return await execute(params);
    } catch (e) {
      _logger.severe(
          'Error in $runtimeType: ${e is AuthException ? "AuthException: " : ""}${e.toString()}');
      rethrow;
    }
  }
}
