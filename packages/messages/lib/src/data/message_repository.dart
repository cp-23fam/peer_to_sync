import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:messages/messages.dart';
import 'package:messages/src/domain/json_storable.dart';
import 'package:peer_to_sync/peer_to_sync.dart';

class MessageRepository {
  MessageRepository({
    @visibleForTesting Dio? dioClient,
    @visibleForTesting FlutterSecureStorage? storageClient,
  }) {
    storage = storageClient ?? const FlutterSecureStorage();
    dio = dioClient ?? Dio(BaseOptions(validateStatus: (status) => true));
  }

  late final Dio dio;
  late final FlutterSecureStorage storage;

  final String _mainRoute = 'http://localhost:3000/synced';

  Future<String> _checkToken() async {
    final String? token = await storage.read(key: 'token');
    if (token != null) {
      debugPrint('Token fetched');
    }

    if (token == null) {
      throw LoggedOutException();
    }

    return token;
  }

  Future<SyncedRoom<O, S>> createSyncedRoom<O, S>(
    String name,
    List<UserId> users,
    RoomType type,
  ) async {
    final String token = await _checkToken();

    final res = await dio.post(
      _mainRoute,
      data: {
        'users': users,
        'type': type.name,
        'status': {'status': false},
        'name': name,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 201) {
      return SyncedRoom.fromMap(res.data);
    }

    debugPrint('$this createSyncedRoom was given unknown response');
    throw UnimplementedError();
  }

  Future<SyncedRoom<O, S>> fetchSyncedRoom<O, S>(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.get(
      '$_mainRoute/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return SyncedRoom<O, S>.fromMap(res.data);
    }

    debugPrint('$this fetchSyncedRoom was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> renewSynced(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.patch(
      '$_mainRoute/$id/renew',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this renewSynced was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> sendNotified(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.patch(
      '$_mainRoute/$id/notified',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this sendNotified was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> startMe(SyncedRoomId id) async {
    final token = await _checkToken();

    final res = await dio.patch(
      '$_mainRoute/$id/start',

      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this startMe was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> sendThis<O>(SyncedRoomId id, O object) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/add',
      data: {'object': genericToMap(object)},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this sendThis was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> editAt<O>(
    SyncedRoomId id,
    int index,
    O object,
    int objectsLength,
  ) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/edit/$index?length=$objectsLength',
      data: {'object': genericToMap(object)},
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200 || res.statusCode == 202) {
      return;
    }

    debugPrint('$this removeAt was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> removeAt(SyncedRoomId id, int index, int objectslength) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/remove/$index?length=$objectslength',
      options: Options(headers: {'Authorization': 'Brearer $token'}),
    );

    if (res.statusCode == 200 || res.statusCode == 202) {
      return;
    }

    debugPrint('$this removeAt was given an unknown response');
    throw UnimplementedError();
  }

  Future<void> newStatus<S>(SyncedRoomId id, S status) async {
    final token = await _checkToken();

    final res = await dio.post(
      '$_mainRoute/$id/status',
      data: {'status': genericToMap(status)},
      options: Options(headers: {'Authorization': 'Bearer $token'}),
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
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode == 200) {
      return;
    }

    debugPrint('$this notifyOthers was given an unknown response');
    throw UnimplementedError();
  }

  Future<SyncedRoom> overrideNow(SyncedRoomId id) async {
    final currentRoom = await fetchSyncedRoom(id);
    sendNotified(id);

    return currentRoom;
  }

  Future<dynamic> getChanges(SyncedRoom room) async {
    final token = await _checkToken();

    final res = await dio.put(
      '$_mainRoute/${room.id}/changes',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
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

final messageRepositoryProvider = Provider((ref) {
  return MessageRepository();
});

final syncedFutureProvider = FutureProvider.family<SyncedRoom?, String>((
  ref,
  id,
) {
  final provider = ref.watch(messageRepositoryProvider).fetchSyncedRoom(id);

  return provider;
});

Future<UserInfos> getCurrrentUser(WidgetRef ref) async {
  return UserInfos.fromUser(
    (await ref.read(userRepositoryProvider).fetchCurrentUser())!,
  );
}

Future<UserInfos> getUser(WidgetRef ref, UserId id) async {
  return UserInfos.fromUser(
    (await ref.read(userRepositoryProvider).fetchUser(id))!,
  );
}
