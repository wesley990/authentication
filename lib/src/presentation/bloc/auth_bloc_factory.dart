import 'package:authentication/authentication.dart';

class AuthBlocFactory {
  static AuthBloc create({IAuthDataSource? dataSource}) {
    final IAuthUserRepository repository =
        AuthuserRepositoryImpl(dataSource ?? FirebaseIAuthDataSource());

    return AuthBloc(
      getCurrentUserUseCase: GetCurrentUserUseCase(repository),
      userChangesUseCase: UserChangesUseCase(repository),
      signInUseCase: SignInUseCase(repository),
      signOutUseCase: SignOutUseCase(repository),
      signUpUseCase: SignUpUseCase(repository),
      sendEmailVerificationUseCase: SendEmailVerificationUseCase(repository),
    );
  }
}
