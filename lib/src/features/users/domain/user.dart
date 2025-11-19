import 'dart:convert';

import 'package:flutter/widgets.dart';

typedef UserId = String;

class User {
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  User({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
  });

  final UserId uid;
  final String username;
  final String email;
  final String? imageUrl;

  User copyWith({
    String? uid,
    String? username,
    String? email,
    ValueGetter<String?>? imageUrl,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl != null ? imageUrl() : this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User(uid: $uid, username: $username, email: $email, imageUrl: $imageUrl)';
  }
}
