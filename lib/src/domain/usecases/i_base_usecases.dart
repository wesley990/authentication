/// Abstract class representing a use case that takes parameters.
///
/// This class serves as a base for implementing use cases that require input parameters.
///
///
/// Type parameters:
/// * [Type]: The return type of the use case.
/// * [Params]: The type of the input parameters.
///
/// Example:
/// ```dart
/// class GetUserUseCase extends ParamsUseCase<User, int> {
///   @override
///   Future<User> call(int userId) async {
///     Implementation to fetch user by ID
///   }
/// }
/// ```
abstract interface class ParamsUseCase<Type, Params> {
  /// Executes the use case with the given parameters.
  ///
  /// This method should be implemented by subclasses to define the core logic of the use case.
  ///
  /// [params] are the parameters required to execute the use case.
  ///
  /// Returns a [Future] of type [Type] which is the result of the use case execution.
  Future<Type> call(Params params);

  /// Executes the use case and handles logging and error handling.
  ///
  /// This method wraps the [call] method, adding logging and error handling.
  ///
  /// [params] are the parameters required to execute the use case.
  ///
  /// Returns a [Future] of type [Type] which is the result of the use case execution.
  /// Logs the execution process and handles errors by logging them and rethrowing.
  Future<Type> execute(Params params);
}

/// Abstract class representing a use case that does not take parameters.
///
/// This class serves as a base for implementing use cases that don't require input parameters.
/// It provides a standard structure for executing use cases with logging and error handling.
///
/// Type parameter:
/// * [Type]: The return type of the use case.
///
/// Example:
/// ```dart
/// class GetAllUsersUseCase extends NoParamsUseCase<List<User>> {
///   @override
///   Future<List<User>> call() async {
///     Implementation to fetch all users
///   }
/// }
/// ```
abstract interface class NoParamsUseCase<Type> {
  /// Executes the use case without any parameters.
  ///
  /// This method should be implemented by subclasses to define the core logic of the use case.
  ///
  /// Returns a [Future] of type [Type] which is the result of the use case execution.
  Future<Type> call();

  /// Executes the use case and handles logging and error handling.
  ///
  /// This method wraps the [call] method, adding logging and error handling.
  ///
  /// Returns a [Future] of type [Type] which is the result of the use case execution.
  /// Logs the execution process and handles errors by logging them and rethrowing.
  Future<Type> execute();
}

/// Abstract class representing a synchronous use case that does not take parameters.
///
/// This class serves as a base for implementing synchronous use cases that don't require input parameters.
/// It provides a standard structure for executing use cases with logging and error handling.
///
/// Type parameter:
/// * [Type]: The return type of the use case.
///
/// Example:
/// ```dart
/// class GetCurrentUserIdUseCase extends SyncNoParamsUseCase<int> {
///   @override
///   int call() {
///     Implementation to get current user ID synchronously
///   }
/// }
/// ```
abstract interface class SyncNoParamsUseCase<Type> {
  /// Executes the use case synchronously without any parameters.
  ///
  /// This method should be implemented by subclasses to define the core logic of the use case.
  ///
  /// Returns a value of type [Type] which is the result of the use case execution.
  Type call();

  /// Executes the use case and handles logging and error handling.
  ///
  /// This method wraps the [call] method, adding logging and error handling.
  ///
  /// Returns a value of type [Type] which is the result of the use case execution.
  /// Logs the execution process and handles errors by logging them and rethrowing.
  Type execute();
}

/// Abstract class representing a use case that returns a stream of values.
///
/// This class serves as a base for implementing use cases that produce a stream of results.
/// It provides a standard structure for executing stream-based use cases with logging and error handling.
///
/// Type parameter:
/// * [Type]: The type of values emitted by the stream.
///
/// Example:
/// ```dart
/// class WatchUserUpdatesUseCase extends StreamUseCase<User> {
///   @override
///   Stream<User> call() {
///     Implementation to watch for user updates
///   }
/// }
/// ```
abstract interface class StreamUseCase<Type> {
  /// Executes the use case, returning a stream of values.
  ///
  /// This method should be implemented by subclasses to define the core logic of the use case.
  ///
  /// Returns a [Stream] of type [Type] which emits the results of the use case execution.
  Stream<Type> call();

  /// Executes the use case and handles logging and error handling.
  ///
  /// This method wraps the [call] method, adding logging and error handling.
  ///
  /// Returns a [Stream] of type [Type] which emits the results of the use case execution.
  /// Logs the execution process and handles errors by logging them and rethrowing.
  Stream<Type> execute();
}

/// Class representing the parameters for a sign-in operation.
///
/// This class encapsulates the email and password required for user authentication.
class SignInParams {
  /// The user's email address.
  final String email;

  /// The user's password.
  final String password;

  /// Creates a new instance of [SignInParams].
  ///
  /// [email] and [password] are required parameters.
  SignInParams({required this.email, required this.password});
}

/// Class representing the parameters for a sign-up operation.
///
/// This class encapsulates the email and password required for user registration.
class SignUpParams {
  /// The user's email address.
  final String email;

  /// The user's password.
  final String password;

  /// Creates a new instance of [SignUpParams].
  ///
  /// [email] and [password] are required parameters.
  SignUpParams({required this.email, required this.password});
}
