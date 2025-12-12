import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:messages/messages.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';

import '../../../mocks.dart';

// TODO: Rework this

void main() {
  const apiPath = 'http://localhost:3000';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));
  final dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

  late MockFlutterSecureStorage storage;
  late MessageRepository messageRepository;

  setUp(() {
    storage = MockFlutterSecureStorage();
    messageRepository = MessageRepository(
      dioClient: dio,
      storageClient: storage,
    );
  });

  const token = 'abcd';

  void prepareStorageMockToReturnTokenIfProvided(String? token) {
    when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
  }

  group('createSyncedRoom', () {
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.createSyncedRoom(
          'Test room',
          [],
          RoomType.game,
        ),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost('$apiPath/synced', (server) => server.reply(600, {}));

      expect(
        () async => await messageRepository.createSyncedRoom('Test room', [
          'user-1',
          'user-2',
        ], RoomType.game),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('fetchSyncedRoom', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.fetchSyncedRoom(id),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onGet(
        '$apiPath/synced/$id',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.fetchSyncedRoom(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('sendNotified', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.sendNotified(id),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/notified',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.sendNotified(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('startMe', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.startMe(id),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/start',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.startMe(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('sendThis', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.sendThis(id, 'my-object'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/add',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.sendThis(id, 'my-object'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('removeAt', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.removeAt(id, 0, 1),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      const index = 0;

      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/remove/$index?length=1',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.removeAt(id, index, 1),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('newStatus', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.newStatus(id, 'my-status'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/status',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.newStatus(id, 'my-status'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('notifyOthers', () {
    const id = 'a1b2c3d4';
    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.notifyOthers(id),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPatch(
        '$apiPath/synced/$id/notify',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.notifyOthers(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('getChanges', () {
    const id = 'a1b2c3d4';

    const synced = SyncedRoom(
      id: id,
      started: false,
      name: 'Test room',
      users: ['user-1', 'user-2'],
      objects: [],
      status: false,
      expirationTimestamp: -1,
      widget: SizedBox(),
      userNotifyList: [],
    );

    test('should throw if token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await messageRepository.getChanges(synced),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError if status code is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPut(
        '$apiPath/synced/$id/changes',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await messageRepository.getChanges(synced),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
