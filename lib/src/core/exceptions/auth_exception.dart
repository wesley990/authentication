import 'dart:convert';

/// Custom exception class for authentication-related errors.
class AuthException implements Exception {
  /// The type of authentication error.
  final ErrorCode code;

  /// A human-readable error message.
  final String message;

  /// Private constructor for creating an [AuthException] with a specific [ErrorCode] and message.
  AuthException._(this.code, this.message);

  /// Factory constructor to create [AuthException] from a string error code.
  factory AuthException(String errorCode) {
    final code = _stringToErrorCode(errorCode);
    return AuthException._(code, '${code.numericCode}: ${code.message}');
  }

  /// Returns a string representation of the [AuthException].
  @override
  String toString() => 'AuthException: [${code.name}] $message';

  /// Converts a string error code to [ErrorCode] enum.
  static ErrorCode _stringToErrorCode(String code) {
    return ErrorCode.values.firstWhere(
      (e) => e.name.toLowerCase() == code.replaceAll('-', ''),
      orElse: () => ErrorCode.unknown,
    );
  }

  /// Serializes the [AuthException] to a JSON map.
  Map<String, Object> toJson() => {
        'code': code.name,
        'message': message,
        'numericCode': code.numericCode,
      };

  /// Creates an [AuthException] from a JSON map.
  factory AuthException.fromJson(Map<String, Object> json) {
    final code = _stringToErrorCode(json['code'] as String);
    return AuthException._(code, json['message'] as String);
  }

  /// Serializes the [AuthException] to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  /// Creates an [AuthException] from a JSON string.
  factory AuthException.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return AuthException.fromJson(json);
  }
}

/// Enum representing different types of authentication errors.
enum ErrorCode {
  invalidEmail(1000),
  userDisabled(1001),
  userNotFound(1002),
  wrongPassword(1003),
  emailAlreadyInUse(1004),
  weakPassword(1005),
  operationNotAllowed(1006),
  tooManyRequests(1007),
  emailNotVerified(1008),
  expiredActionCode(1009),
  invalidActionCode(1010),
  googleSignInFailed(1011),
  googleSignInCancelled(1012),
  userTokenExpired(1013),
  tokenRevoked(1014),
  networkRequestFailed(1015),
  invalidCredential(1016),
  signOutFailed(1017),
  noUserSignedIn(1018),
  emailVerificationThrottled(1019),
  unknown(9999);

  final int numericCode;

  const ErrorCode(this.numericCode);
}

/// Extension on [ErrorCode] to provide human-readable messages.
extension ErrorCodeExtension on ErrorCode {
  String get message {
    switch (this) {
      case ErrorCode.invalidEmail:
        return 'The email address is not valid.';
      case ErrorCode.userDisabled:
        return 'The user account has been disabled.';
      case ErrorCode.userNotFound:
        return 'No user found with this email.';
      case ErrorCode.wrongPassword:
        return 'The password is incorrect.';
      case ErrorCode.emailAlreadyInUse:
        return 'The email address is already in use.';
      case ErrorCode.weakPassword:
        return 'The password is too weak.';
      case ErrorCode.operationNotAllowed:
        return 'This operation of email/password accounts are not enabled.';
      case ErrorCode.tooManyRequests:
        return 'Too many requests. Try again later.';
      case ErrorCode.emailNotVerified:
        return 'Email address not verified.';
      case ErrorCode.expiredActionCode:
        return 'The action code has expired.';
      case ErrorCode.invalidActionCode:
        return 'The action code is invalid.';
      case ErrorCode.googleSignInFailed:
        return 'Google Sign-In failed.';
      case ErrorCode.googleSignInCancelled:
        return 'Google Sign-In was cancelled.';
      case ErrorCode.userTokenExpired:
        return 'The user\'s refresh token is no longer valid. The user must sign in again.';
      case ErrorCode.tokenRevoked:
        return 'The user\'s credential has been revoked.';
      case ErrorCode.invalidCredential:
        return 'The password is invalid for the given email, or the account corresponding to the email does not have a password set.';
      case ErrorCode.networkRequestFailed:
        return 'A network error occurred. Please check your internet connection.';
      case ErrorCode.signOutFailed:
        return 'Sign out failed. The user is still signed in.';
      case ErrorCode.noUserSignedIn:
        return 'No user is currently signed in.';
      case ErrorCode.emailVerificationThrottled:
        return 'Email verification requests have been throttled. Please wait before sending another request.';
      case ErrorCode.unknown:
        return 'An unknown error occurred.';
    }
  }
}
