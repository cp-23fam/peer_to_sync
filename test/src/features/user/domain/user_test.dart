import 'package:flutter_test/flutter_test.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';

void main() {
  const user = User(
    uid: 'user-1',
    username: 'User1',
    email: 'test@example.com',
    imageUrl: '',
    friends: [],
    pending: [],
  );
  const userMap = {
    '_id': 'user-1',
    'username': 'User1',
    'email': 'test@example.com',
    'imageUrl': null,
    'friends': [],
    'pending': [],
  };

  group('fromMap', () {
    test(
      'should create a user with correct values when given a similar map',
      () {
        final result = User.fromMap(userMap);

        expect(result, user);
        expect(result, isA<User>());
      },
    );
  });

  group('toMap', () {
    test(
      'should create a map with correct values when given a similar user',
      () {
        final result = user.toMap();

        expect(result, userMap);
        expect(result, isA<Map<String, dynamic>>());
      },
    );
  });
}
