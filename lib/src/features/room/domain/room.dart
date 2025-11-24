import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import 'package:peer_to_sync/src/features/room/domain/room_status.dart';
import 'package:peer_to_sync/src/features/room/domain/room_type.dart';
import 'package:peer_to_sync/src/features/user/domain/user.dart';

typedef RoomId = String;

class Room extends Equatable {
  factory Room.fromJson(String source) => Room.fromMap(json.decode(source));

  factory Room.fromMap(Map<String, dynamic> map) {
    final status = RoomStatus.values.firstWhere((s) => s.name == map['status']);
    final type = RoomType.values.firstWhere((s) => s.name == map['type']);

    return Room(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      hostId: map['hostId'] ?? '',
      users: List<String>.from(map['users']),
      status: status,
      maxPlayers: map['maxPlayers']?.toInt() ?? 0,
      type: type,
      redirectionId: map['redirectionId'],
    );
  }

  const Room({
    required this.id,
    required this.name,
    required this.hostId,
    required this.users,
    required this.status,
    required this.maxPlayers,
    required this.type,
    this.redirectionId,
  });

  final RoomId id;
  final String name;
  final UserId hostId;
  final List<UserId> users;
  final RoomStatus status;
  final int maxPlayers;
  final RoomType type;
  final String? redirectionId;

  Room copyWith({
    String? id,
    String? name,
    String? hostId,
    List<String>? users,
    RoomStatus? status,
    int? maxPlayers,
    RoomType? type,
    ValueGetter<String?>? redirectionId,
  }) {
    return Room(
      id: id ?? this.id,
      name: name ?? this.name,
      hostId: hostId ?? this.hostId,
      users: users ?? this.users,
      status: status ?? this.status,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      type: type ?? this.type,
      redirectionId: redirectionId != null
          ? redirectionId()
          : this.redirectionId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'name': name,
      'hostId': hostId,
      'users': users,
      'status': status.name,
      'maxPlayers': maxPlayers,
      'type': type.name,
      'redirectionId': redirectionId,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Room(id: $id, name: $name, hostId: $hostId, users: $users, status: $status, maxPlayers: $maxPlayers, type: $type, redirectionId: $redirectionId)';
  }

  @override
  List<Object?> get props => [
    id,
    name,
    hostId,
    users,
    status,
    maxPlayers,
    type,
    redirectionId,
  ];
}
