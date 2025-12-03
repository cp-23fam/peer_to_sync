import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/messages/domain/synced_room.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';
import 'package:peer_to_sync/src/utils/fetch_token.dart';

class MessageRepository {
  MessageRepository({
    @visibleForTesting Dio? dioClient,
    @visibleForTesting FlutterSecureStorage? storageClient,
  }) {
    storage = storageClient ?? const FlutterSecureStorage();
    dio = dioClient ?? Dio(BaseOptions(validateStatus: (status) => true));
  }

  Future<SyncedRoom<T, U>> createSyncedRoom<T, U>(
    List<UserId> users,
    U status,
  ) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.post(
      _mainRoute,
      data: {users: users, status: status},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 201) {
      return SyncedRoom<T, U>.fromMap(res.data);
    }

    debugPrint('$this createSyncedRoom was given unknown response');
    throw UnimplementedError();
  }

  late final Dio dio;
  late final FlutterSecureStorage storage;

  final String _mainRoute = '$apiUrl/synced_rooms';

  Future<SyncedRoom<T, U>> fetchSyncedRoom<T, U>(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.get(
      '$_mainRoute/$id',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return SyncedRoom.fromMap(res.data);
    }

    debugPrint('$this fetchSyncedRoom was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> sendNotified(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/notified',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this sendNotified was given an unknown response');
    throw UnimplementedError();
  }

  Future<String> _checkToken() async {
    final token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    return token;
  }

  Future<void> startMe(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/start',

      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this startMe was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> sendThis<T>(SyncedRoomId id, T object) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/add',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this sendThis was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> removeAt<T>(
    SyncedRoomId id,
    int index,
    T objectVerification,
  ) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/remove/$index',
      data: {'object': objectVerification},
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200 || res.statusCode == 202) {
      return;
    }

    debugPrint('$this removeAt was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> newStatus<U>(SyncedRoomId id, U status) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/status',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this newStatus was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> notifyOthers(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/notify',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this notifyOthers was given an unknown response');
    throw UnimplementedError();
  }

  Future<SyncedRoom<T, U>> overrideNow<T, U>(SyncedRoomId id) async {
    final currentRoom = await fetchSyncedRoom<T, U>(id);
    sendNotified(id);

    return currentRoom;
  }

  Future<dynamic> getChanges<T, U>(SyncedRoom<T, U> room) async {
    final token = await _checkToken();

    final res = await dio.put(
      '$_mainRoute/${room.id}/changes',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200) {
      return res.data;
    }

    debugPrint('$this getChanges was given an unknown response');
    throw UnimplementedError();
  }

  @override
  String toString() => 'MessageRepository';
}
