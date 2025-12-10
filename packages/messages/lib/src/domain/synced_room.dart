import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/messages.dart';
import 'package:messages/src/domain/json_storable.dart';
import 'package:messages/src/domain/user_id.dart';

typedef SyncedRoomId = String;

class SyncedRoom<O, S> extends Equatable {
  factory SyncedRoom.fromMap(Map<String, dynamic> map) {
    final type = RoomType.values.firstWhere((t) => t.name == map['type']);

    final objects = List<Map<String, dynamic>>.from(map['objects']);
    final status = map['status'];

    return SyncedRoom<O, S>(
      id: map['_id'],
      started: map['started'] ?? false,
      users: List<String>.from(map['users']),
      objects: objects.map((o) => genericFromMap<O>(o)).toList(),
      status: status,
      userNotifyList: List<UserId>.from(map['userNotifyList']),
      expirationTimestamp: map['expirationTimestamp']?.toInt() ?? 0,
      widget: type.widget,
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
    required this.expirationTimestamp,
    required this.widget,
  });

  final SyncedRoomId id;
  final bool started;
  final List<UserId> users;
  final List<O> objects;
  final S status;
  final List<UserId> userNotifyList;
  final int expirationTimestamp;
  final Widget widget;

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toMap() {
    final type = RoomType.values.firstWhere((t) => t.widget == widget);

    return {
      '_id': id,
      'started': started,
      'users': users,
      'objects': objects.map((o) => genericToMap(o)),
      'status': genericToMap(status),
      'userNotifyList': userNotifyList,
      'expirationTimestamp': expirationTimestamp,
      'type': type.name,
    };
  }

  String toJson() => json.encode(toMap());
}
