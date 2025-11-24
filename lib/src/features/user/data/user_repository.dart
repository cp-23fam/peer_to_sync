import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/user/domain/email_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/password_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';
import 'package:peer_to_sync/src/utils/fetch_token.dart';

class UserRepository {
  UserRepository({
    @visibleForTesting FlutterSecureStorage? storageClient,
    @visibleForTesting Dio? dioClient,
  }) {
    storage = storageClient ?? const FlutterSecureStorage();
    dio = dioClient ?? Dio(BaseOptions(validateStatus: (status) => true));
  }

  final _mainRoute = '$apiUrl/user';

  late final FlutterSecureStorage storage;
  late final Dio dio;

  Future<User?> fetchCurrentUser() async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      return null;
    }
    debugPrint('Token is not null');

    final res = await dio.get(
      _mainRoute,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.data['message'] == null && res.statusCode! == 200) {
      debugPrint('User ${res.data['_id']} sucessfully fetched from $this');
      return User.fromMap(res.data);
    }

    debugPrint(
      'User could not get fetched from $this : ${res.data['message']}',
    );

    throw UnimplementedError;
  }

  Future<String> logIn(String email, String password) async {
    final res = await dio.post(
      '$_mainRoute/login',
      data: {'email': email, 'password': password},
    );

    if (res.statusCode! / 100 == 2) {
      debugPrint('User sucessfully logged in ($email)');
      await storage.write(key: 'token', value: res.data['token']);
      return res.data['token'];
    }

    if (res.statusCode! == 401) {
      debugPrint('User could not log in : ${res.data['message']}');

      if (res.data['message'] == 'Unknown email') {
        throw EmailException();
      }

      if (res.data['message'] == 'Wrong password') {
        throw PasswordException();
      }
    }

    throw UnimplementedError('Status code not handled');
  }

  Future<void> logOut() async {
    await storage.delete(key: 'token');
  }

  Future<User?> signUp(String username, String email, String password) async {
    final res = await dio.post(
      '$_mainRoute/signup',
      data: {'username': username, 'email': email, 'password': password},
    );

    if (res.statusCode! == 201) {
      debugPrint('User created account : $email');
      return User.fromMap(res.data);
    }

    debugPrint('User could not create account');
    return null;
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
