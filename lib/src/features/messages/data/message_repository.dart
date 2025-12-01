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

  Future<SyncedRoom> createSyncedRoom<U>(List<UserId> users, U status) async {
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
      return SyncedRoom.fromMap(res.data);
    }

    debugPrint('$this createSyncedRoom was given unknown response');
    throw UnimplementedError();
  }

  late final Dio dio;
  late final FlutterSecureStorage storage;

  final String _mainRoute = '$apiUrl/synced_rooms';

  Future<SyncedRoom> fetchSyncedRoom(SyncedRoomId id) async {
    final res = await dio.get('$_mainRoute/$id');

    if (res.statusCode == 200) {
      return SyncedRoom.fromMap(res.data);
    }

    debugPrint('$this fetchSyncedRoom was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> startMe(SyncedRoomId id) async {
    final res = await dio.post('$_mainRoute/$id/start');

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this startMe was given an unknown response');
    throw UnimplementedError();
  }

  @override
  String toString() => 'MessageRepository';
}
