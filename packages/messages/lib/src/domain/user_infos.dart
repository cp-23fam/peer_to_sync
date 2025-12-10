import 'package:peer_to_sync/peer_to_sync.dart';

class UserInfos {
  factory UserInfos.fromUser(User user) {
    return UserInfos(
      uid: user.uid,
      username: user.username,
      imageUrl: user.imageUrl,
    );
  }

  UserInfos({
    required this.uid,
    required this.username,
    required this.imageUrl,
  });

  final String uid;
  final String username;
  final String imageUrl;
}
