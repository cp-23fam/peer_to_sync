import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
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
    String hostId,
    int maxPlayers,
    RoomType type,
  ) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException;
    }

    final res = await dio.post(
      _mainRoute,
      data: {
        'name': name,
        'hostId': hostId,
        'maxPlayers': maxPlayers,
        'type': type.name,
      },
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 201) {
      debugPrint('$this created room ${res.data['_id']}');
      return Room.fromMap(res.data);
    }

    throw UnimplementedError('Unimplemented statusCode');
  }

  Future<void> joinRoom(RoomId id) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException;
    }

    final res = await dio.post(
      '$_mainRoute/$id/join',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (res.statusCode! == 200) {
      debugPrint('User joined room $id');
      return;
    }

    debugPrint('User could not join room $id');
    throw UnimplementedError;
  }

  Future<void> quitRoom(RoomId id) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException;
    }

    final res = await dio.post(
      '$_mainRoute/$id/quit',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    final updatedRoom = await fetchRoom(id);

    if (res.statusCode! == 200) {
      debugPrint('User quited room $id');
      if (updatedRoom!.users.isEmpty) {
        await deleteRoom(id);
      }
      return;
    }

    debugPrint('User could not quit room $id');
    throw UnimplementedError;
  }

  Future<void> deleteRoom(RoomId id) async {
    final String? token = await fetchToken(storage);

    if (token == null) {
      throw LoggedOutException;
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
    throw UnimplementedError;
  }

  @override
  String toString() {
    return 'RoomRepository';
  }
}

final roomRepositoryProvider = Provider((ref) {
  return RoomRepository();
});

final roomListProvider = FutureProvider<List<Room>>((ref) {
  final provider = ref.watch(roomRepositoryProvider).fetchRoomList();

  return provider;
});

final roomProvider = FutureProvider.family<Room?, RoomId>((ref, id) async {
  final provider = await ref.watch(roomRepositoryProvider).fetchRoom(id);

  return provider;
});
