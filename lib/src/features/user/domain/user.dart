import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

typedef UserId = String;

class User extends Equatable {
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
    );
  }

  const User({
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
      '_id': uid,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  @override
  String toString() {
    return 'User(uid: $uid, username: $username, email: $email, imageUrl: $imageUrl)';
  }

  @override
  List<Object?> get props => [uid, username, email, imageUrl];
}
