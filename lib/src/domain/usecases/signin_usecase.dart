import 'package:authentication/src/core/exceptions/auth_exception.dart';
import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:logging/logging.dart';

/// Use case for signing in a user with email and password.
class SignInUseCase implements ParamsUseCase<AuthUser, SignInParams> {
  /// Repository for authentication-related operations.
  final IAuthUserRepository repository;

  /// Logger for logging information and warnings.
  final Logger _logger = Logger('SignInUseCase');

  /// Creates an instance of [SignInUseCase].
  ///
  /// [repository] is the repository for authentication-related operations.
  SignInUseCase(this.repository);

  /// Signs in a user with the given email and password.
  ///
  /// [params] contains the email and password for signing in.
  ///
  /// Returns an [AuthUser] if the sign-in is successful, otherwise throws an [ArgumentError] or [AuthException].
  @override
  Future<AuthUser> execute(SignInParams params) async {
    _logger
        .info('Executing use case: $runtimeType with email: ${params.email}');

    final user = await repository.signInWithCredential(
        email: params.email, password: params.password);

    _logger.info('User signed in successfully: ${user.email}');
    return user;
  }

  @override
  Future<AuthUser> call(SignInParams params) async {
    try {
      return await execute(params);
    } catch (e) {
      _logger.severe(
          'Error in $runtimeType: ${e is AuthException ? "AuthException: " : ""}${e.toString()}');
      rethrow;
    }
  }
}
