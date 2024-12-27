import 'dart:convert';

import 'package:authentication/src/data/models/auth_user_model.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../fixtures/fixture_reader.dart';

void main() {
  final Map<String, Object> userFull = jsonDecode(fixture('user_full.json'));
  group('AuthUserModel', () {
    test('should create AuthUserModel instance with required parameters', () {
      final user = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
      );

      expect(user.uid, 'testUID');
      expect(user.email, 'test@example.com');
      expect(user.displayName, isNull);
      expect(user.isEmailVerified, isFalse);
    });

    test('should create AuthUserModel instance with all parameters', () {
      final user = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      expect(user.uid, 'testUID');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.isEmailVerified, isTrue);
    });

    test('should correctly serialize to JSON', () {
      final user = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      final json = user.toJson();

      expect(json, userFull);
    });

    test('should correctly deserialize from JSON', () {
      final user = AuthUserModel.fromJson(userFull);

      expect(user.uid, 'testUID');
      expect(user.email, 'test@example.com');
      expect(user.displayName, 'Test User');
      expect(user.isEmailVerified, isTrue);
    });

    test('should correctly determine if profile is completed', () {
      final incompleteUser = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
      );

      final completeUser = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
        displayName: 'Test User',
      );

      expect(incompleteUser.toAuthUser().hasCompletedProfile, isFalse);
      expect(completeUser.toAuthUser().hasCompletedProfile, isTrue);
    });

    test('should correctly extract email domain', () {
      final user = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
      );

      expect(user.toAuthUser().emailDomain, 'example.com');
    });

    test('should handle empty display name', () {
      final user = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
        displayName: '',
      );

      expect(user.toAuthUser().displayName, isEmpty);
      expect(user.toAuthUser().hasCompletedProfile, isFalse);
    });

    test('should handle different email domains', () {
      final user1 = AuthUserModel(uid: 'uid1', email: 'test@gmail.com');
      final user2 = AuthUserModel(uid: 'uid2', email: 'test@company.co.uk');

      expect(user1.toAuthUser().emailDomain, 'gmail.com');
      expect(user2.toAuthUser().emailDomain, 'company.co.uk');
    });

    test('should convert to AuthUser correctly', () {
      final userModel = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
        displayName: 'Test User',
        isEmailVerified: true,
      );

      final authUser = userModel.toAuthUser();

      expect(authUser.uid, 'testUID');
      expect(authUser.email, 'test@example.com');
      expect(authUser.displayName, 'Test User');
      expect(authUser.isEmailVerified, isTrue);
    });

    test('should handle null display name in toAuthUser', () {
      final userModel = AuthUserModel(
        uid: 'testUID',
        email: 'test@example.com',
      );

      final authUser = userModel.toAuthUser();

      expect(authUser.uid, 'testUID');
      expect(authUser.email, 'test@example.com');
      expect(authUser.displayName, isNull);
      expect(authUser.isEmailVerified, isFalse);
    });
  });
}
