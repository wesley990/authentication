import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:logging/logging.dart';

class UserChangesUseCase implements StreamUseCase<AuthUser?> {
  final IAuthUserRepository repository;
  final Logger _logger = Logger('UserChangesUseCase');

  UserChangesUseCase(this.repository);

  @override
  Stream<AuthUser?> execute() {
    _logger.info('Executing UserChangesUseCase');
    AuthUser? previousUser;
    return repository.userChanges().map((user) {
      if (user != previousUser) {
        if (user != null) {
          _logger.info(
              'User state changed: ${user.email}, isEmailVerified: ${user.isEmailVerified}');
        } else {
          _logger.info('User signed out');
        }
        previousUser = user;
      }
      return user;
    });
  }

  /// Executes the use case to observe changes in the authenticated user state.
  ///
  /// Logs the execution process and handles errors by logging them and rethrowing.
  /// Returns a [Stream] of [AuthUser?] which emits the current authenticated user or `null` if no user is authenticated.
  @override
  Stream<AuthUser?> call() {
    try {
      _logger.info('Starting user changes stream');
      return execute();
    } catch (e) {
      _logger.severe('Error in $runtimeType: ${e.toString()}');
      rethrow;
    }
  }
}
