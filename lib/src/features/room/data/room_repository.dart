import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:peer_to_sync/src/constants/api_url.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';

class RoomRepository {
  final _mainRoute = '$apiUrl/rooms';

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
      debugPrint('Room $id was sucessfully fetched from $this');
      return Room.fromMap(res.data);
    } catch (e) {
      debugPrint('Room $id failed to fetch from $this : ${e.toString()}');
      return null;
    }
  }

  Future<Room> createRoom(
    String name,
    String hostId,
    int maxPlayers,
    RoomType type,
  ) async {
    final res = await dio.post(
      _mainRoute,
      data: {name: name, hostId: hostId, maxPlayers: maxPlayers, type: type},
    );

    debugPrint('Room ${res.data._id} sucessfully created from $this');
    return Room.fromMap(res.data);
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
