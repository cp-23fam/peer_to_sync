import 'package:collab/collab.dart';
import 'package:flutter/material.dart';
import 'package:messages/messages.dart';
import 'package:sync_clash/sync_clash.dart';

enum RoomType {
  chatroom(icon: Icons.handshake),
  synclash(icon: Icons.games_outlined);

  const RoomType({required this.icon});

  final IconData icon;
}

class SyncedType {
  static final widgets = <String, Type>{
    RoomType.chatroom.name: ChatRoomScreen,
    RoomType.synclash.name: GameScreen,
  };

  static Widget getSyncedWidget(RoomType type, SyncedRoomId id) {
    switch (type) {
      case RoomType.chatroom:
        return ChatRoomScreen(roomId: id);
      case RoomType.synclash:
        return GameScreen(syncedId: id);
    }
  }

  static RoomType getTypeFromWidget(Widget widget) {
    final index = SyncedType.widgets.values.toList().indexWhere(
      (v) => widget.runtimeType == v,
    );

    return RoomType.values.elementAt(index);
  }
}
