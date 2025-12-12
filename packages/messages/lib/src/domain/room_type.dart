import 'package:collab/collab.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/messages.dart';
import 'package:sync_clash/sync_clash.dart';

enum RoomType { collab, game }

class SyncedType {
  static final widgets = <String, Type>{
    RoomType.collab.name: ChatRoomScreen,
    RoomType.game.name: GameScreen,
  };

  static Widget getSyncedWidget(RoomType type, SyncedRoomId id) {
    switch (type) {
      case RoomType.collab:
        return ChatRoomScreen(roomId: id);
      case RoomType.game:
        return const GameScreen();
    }
  }

  static RoomType getTypeFromWidget(Widget widget) {
    final index = SyncedType.widgets.values.toList().indexWhere(
      (v) => widget.runtimeType == v,
    );

    return RoomType.values.elementAt(index);
  }
}
