import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  late final SharedPreferences _sharedPreferences;

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  void saveToken(String? token) {
    if (token != null && token.isNotEmpty) {
      _sharedPreferences.setString('x-auth-token', token);
    }
  }

  void clearToken() {
    _sharedPreferences.remove('x-auth-token');
  }

  String? getToken() {
    return _sharedPreferences.getString('x-auth-token');
  }
}
