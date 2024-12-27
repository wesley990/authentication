part of 'auth_bloc.dart';

enum AuthenticationStatus {
  unknown,
  authenticated,
  unauthenticated,
  unverified,
  loading,
  error
}

class AuthState extends Equatable {
  final AuthenticationStatus status;
  final AuthUser? user;
  final AuthException? exception;

  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.user,
    this.exception,
  });

  const AuthState.unknown() : this._();

  const AuthState.authenticated(AuthUser user)
      : this._(status: AuthenticationStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthenticationStatus.unauthenticated);

  const AuthState.unverified(AuthUser user)
      : this._(status: AuthenticationStatus.unverified, user: user);

  const AuthState.loading() : this._(status: AuthenticationStatus.loading);

  const AuthState.error(AuthException exception)
      : this._(status: AuthenticationStatus.error, exception: exception);

  @override
  List<Object?> get props => [status, user, exception];

  @override
  String toString() =>
      'AuthState(status: $status, user: $user, exception: $exception)';
}
