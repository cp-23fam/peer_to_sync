import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/user/domain/email_exception.dart';
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

    final res = await dio.get(
      _mainRoute,
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.data['message'] == null && res.statusCode! == 200) {
      debugPrint('$this has fetched user User ${res.data['_id']}');
      return User.fromMap(res.data);
    }

    if (res.data['message'] != null && res.statusCode! == 401) {
      debugPrint('$this could not fetch user : ${res.data['message']}');
      return null;
    }

    debugPrint('$this fetchCurrentUser has unknown response : $res');
    throw UnimplementedError;
  }

  Future<User?> fetchUser(UserId uid) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      return null;
    }

    final res = await dio.get(
      '$_mainRoute/$uid',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.data['message'] == null && res.statusCode! == 200) {
      debugPrint('$this has fetched User ${res.data['_id']}');
      return User.fromMap(res.data);
    }

    if (res.data['message'] != null && res.statusCode! == 401) {
      debugPrint('$this could not fetch user : ${res.data['message']}');
      return null;
    }

    debugPrint('$this fetchCurrentUser has unknown response : $res');
    throw UnimplementedError;
  }

  Future<String> logIn(String email, String password) async {
    final res = await dio.post(
      '$_mainRoute/login',
      data: {'email': email, 'password': password},
    );

    if (res.statusCode! / 100 == 2) {
      debugPrint('$this made User log in ($email)');
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

    throw UnimplementedError('$this logIn has unknown response : $res');
  }

  Future<void> logOut() async {
    debugPrint('$this made user log out');
    await storage.delete(key: 'token');
  }

  Future<User?> signUp(String username, String email, String password) async {
    final res = await dio.post(
      '$_mainRoute/signup',
      data: {'username': username, 'email': email, 'password': password},
    );

    if (res.statusCode! == 201) {
      debugPrint('$this made User create an account ($email)');
      return User.fromMap(res.data);
    }

    debugPrint('$this signUp has unknown response : $res');
    throw UnimplementedError;
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

final userProvider = FutureProvider.family<User?, String>((ref, uid) {
  final provider = ref.watch(userRepositoryProvider).fetchUser(uid);

  return provider;
});
