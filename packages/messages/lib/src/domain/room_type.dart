import 'package:flutter/widgets.dart';

enum RoomType {
  collab(object: String, status: String, widget: SizedBox()),
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
