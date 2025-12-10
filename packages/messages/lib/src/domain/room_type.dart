import 'package:collab/collab.dart';
import 'package:flutter/widgets.dart';
import 'package:messages/messages.dart';

// enum RoomType {
//   collab(object: String, status: String, widget: SizedBox()),
//   game(object: String, status: String, widget: SizedBox());

//   const RoomType({
//     required this.object,
//     required this.status,
//     required this.widget,
//   });

//   final Type object;
//   final Type status;
//   final Widget widget;
// }

enum RoomType { collab, game }

class SyncedType {
  static final widgets = <String, Type>{
    RoomType.collab.name: ChatRoomScreen,
    RoomType.game.name: SizedBox,
  };

  static Widget getSyncedWidget(RoomType type, SyncedRoomId id) {
    switch (type) {
      case RoomType.collab:
        return ChatRoomScreen(roomId: id);
      case RoomType.game:
        return const SizedBox();
    }
  }

  static RoomType getTypeFromWidget(Widget widget) {
    final index = SyncedType.widgets.values.toList().indexWhere(
      (v) => widget.runtimeType == v,
    );

    return RoomType.values.elementAt(index);
  }
}
