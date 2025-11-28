import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peer_to_sync/src/features/room/data/room_repository.dart';
import 'package:peer_to_sync/src/features/room/domain/no_space_left_exception.dart';
import 'package:peer_to_sync/src/features/room/domain/room.dart';
import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/room/domain/room_visibility.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';

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
          visibility: RoomVisibility.public,
          type: RoomType.game,
        ),
        Room(
          id: '2',
          name: 'Room 2',
          hostId: 'user-2',
          users: ['user-2', 'user-3', 'user-4'],
          status: RoomStatus.waiting,
          maxPlayers: 4,
          visibility: RoomVisibility.friends,
          type: RoomType.game,
        ),
        Room(
          id: '3',
          name: 'Room 3',
          hostId: 'user-5',
          users: ['user-5'],
          status: RoomStatus.playing,
          maxPlayers: 2,
          visibility: RoomVisibility.private,
          password: '1234',
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
            'visibility': 'public',
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
            visibility: RoomVisibility.public,
            type: RoomType.game,
          ),
        );
      },
    );
  });
  const token = 'abcd';

  void prepareStorageMockToReturnTokenIfProvided(String? token) {
    when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
  }

  group('createRoom', () {
    test('should return created room when status is 201', () async {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost(
        '$apiPath/rooms',
        (server) => server.reply(201, {
          '_id': '1',
          'name': 'Test room',
          'hostId': 'user-1',
          'users': ['user-1'],
          'status': 'waiting',
          'maxPlayers': 20,
          'type': 'game',
          'visibility': 'public',
          'redirectionId': null,
        }),
      );

      final res = await roomRepository.createRoom(
        'Test room',
        'user-1',
        20,
        RoomType.game,
        RoomVisibility.public,
      );

      expect(
        res,
        const Room(
          id: '1',
          name: 'Test room',
          hostId: 'user-1',
          users: ['user-1'],
          status: RoomStatus.waiting,
          maxPlayers: 20,
          visibility: RoomVisibility.public,
          type: RoomType.game,
        ),
      );
    });
  });

  group('joinRoom', () {
    test('should throw LoggedOutException if token from storage is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);
      expect(
        () async => await roomRepository.joinRoom('abcd'),
        throwsA(LoggedOutException),
      );
    });

    test(
      'should throw Unimplemented error if status code is different from 200',
      () {
        prepareStorageMockToReturnTokenIfProvided(token);
        const id = 'abcd';

        dioAdapter.onPost(
          '$apiPath/rooms/$id/join',
          (server) => server.reply(500, {}),
        );

        expect(
          () async => await roomRepository.joinRoom(id),
          throwsA(UnimplementedError),
        );
      },
    );

    test('should throw NoSpaceLeftException error when status code is 403', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      const id = 'abcd';

      dioAdapter.onPost(
        '$apiPath/rooms/$id/join',
        (server) => server.reply(403, {}),
      );

      expect(
        () async => await roomRepository.joinRoom(id),
        throwsA(NoSpaceLeftException),
      );
    });
  });
  group('quitRoom', () {
    test('should throw LoggedOutException if token from storage is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);
      expect(
        () async => await roomRepository.quitRoom('abcd'),
        throwsA(LoggedOutException),
      );
    });

    test(
      'should throw Unimplemented error if status code is different from 200',
      () {
        prepareStorageMockToReturnTokenIfProvided(token);
        const id = 'abcd';

        dioAdapter.onPost(
          '$apiPath/rooms/$id/quit',
          (server) => server.reply(500, {}),
        );

        dioAdapter.onGet(
          '$apiPath/rooms/$id',
          (server) => server.reply(200, {
            '_id': '1',
            'name': 'Test room',
            'hostId': 'user-1',
            'users': ['user-1'],
            'status': 'waiting',
            'maxPlayers': 20,
            'type': 'game',
            'redirectionId': null,
          }),
        );

        expect(
          () async => await roomRepository.quitRoom(id),
          throwsA(UnimplementedError),
        );
      },
    );
    //
  });

  group('kickPlayer', () {
    test('should throw LoggedOutException if token from storage is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);
      expect(
        () async => await roomRepository.kickUser('abcd', 'user-1'),
        throwsA(LoggedOutException),
      );
    });

    test(
      'should throw Unimplemented error if status code is different from 204',
      () {
        prepareStorageMockToReturnTokenIfProvided(token);
        const id = 'abcd';
        const userId = 'user-1';

        dioAdapter.onPost(
          '$apiPath/rooms/$id/kick/$userId',
          (server) => server.reply(500, {}),
        );

        expect(
          () async => await roomRepository.kickUser(id, userId),
          throwsA(UnimplementedError),
        );
      },
    );
  });

  group('deleteRoom', () {
    test('should throw LoggedOutException if token from storage is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);
      expect(
        () async => await roomRepository.deleteRoom('abcd'),
        throwsA(LoggedOutException),
      );
    });

    test(
      'should throw Unimplemented error if status code is different from 204',
      () {
        prepareStorageMockToReturnTokenIfProvided(token);
        const id = 'abcd';

        dioAdapter.onDelete(
          '$apiPath/rooms/$id',
          (server) => server.reply(500, {}),
        );

        expect(
          () async => await roomRepository.deleteRoom(id),
          throwsA(UnimplementedError),
        );
      },
    );
  });
}
