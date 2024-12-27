import 'package:authentication/src/domain/usecases/i_base_usecases.dart';
import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:authentication/src/domain/repositories/i_authuser_repository.dart';
import 'package:logging/logging.dart';

/// Use case for retrieving the current authenticated user.
class GetCurrentUserUseCase implements SyncNoParamsUseCase<AuthUser?> {
  /// Repository for authentication-related operations.
  final IAuthUserRepository repository;

  /// Logger for logging information and warnings.
  final Logger _logger = Logger('GetCurrentUserUseCase');

  /// Creates an instance of [GetCurrentUserUseCase].
  ///
  /// [repository] is the repository for authentication-related operations.
  GetCurrentUserUseCase(this.repository);

  /// Retrieves the current authenticated user.
  ///
  /// Returns an [AuthUser] if a user is currently authenticated, otherwise returns `null`.
  /// Logs warnings if the user has an empty UID or email.
  @override
  AuthUser? execute() {
    _logger.info('Executing use case: $runtimeType');
    final user = repository.currentUser;

    if (user != null) {
      if (user.uid.isEmpty) {
        _logger.warning('Current user has an empty UID');
      }
      if (user.email.isEmpty) {
        _logger.warning('Current user has an empty email');
      }
      _logger.info('Current user retrieved: ${user.email}');
    } else {
      _logger.info('No current user');
    }

    return user;
  }

  /// Executes the use case to retrieve the current authenticated user.
  ///
  /// Logs the execution process and the result.
  /// Returns an [AuthUser] if a user is currently authenticated, otherwise returns `null`.
  @override
  AuthUser? call() {
    try {
      return execute();
    } catch (e) {
      _logger.severe('Error in $runtimeType: ${e.toString()}');
      rethrow;
    }
  }
}
