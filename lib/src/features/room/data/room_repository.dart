import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';

final dio = Dio();
const mainRoute = '$apiUrl/rooms';

class RoomRepository {
  Future<List<Room>> fetchRoomList() async {
    final rooms = <Room>[];

    final res = await dio.get(mainRoute);

    res.data.forEach((d) => rooms.add(Room.fromMap(d)));
    debugPrint('${rooms.length} room(s) fetched from $this');

    return rooms;
  }

  Future<Room?> fetchRoom(RoomId id) async {
    final res = await dio.get('$mainRoute/$id');

    try {
      return Room.fromMap(res.data);
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> createRoom(
    String name,
    String hostId,
    int maxPlayers,
    RoomType type,
  ) async {
    final res = await dio.post(
      mainRoute,
      data: {name: name, hostId: hostId, maxPlayers: maxPlayers, type: type},
    );

    debugPrint(res.data.toString());
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
