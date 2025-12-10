import 'package:collab/collab.dart';
import 'package:flutter/widgets.dart';

enum RoomType {
  collab(object: Mail, status: String, widget: ChatRoomScreen()),
  game(object: String, status: String, widget: SizedBox());

  const RoomType({
    required this.object,
    required this.status,
    required this.widget,
  });

  final Type object;
  final Type status;
  final Widget widget;
}
