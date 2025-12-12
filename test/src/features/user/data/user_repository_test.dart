import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:peer_to_sync/src/features/user/data/user_repository.dart';
import 'package:peer_to_sync/src/features/user/domain/email_exception.dart';
import 'package:peer_to_sync/src/features/user/domain/logged_out_exception.dart';
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

  const token = 'abcd';

  void prepareStorageMockToReturnTokenIfProvided(String? token) {
    when(() => storage.read(key: 'token')).thenAnswer((_) async => token);
  }

  group('fetchUserList', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.fetchUserList(),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet('$apiPath/users', (server) => server.reply(600, {}));

      expect(
        () async => await userRepository.fetchUserList(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('fetchCurrentUser', () {
    final user = {
      '_id': '691d822e15ab08bf78780ba1',
      'email': 'test@example.com',
      'username': 'Fabrioche',
      'imageUrl': 'https://localhost/storage/image/user-1',
      'friends': [],
      'pending': [],
    };

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
          '$apiPath/users/self',
          (server) => server.reply(401, {'message': 'Not authenticated'}),
        );

        final res = await userRepository.fetchCurrentUser();
        expect(res, null);
      },
    );

    test('should return a User when status is 200', () async {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/users/self',
        (server) => server.reply(200, user),
      );

      final res = await userRepository.fetchCurrentUser();
      final result = User.fromMap(user);
      expect(res, result);
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/users/self',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.fetchCurrentUser(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('fetchUser', () {
    final user = {
      '_id': '691d822e15ab08bf78780ba1',
      'email': 'test@example.com',
      'username': 'Fabrioche',
      'imageUrl': 'https://localhost:3000/storage/images/user-1',
      'friends': [],
      'pending': [],
    };

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
          '$apiPath/users/$token',
          (server) => server.reply(401, {'message': 'Not authenticated'}),
        );

        final res = await userRepository.fetchUser('abcd');
        expect(res, null);
      },
    );

    test('should return a User when status is 200', () async {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/users/$token',
        (server) => server.reply(200, user),
      );

      final res = await userRepository.fetchUser('abcd');
      final result = User.fromMap(user);
      expect(res, result);
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/users/$token',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.fetchUser('abcd'),
        throwsA(isA<UnimplementedError>()),
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
        '$apiPath/users/login',
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
          '$apiPath/users/login',
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
          '$apiPath/users/login',
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
        '$apiPath/users/login',
        (server) => server.reply(500, {}),
      );

      expect(
        () async =>
            await userRepository.logIn('test@example.com', 'Pa\$\$w0rd'),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('logOut', () {
    test('sould call storage to remove token', () async {
      when(
        () => storage.delete(key: 'token'),
      ).thenAnswer((_) => Future.value());

      await userRepository.logOut();

      verify(() => storage.delete(key: 'token')).called(1);
    });
  });
  group('signUp', () {
    test('should return a user when status is 201 with correct data', () async {
      dioAdapter.onPost(
        '$apiPath/users/signup',
        (server) => server.reply(201, {
          '_id': '1',
          'username': 'Fabrioche',
          'email': 'fabian@ceff.ch',
          'imageUrl': '',
          'friends': [],
          'pending': [],
        }),
      );

      final result = await userRepository.signUp(
        'Fabrioche',
        'fabian@ceff.ch',
        'Pa\$\$w0rd',
      );
      expect(
        result,
        const User(
          uid: '1',
          username: 'Fabrioche',
          email: 'fabian@ceff.ch',
          imageUrl: '',
          friends: [],
          pending: [],
        ),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      dioAdapter.onPost(
        '$apiPath/users/signup',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.signUp(
          'Fabrioche',
          'fabian@ceff.ch',
          'Pa\$\$w0rd',
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('resetProfilePicture', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.resetProfilePicture(),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onPost(
        '$apiPath/users/image',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.resetProfilePicture(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('updateSelf', () {
    const password = 'Pa\$\$w0rd';
    const user = User(
      uid: 'abcd',
      username: 'Fabrioche',
      email: 'fabian@ceff.ch',
      imageUrl: '',
      friends: [],
      pending: [],
    );

    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.updateSelf(user, password),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onPut(
        '$apiPath/users/self',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.updateSelf(user, password),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('fetchFriendsList', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.fetchFriendsList(),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onPost(
        '$apiPath/users/friends/list',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.fetchFriendsList(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });

  group('fetchPendingList', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.fetchPendingList(),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onPost(
        '$apiPath/users/pending/list',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.fetchPendingList(),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
  group('addFriend', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.addFriend('fabian@ceff.ch'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      const email = 'fabian@ceff.ch';

      prepareStorageMockToReturnTokenIfProvided(token);
      dioAdapter.onGet(
        '$apiPath/users/email/$email',
        (server) => server.reply(200, {
          'uid': '1',
          'username': 'Fabrioche',
          'email': 'fabian@ceff.ch',
          'imageUrl': '',
          'friends': [],
          'pending': [],
        }),
      );

      dioAdapter.onPost(
        '$apiPath/users/friends/add',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.addFriend(email),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
  group('removeFriend', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.removeFriend('1'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      const id = 'user-1';

      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost(
        '$apiPath/users/friends/$id/remove',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.removeFriend(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
  group('acceptUser', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.acceptUser('1'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      const id = 'user-1';

      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost(
        '$apiPath/users/friends/$id/accept',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.acceptUser(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
  group('rejectUser', () {
    test('should throw LoggedOutException() when token is null', () {
      prepareStorageMockToReturnTokenIfProvided(null);

      expect(
        () async => await userRepository.rejectUser('1'),
        throwsA(isA<LoggedOutException>()),
      );
    });

    test('should throw UnimplementedError when statusCode is unknown', () {
      const id = 'user-1';

      prepareStorageMockToReturnTokenIfProvided(token);

      dioAdapter.onPost(
        '$apiPath/users/friends/$id/reject',
        (server) => server.reply(600, {}),
      );

      expect(
        () async => await userRepository.rejectUser(id),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
