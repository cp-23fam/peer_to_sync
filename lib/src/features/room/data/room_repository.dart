import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:messages/messages.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/room/domain/no_space_left_exception.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';
import 'package:peer_to_sync/src/utils/fetch_token.dart';

class RoomRepository {
  RoomRepository({
    @visibleForTesting FlutterSecureStorage? storageClient,
    @visibleForTesting Dio? dioClient,
  }) {
    storage = storageClient ?? const FlutterSecureStorage();
    dio = dioClient ?? Dio(BaseOptions(validateStatus: (status) => true));
  }

  final _mainRoute = '$apiUrl/rooms';

  late final FlutterSecureStorage storage;
  late final Dio dio;

  Future<List<Room>> fetchRoomList() async {
    final rooms = <Room>[];

    final res = await dio.get(_mainRoute);

    res.data.forEach((d) => rooms.add(Room.fromMap(d)));
    debugPrint('${rooms.length} room(s) fetched from $this');

    return rooms;
  }

  Future<Room?> fetchRoom(RoomId id) async {
    final res = await dio.get('$_mainRoute/$id');

    try {
      debugPrint('$this fetched room $id');
      return Room.fromMap(res.data);
    } catch (e) {
      debugPrint('$this couldn\'t fetch room $id : ${e.toString()}');
      return null;
    }
  }

  Future<Room> createRoom(
    String name,
    UserId hostId,
    int maxPlayers,
    RoomType type,
    RoomVisibility visibility, {
    String? password,
  }) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.post(
      _mainRoute,
      data: {
        'name': name,
        'hostId': hostId,
        'maxPlayers': maxPlayers,
        'status': RoomStatus.waiting.name,
        'type': type.name,
        'visibility': visibility.name,
        'password': password,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 201) {
      debugPrint('$this created room ${res.data['_id']}');
      return Room.fromMap(res.data);
    }

    debugPrint('$this createRoom has unknown response : $res');
    throw UnimplementedError();
  }

  Future<void> overrideRoom(RoomId id, Room room) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.put(
      '$_mainRoute/$id',
      data: room.toMap(),
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 200) {
      debugPrint('$this replaced room $id');
      return;
    }

    debugPrint('$this overrideRoom has unknown response : $res');
    throw UnimplementedError();
  }

  Future<void> joinRoom(RoomId id, {String? password}) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.post(
      password == null
          ? '$_mainRoute/$id/join'
          : '$_mainRoute/$id/join?password=$password',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 200) {
      debugPrint('User joined room $id');
      return;
    }

    if (res.statusCode! == 403) {
      debugPrint('$this prevented user to joins room $id : Room is full');
      throw NoSpaceLeftException();
    }

    debugPrint('User could not join room $id');
    throw UnimplementedError();
  }

  Future<void> quitRoom(RoomId id) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.post(
      '$_mainRoute/$id/quit',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final updatedRoom = await fetchRoom(id);

    if (res.statusCode! == 200) {
      debugPrint('User quited room $id');
      if (updatedRoom!.users.isEmpty ||
          !updatedRoom.users.contains(updatedRoom.hostId)) {
        await deleteRoom(id);
      }
      return;
    }

    debugPrint('User could not quit room $id');
    throw UnimplementedError();
  }

  Future<void> kickUser(RoomId id, UserId uid) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.post(
      '$_mainRoute/$id/kick/$uid',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 200) {
      debugPrint('User kicked $uid from room $id');
      return;
    }

    debugPrint('User could not quit room $id');
    throw UnimplementedError();
  }

  Future<void> deleteRoom(RoomId id) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException();
    }

    final res = await dio.delete(
      '$_mainRoute/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 204) {
      debugPrint('User deleted room $id');
      return;
    }

    debugPrint('User could not delete room $id');
    throw UnimplementedError();
  }

  @override
  String toString() {
    return 'RoomRepository';
  }
}

final roomRepositoryProvider = Provider((ref) {
  return RoomRepository();
});

final roomListProvider = FutureProvider.autoDispose<List<Room>>((ref) {
  final provider = ref.watch(roomRepositoryProvider).fetchRoomList();

  return provider;
});

final roomListStreamProvider = StreamProvider.autoDispose<List<Room>>((ref) {
  var provider = ref.read(roomRepositoryProvider).fetchRoomList();

  final timer = Timer.periodic(const Duration(seconds: 3), (_) {
    ref.invalidateSelf();
  });
  ref.onDispose(timer.cancel);

  return provider.asStream();
});

final roomProvider = FutureProvider.family.autoDispose<Room?, RoomId>((
  ref,
  id,
) async {
  final provider = await ref.watch(roomRepositoryProvider).fetchRoom(id);

  return provider;
});

final roomStreamProvider = StreamProvider.family.autoDispose<Room?, RoomId>((
  ref,
  id,
) {
  var provider = ref.read(roomRepositoryProvider).fetchRoom(id);

  final timer = Timer.periodic(const Duration(seconds: 1), (_) {
    ref.invalidateSelf();
  });

  ref.onDispose(timer.cancel);

  return provider.asStream();
});
