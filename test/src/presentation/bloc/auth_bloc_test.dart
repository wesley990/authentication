import 'package:test/test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:authentication/authentication.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  GetCurrentUserUseCase,
  UserChangesUseCase,
  SignInUseCase,
  SignOutUseCase,
  SignUpUseCase,
  SendEmailVerificationUseCase,
])
void main() {
  late AuthBloc authBloc;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockUserChangesUseCase mockUserChangesUseCase;
  late MockSignInUseCase mockSignInUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSendEmailVerificationUseCase mockSendEmailVerificationUseCase;

  setUp(() {
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockUserChangesUseCase = MockUserChangesUseCase();
    mockSignInUseCase = MockSignInUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSendEmailVerificationUseCase = MockSendEmailVerificationUseCase();

    when(mockUserChangesUseCase.call()).thenAnswer((_) => const Stream.empty());

    authBloc = AuthBloc(
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      userChangesUseCase: mockUserChangesUseCase,
      signInUseCase: mockSignInUseCase,
      signOutUseCase: mockSignOutUseCase,
      signUpUseCase: mockSignUpUseCase,
      sendEmailVerificationUseCase: mockSendEmailVerificationUseCase,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is correct', () {
    expect(authBloc.state, const AuthState.unknown());
  });

  group('AuthCheckRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when user is null',
      build: () {
        when(mockGetCurrentUserUseCase.call()).thenReturn(null);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthState>().having(
            (s) => s.status, 'status', AuthenticationStatus.unauthenticated)
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when user is not null',
      build: () {
        final user = AuthUser(uid: '1', email: 'test@test.com');
        when(mockGetCurrentUserUseCase.call()).thenReturn(user);
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthCheckRequested()),
      expect: () => [
        isA<AuthState>()
            .having(
                (s) => s.status, 'status', AuthenticationStatus.authenticated)
            .having((s) => s.user?.email, 'user email', 'test@test.com')
      ],
    );
  });

  group('AuthSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when sign in is successful',
      build: () {
        final user = AuthUser(uid: '1', email: 'test@test.com');
        when(mockSignInUseCase.call(any)).thenAnswer((_) async => user);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having(
                (s) => s.status, 'status', AuthenticationStatus.authenticated)
            .having((s) => s.user?.email, 'user email', 'test@test.com')
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [error] when sign in fails',
      build: () {
        when(mockSignInUseCase.call(any))
            .thenThrow(AuthException('invalid-email'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthenticationStatus.error)
            .having(
                (s) => s.exception?.code, 'error code', ErrorCode.invalidEmail)
      ],
    );
  });

  group('AuthSignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [authenticated] when sign up is successful',
      build: () {
        final user = AuthUser(uid: '1', email: 'test@test.com');
        when(mockSignUpUseCase.call(any)).thenAnswer((_) async => user);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignUpRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having(
                (s) => s.status, 'status', AuthenticationStatus.authenticated)
            .having((s) => s.user?.email, 'user email', 'test@test.com')
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [error] when sign up fails',
      build: () {
        when(mockSignUpUseCase.call(any))
            .thenThrow(AuthException('email-already-in-use'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignUpRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthenticationStatus.error)
            .having((s) => s.exception?.code, 'error code',
                ErrorCode.emailAlreadyInUse)
      ],
    );
  });

  group('AuthSignOutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when sign out is successful',
      build: () {
        when(mockSignOutUseCase.call()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOutRequested()),
      expect: () => [
        isA<AuthState>().having(
            (s) => s.status, 'status', AuthenticationStatus.unauthenticated)
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [error] when sign out fails',
      build: () {
        when(mockSignOutUseCase.call())
            .thenThrow(AuthException('sign-out-failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOutRequested()),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthenticationStatus.error)
            .having(
                (s) => s.exception?.code, 'error code', ErrorCode.signOutFailed)
      ],
    );
  });

  group('UserChanges', () {
    test('listens to user changes and adds AuthCheckRequested event', () async {
      final user = AuthUser(uid: '1', email: 'test@test.com');
      when(mockUserChangesUseCase.call()).thenAnswer((_) => Stream.value(user));
      when(mockGetCurrentUserUseCase.call()).thenReturn(user);

      authBloc = AuthBloc(
        getCurrentUserUseCase: mockGetCurrentUserUseCase,
        userChangesUseCase: mockUserChangesUseCase,
        signInUseCase: mockSignInUseCase,
        signOutUseCase: mockSignOutUseCase,
        signUpUseCase: mockSignUpUseCase,
        sendEmailVerificationUseCase: mockSendEmailVerificationUseCase,
      );

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthState>()
              .having(
                  (s) => s.status, 'status', AuthenticationStatus.authenticated)
              .having((s) => s.user?.email, 'user email', 'test@test.com')
        ]),
      );
    });
  });

  group('Error handling', () {
    blocTest<AuthBloc, AuthState>(
      'emits [error] with unknown error when an unexpected exception occurs',
      build: () {
        when(mockSignInUseCase.call(any))
            .thenThrow(Exception('Unexpected error'));
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthenticationStatus.error)
            .having((s) => s.exception?.code, 'error code', ErrorCode.unknown)
      ],
    );
  });

  group('State transitions', () {
    blocTest<AuthBloc, AuthState>(
      'transitions from unknown to authenticated when user signs in',
      build: () {
        final user = AuthUser(uid: '1', email: 'test@test.com');
        when(mockSignInUseCase.call(any)).thenAnswer((_) async => user);
        return authBloc;
      },
      act: (bloc) => bloc.add(const AuthSignInRequested(
          email: 'test@test.com', password: 'password')),
      expect: () => [
        isA<AuthState>()
            .having(
                (s) => s.status, 'status', AuthenticationStatus.authenticated)
            .having((s) => s.user?.email, 'user email', 'test@test.com')
      ],
      verify: (bloc) {
        expect(bloc.state.status, AuthenticationStatus.authenticated);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'transitions from authenticated to unauthenticated when user signs out',
      seed: () =>
          AuthState.authenticated(AuthUser(uid: '1', email: 'test@test.com')),
      build: () {
        when(mockSignOutUseCase.call()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthSignOutRequested()),
      expect: () => [
        isA<AuthState>().having(
            (s) => s.status, 'status', AuthenticationStatus.unauthenticated)
      ],
      verify: (bloc) {
        expect(bloc.state.status, AuthenticationStatus.unauthenticated);
      },
    );
  });
}
