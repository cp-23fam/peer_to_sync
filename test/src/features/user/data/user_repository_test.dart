import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/email_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/password_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';

import '../../../mocks.dart';

void main() {
  const String apiPath = 'http://localhost:3000';

  final dio = Dio(BaseOptions(validateStatus: (status) => true));
  final dioAdapter = DioAdapter(dio: dio, matcher: const UrlRequestMatcher());

  late MockFlutterSecureStorage storage;
  late UserRepository userRepository;

  setUp(() {
    storage = MockFlutterSecureStorage();
    userRepository = UserRepository(storageClient: storage, dioClient: dio);
  });

  group('fetchCurrentUser', () {
    final user = {
      '_id': '691d822e15ab08bf78780ba1',
      'email': 'test@example.com',
      'username': 'Fabrioche',
      'friends': [],
      'pending': [],
    };
    const token = 'abcd';

    void prepareStorageMockToReturnTokenIfProvided(String? token) {
      when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
    }

    test('should return null when token is empty', () async {
      prepareStorageMockToReturnTokenIfProvided(null);

      final res = await userRepository.fetchCurrentUser();
      expect(res, null);
    });

    test(
      'should return null when statusCode is 401 and message is not empty',
      () async {
        prepareStorageMockToReturnTokenIfProvided(token);

        dioAdapter.onGet(
          '$apiPath/user',
          (server) => server.reply(401, {'message': 'Not authenticated'}),
        );

        final res = await userRepository.fetchCurrentUser();
        expect(res, null);
      },
    );

    test('should return a User when status is 200', () async {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet('$apiPath/user', (server) => server.reply(200, user));

      final res = await userRepository.fetchCurrentUser();
      final result = User.fromMap(user);
      expect(res, result);
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet('$apiPath/user', (server) => server.reply(600, {}));

      expect(
        () async => await userRepository.fetchCurrentUser(),
        throwsA(UnimplementedError),
      );
    });
  });

  group('fetchUser', () {
    final user = {
      '_id': '691d822e15ab08bf78780ba1',
      'email': 'test@example.com',
      'username': 'Fabrioche',
      'friends': [],
      'pending': [],
    };
    const token = 'abcd';

    void prepareStorageMockToReturnTokenIfProvided(String? token) {
      when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
    }

    test('should return null when token is empty', () async {
      prepareStorageMockToReturnTokenIfProvided(null);

      final res = await userRepository.fetchUser('abcd');
      expect(res, null);
    });

    test(
      'should return null when statusCode is 401 and message is not empty',
      () async {
        prepareStorageMockToReturnTokenIfProvided(token);

        dioAdapter.onGet(
          '$apiPath/user/$token',
          (server) => server.reply(401, {'message': 'Not authenticated'}),
        );

        final res = await userRepository.fetchUser('abcd');
        expect(res, null);
      },
    );

    test('should return a User when status is 200', () async {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/user/$token',
        (server) => server.reply(200, user),
      );

      final res = await userRepository.fetchUser('abcd');
      final result = User.fromMap(user);
      expect(res, result);
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/user/$token',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.fetchUser('abcd'),
        throwsA(UnimplementedError),
      );
    });
  });

  group('logIn', () {
    void prepareStorageMockToHandleWriteOn(String token) {
      when(
        () => storage.write(key: 'token', value: token),
      ).thenAnswer((_) async {});
    }

    test('should return token string when status is 200', () async {
      prepareStorageMockToHandleWriteOn('abcd');

      dioAdapter.onPost(
        '$apiPath/user/login',
        (server) => server.reply(200, {'token': 'abcd'}),
      );
      final result = await userRepository.logIn(
        'test@example.com',
        'Pa\$\$w0rd',
      );
      expect(result, 'abcd');
    });

    test(
      'should throw EmailException when status is 401 and message is "Unknown email"',
      () {
        dioAdapter.onPost(
          '$apiPath/user/login',
          (server) => server.reply(401, {'message': 'Unknown email'}),
        );
        expect(
          () async =>
              await userRepository.logIn('test@example.com', 'Pa\$\$w0rd'),
          throwsA(isA<EmailException>()),
        );
      },
    );

    test(
      'should throw PasswordException when status is 401 and message is "Wrong password"',
      () {
        dioAdapter.onPost(
          '$apiPath/user/login',
          (server) => server.reply(401, {'message': 'Wrong password'}),
        );
        expect(
          () async =>
              await userRepository.logIn('test@example.com', 'Pa\$\$w0rd'),
          throwsA(isA<PasswordException>()),
        );
      },
    );

    test('should throw an error when status code is not handled', () {
      dioAdapter.onPost(
        '$apiPath/user/login',
        (server) => server.reply(500, {}),
      );

      expect(
        () async =>
            await userRepository.logIn('test@example.com', 'Pa\$\$w0rd'),
        throwsA(UnimplementedError),
      );
    });
  });
}
