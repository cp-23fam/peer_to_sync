import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';

class UserRepository {
  final _mainRoute = '$apiUrl/user';

  final storage = const FlutterSecureStorage();

  Future<User?> fetchCurrentUser() async {
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      return null;
    }

    final res = await dio.get(
      _mainRoute,
      options: Options(headers: {'Autorization': token}),
    );

    if (res.data.message != null && res.statusCode! == 401) {
      debugPrint('User could not get fetched from $this : ${res.data.message}');
      return null;
    }

    debugPrint('User ${res.data._id} sucessfully fetched from $this');
    return User.fromMap(res.data);
  }

  Future<String?> logIn(String email, String password) async {
    final res = await dio.post('$_mainRoute/login');

    if (res.statusCode! / 100 == 2) {
      debugPrint('User sucessfully logged in ($email)');
      return res.data.token;
    }

    if (res.statusCode! == 401) {
      debugPrint('User could not log in : ${res.data.message}');
      return null;
    }

    throw UnimplementedError('Status code not handled');
  }

  @override
  String toString() {
    return 'UserRepository';
  }
}

final userRepositoryProvider = Provider((ref) {
  return UserRepository();
});

final userInfosProvider = FutureProvider<User?>((ref) {
  final provider = ref.watch(userRepositoryProvider).fetchCurrentUser();

  return provider;
});
