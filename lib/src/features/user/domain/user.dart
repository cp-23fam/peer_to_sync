import 'package:equatable/equatable.dart';

typedef UserId = String;

class User extends Equatable {
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['_id'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      imageUrl: map['imageUrl'],
      friends: List<String>.from(map['friends']),
      pending: List<String>.from(map['pending']),
    );
  }

  const User({
    required this.uid,
    required this.username,
    required this.email,
    required this.imageUrl,
    required this.friends,
    required this.pending,
  });

  final UserId uid;
  final String username;
  final String email;
  final String? imageUrl;
  final List<UserId> friends;
  final List<UserId> pending;

  User copyWith({
    String? uid,
    String? username,
    String? email,
    String? imageUrl,
    List<String>? friends,
    List<String>? pending,
  }) {
    return User(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      friends: friends ?? this.friends,
      pending: pending ?? this.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': uid,
      'username': username,
      'email': email,
      'imageUrl': imageUrl,
      'friends': friends,
      'pending': pending,
    };
  }

  @override
  List<Object?> get props => [uid, username, email, imageUrl, friends, pending];
}
