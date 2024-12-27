import 'dart:async';

import 'package:authentication/authentication.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final UserChangesUseCase userChangesUseCase;
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final SignUpUseCase signUpUseCase;
  final SendEmailVerificationUseCase sendEmailVerificationUseCase;

  StreamSubscription<AuthUser?>? _userSubscription;
  DateTime? _lastEmailVerificationSent;

  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.userChangesUseCase,
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.signUpUseCase,
    required this.sendEmailVerificationUseCase,
  }) : super(const AuthState.unknown()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthSendEmailVerificationRequested>(
        _onAuthSendEmailVerificationRequested);

    _userSubscription = userChangesUseCase().listen(
      (user) => add(AuthCheckRequested()),
    );
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final user = getCurrentUserUseCase();
    if (user != null) {
      if (user.isEmailVerified) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unverified(user));
      }
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onAuthSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await signInUseCase(
          SignInParams(email: event.email, password: event.password));
      if (user.isEmailVerified) {
        emit(AuthState.authenticated(user));
      } else {
        emit(AuthState.unverified(user));
      }
    } on AuthException catch (e) {
      emit(AuthState.error(e));
    } catch (e) {
      emit(AuthState.error(AuthException(ErrorCode.unknown.name)));
    }
  }

  Future<void> _onAuthSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await signUpUseCase(
          SignUpParams(email: event.email, password: event.password));
      await _sendEmailVerification(emit);
      emit(AuthState.unverified(user));
    } on AuthException catch (e) {
      emit(AuthState.error(e));
    } catch (e) {
      emit(AuthState.error(AuthException(ErrorCode.unknown.name)));
    }
  }

  Future<void> _onAuthSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      await signOutUseCase();
      emit(const AuthState.unauthenticated());
    } on AuthException catch (e) {
      emit(AuthState.error(e));
    } catch (e) {
      emit(AuthState.error(AuthException(ErrorCode.unknown.name)));
    }
  }

  Future<void> _onAuthSendEmailVerificationRequested(
    AuthSendEmailVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _sendEmailVerification(emit);
  }

  Future<void> _sendEmailVerification(Emitter<AuthState> emit) async {
    if (_lastEmailVerificationSent != null &&
        DateTime.now().difference(_lastEmailVerificationSent!) <
            const Duration(minutes: 2)) {
      emit(AuthState.error(AuthException('email-verification-throttled')));
      return;
    }

    try {
      await sendEmailVerificationUseCase();
      _lastEmailVerificationSent = DateTime.now();
      emit(AuthState.unverified(state.user!));
    } on AuthException catch (e) {
      emit(AuthState.error(e));
    } catch (e) {
      emit(AuthState.error(AuthException(ErrorCode.unknown.name)));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
