import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:map_fields/map_fields.dart';

import 'package:peer_to_sync/src/features/user/domain/user.dart';

typedef SyncedRoomId = String;

class SyncedRoom<T, U> extends Equatable {
  factory SyncedRoom.fromMap(Map<String, dynamic> map) {
    final mapFields = MapFields.load(map);

    return SyncedRoom<T, U>(
      id: map['_id'] ?? '',
      started: map['started'] ?? false,
      users: List<String>.from(map['users']),
      objects: mapFields.getList<T>('objects'),
      status: mapFields.getList<U>('status')[0],
      userNotifyList: List<String>.from(map['userNotifyList']),
    );
  }

  factory SyncedRoom.fromJson(String source) =>
      SyncedRoom.fromMap(json.decode(source));
  const SyncedRoom({
    required this.id,
    required this.started,
    required this.users,
    required this.objects,
    required this.status,
    required this.userNotifyList,
  });

  final SyncedRoomId id;
  final bool started;
  final List<UserId> users;
  final List<T> objects;
  final U status;
  final List<UserId> userNotifyList;

  SyncedRoom<T, U> copyWith({
    String? id,
    bool? started,
    List<UserId>? users,
    List<T>? objects,
    U? status,
    List<UserId>? userNotifyList,
  }) {
    return SyncedRoom<T, U>(
      id: id ?? this.id,
      started: started ?? this.started,
      users: users ?? this.users,
      objects: objects ?? this.objects,
      status: status ?? this.status,
      userNotifyList: userNotifyList ?? this.userNotifyList,
    );
  }

  @override
  List<Object?> get props => [
    id,
    started,
    users,
    objects,
    status,
    userNotifyList,
  ];

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'started': started,
      'users': users,
      'objects': objects,
      'status': [status],
      'userNotifyList': userNotifyList,
    };
  }

  String toJson() => json.encode(toMap());
}
