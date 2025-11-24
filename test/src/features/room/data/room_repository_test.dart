import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';

import '../../../mocks.dart';

void main() {
  const String apiPath = 'http://localhost:3000';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));
  final dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

  late MockFlutterSecureStorage storage;
  late RoomRepository roomRepository;

  setUp(() {
    storage = MockFlutterSecureStorage();
    roomRepository = RoomRepository(storageClient: storage, dioClient: dio);
  });

  group('fetchRoomList', () {
    test('should return same list when status is 200', () async {
      const rooms = <Room>[
        Room(
          id: '1',
          name: 'Room 1',
          hostId: 'user-1',
          users: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 20,
          type: RoomType.game,
        ),
        Room(
          id: '2',
          name: 'Room 2',
          hostId: 'user-2',
          users: ['user-2', 'user-3', 'user-4'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          type: RoomType.game,
        ),
        Room(
          id: '3',
          name: 'Room 3',
          hostId: 'user-5',
          users: ['user-5'],
          status: RoomStatus.creating,
          maxPlayers: 2,
          type: RoomType.game,
        ),
      ];

      dioAdapter.onGet(
        '$apiPath/rooms',
        (server) => server.reply(200, [...rooms.map((r) => r.toMap())]),
      );

      final res = await roomRepository.fetchRoomList();
      expect(res, rooms);
    });
  });

  group('fetchRoom', () {
    test(
      'should return a Room when res.data is in correct format for Room.fromMap',
      () async {
        const id = 'id';

        dioAdapter.onGet(
          '$apiPath/rooms/$id',
          (server) => server.reply(200, {
            '_id': '1',
            'name': 'Test room',
            'hostId': 'user-1',
            'users': ['user-1', 'user-2'],
            'status': 'waiting',
            'maxPlayers': 20,
            'type': 'game',
          }),
        );

        final res = await roomRepository.fetchRoom(id);
        expect(
          res,
          const Room(
            id: '1',
            name: 'Test room',
            hostId: 'user-1',
            users: ['user-1', 'user-2'],
            status: RoomStatus.waiting,
            maxPlayers: 20,
            type: RoomType.game,
          ),
        );
      },
    );
  });
  group('createRoom', () {
    const token = 'abcd';

    void prepareStorageMockToReturnTokenIfProvided(String? token) {
      when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
    }

    test('should return created room when status is 201', () async {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost(
        '$apiPath/rooms',
        (server) => server.reply(201, {
          '_id': '1',
          'name': 'Test room',
          'hostId': 'user-1',
          'users': ['user-1'],
          'status': 'creating',
          'maxPlayers': 20,
          'type': 'game',
          'redirectionId': null,
        }),
      );

      final res = await roomRepository.createRoom(
        'Test room',
        'user-1',
        20,
        RoomType.game,
      );

      expect(
        res,
        const Room(
          id: '1',
          name: 'Test room',
          hostId: 'user-1',
          users: ['user-1'],
          status: RoomStatus.creating,
          maxPlayers: 20,
          type: RoomType.game,
        ),
      );
    });
  });
}
