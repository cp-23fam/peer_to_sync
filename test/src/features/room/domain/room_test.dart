import 'package:flutter_test/flutter_test.dart';
import 'package:messages/messages.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';

void main() {
  const room = Room(
    id: '1',
    name: 'Room 1',
    hostId: 'user-1',
    users: ['user-1'],
    maxPlayers: 20,
    status: RoomStatus.waiting,
    type: RoomType.synclash,
    visibility: RoomVisibility.public,
  );
  const roomMap = {
    '_id': '1',
    'name': 'Room 1',
    'hostId': 'user-1',
    'users': ['user-1'],
    'maxPlayers': 20,
    'status': 'waiting',
    'type': 'game',
    'visibility': 'public',
    'password': null,
    'redirectionId': null,
  };

  group('fromMap', () {
    test(
      'should create a user with correct values when given a similar map',
      () {
        final result = Room.fromMap(roomMap);

        expect(result, room);
        expect(result, isA<Room>());
      },
    );
  });

  group('toMap', () {
    test(
      'should create a map with correct values when given a similar user',
      () {
        final result = room.toMap();

        expect(result, roomMap);
        expect(result, isA<Map<String, dynamic>>());
      },
    );
  });
}
