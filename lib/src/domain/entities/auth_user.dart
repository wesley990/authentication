import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Represents a user in the authentication system.
@freezed
sealed class AuthUser with _$AuthUser {
  /// Creates an instance of [AuthUser].
  ///
  /// [uid] is the unique identifier for the user.
  /// [email] is the email address of the user.
  /// [displayName] is the display name of the user (optional).
  /// [isEmailVerified] indicates if the user's email is verified (default is false).
  const factory AuthUser({
    required String uid,
    required String email,
    String? displayName,
    @Default(false) bool isEmailVerified,
  }) = _AuthUser;

  /// Private constructor for custom getters.
  const AuthUser._();

  /// Returns `true` if the user has a non-null and non-empty display name.
  bool get hasCompletedProfile =>
      displayName != null && displayName!.isNotEmpty;

  /// Returns the domain part of the user's email address.
  String get emailDomain => email.split('@').last;

  /// A constant representing an empty [AuthUser].
  ///
  /// This can be used as a placeholder or default value.
  static const empty = AuthUser(uid: '', email: '');
}
