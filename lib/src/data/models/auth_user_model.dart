import 'package:authentication/src/domain/entities/auth_user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_user_model.g.dart';

/// A model class representing an authenticated user.
///
/// This class includes methods for serialization and deserialization.
@JsonSerializable()
class AuthUserModel {
  final String _uid;
  final String _email;
  final String? _displayName;
  final bool? _isEmailVerified;

  /// Creates an instance of [AuthUserModel].
  ///
  /// The [uid] and [email] fields are required. The [displayName] field is optional.
  /// The [isEmailVerified] field defaults to `false`.
  const AuthUserModel({
    required String uid,
    required String email,
    String? displayName,
    bool isEmailVerified = false,
  })  : _uid = uid,
        _email = email,
        _displayName = displayName,
        _isEmailVerified = isEmailVerified;

  /// The unique identifier of the user.
  String get uid => _uid;

  /// The email address of the user.
  String get email => _email;

  /// The display name of the user, if available.
  String? get displayName => _displayName;

  /// Whether the user's email is verified.
  bool get isEmailVerified => _isEmailVerified ?? false;

  /// Creates an instance of [AuthUserModel] from a JSON object.
  ///
  /// The [json] parameter must be a map containing the user data.
  factory AuthUserModel.fromJson(Map<String, Object> json) =>
      _$AuthUserModelFromJson(json);

  /// Converts this [AuthUserModel] to a JSON object.
  ///
  /// Returns a map containing the user data.
  Map<String, Object?> toJson() => _$AuthUserModelToJson(this);

  /// Converts this [AuthUserModel] to an [AuthUser] entity.
  ///
  /// Returns an [AuthUser] with the same properties as this model.
  AuthUser toAuthUser() => AuthUser(
        uid: _uid,
        email: _email,
        displayName: _displayName,
        isEmailVerified: _isEmailVerified ?? false,
      );
}
