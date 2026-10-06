import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/usuario.dart';

class StorageService {
  static const _tokenKey = 'access_token';
  static const _userKey = 'current_user';

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  Future<void> saveToken(String token) {
    return _storage.write(
      key: _tokenKey,
      value: token,
    );
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> saveUser(Usuario user) {
    return _storage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<Usuario?> getUser() async {
    final value = await _storage.read(key: _userKey);

    if (value == null) {
      return null;
    }

    try {
      return Usuario.fromJson(
        Map<String, dynamic>.from(
          jsonDecode(value) as Map,
        ),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearSession() async {
    await _storage.delete(key: _tokenKey);
    await _storage.delete(key: _userKey);
  }
}
