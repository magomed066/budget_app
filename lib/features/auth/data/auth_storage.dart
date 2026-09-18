import 'dart:convert';

import 'package:budget_app/features/auth/data/auth_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _key = 'auth_user';

  final _storage = FlutterSecureStorage();

  Future<void> saveUser(AuthUser user) async {
    await _storage.write(key: _key, value: jsonEncode(user.toJson()));
  }

  Future<AuthUser?> readUser() async {
    final value = await _storage.read(key: _key);

    if (value == null) return null;

    return AuthUser.fromJson(jsonDecode(value) as Map<String, dynamic>);
  }

  Future<void> clearUser() async {
    await _storage.delete(key: _key);
  }
}

final authStorage = AuthStorage();
