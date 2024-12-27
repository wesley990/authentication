# Authentication Package

A clean architecture Flutter authentication package that provides Firebase authentication integration with BLoC pattern state management.

## Features

- 🔐 Firebase Authentication integration
- 📱 User registration and login
- 🔄 Password reset functionality
- ⚡ BLoC pattern state management
- ✨ Clean architecture principles
- 🧪 Comprehensive test coverage

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  authentication:
    git:
      url: https://github.com/wesley990/authentication.git
      ref: main
```

## Requirements

- Dart SDK: ">=3.6.0"
- Flutter: ">=1.17.0"
- Firebase project setup with Firebase Auth enabled

## Usage

1. Initialize Firebase in your main.dart:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

2. Basic authentication example:

```dart
// Create an authentication bloc
final authBloc = AuthenticationBloc();

// Login
authBloc.add(const AuthenticationEvent.signInWithEmailAndPassword(
  email: 'user@example.com',
  password: 'password123'
));

// Register
authBloc.add(const AuthenticationEvent.signUpWithEmailAndPassword(
  email: 'newuser@example.com',
  password: 'newpassword123'
));

// Reset password
authBloc.add(const AuthenticationEvent.resetPassword(
  email: 'user@example.com'
));

// Logout
authBloc.add(const AuthenticationEvent.signOut());
```

## State Management

The package uses `flutter_bloc` for state management with the following states:

- `AuthenticationInitial` - Initial state
- `AuthenticationLoading` - During authentication processes
- `AuthenticationAuthenticated` - User is authenticated
- `AuthenticationUnauthenticated` - User is not authenticated
- `AuthenticationFailure` - Authentication process failed

## Testing

Run the tests using:

```bash
flutter test
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.
