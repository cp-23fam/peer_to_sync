import 'dart:convert';

import 'package:peer_to_sync/peer_to_sync.dart';

class UserInfos {
  factory UserInfos.fromMap(Map<String, dynamic> map) {
    return UserInfos(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  factory UserInfos.fromJson(String source) =>
      UserInfos.fromMap(json.decode(source));

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

  Map<String, dynamic> toMap() {
    return {'uid': uid, 'username': username, 'imageUrl': imageUrl};
  }

  String toJson() => json.encode(toMap());
}
