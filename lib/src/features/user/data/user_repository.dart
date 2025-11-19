import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';

class UserRepository {
  final dio = Dio();
  final mainRoute = '$apiUrl/user';

  final storage = const FlutterSecureStorage();

  Future<User?> fetchCurrentUser() async {
    final String? token = await storage.read(key: 'token');

    if (token == null) {
      return null;
    }

    final res = await dio.get(
      mainRoute,
      options: Options(headers: {'Autorization': token}),
    );

    if (res.data.message != null && res.statusCode! == 401) {
      return null;
    }

    return User.fromMap(res.data);
  }

  Future<String> logIn(String email, String password) async {
    final res = await dio.post('$mainRoute/login');

    return res.data.toString();
  }
}

final userRepositoryProvider = Provider((ref) {
  return UserRepository();
});

final userInfosProvider = FutureProvider<User?>((ref) {
  final provider = ref.watch(userRepositoryProvider).fetchCurrentUser();

  return provider;
});
