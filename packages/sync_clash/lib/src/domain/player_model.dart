import 'dart:convert';

import 'package:flame/components.dart';
import 'package:messages/messages.dart';

enum PlayerAction { move, melee, shoot, block, none }

class PlayerModel {
  factory PlayerModel.fromMap(Map<String, dynamic> map) {
    final position = map['position'] as Map<String, dynamic>;
    final actionPos = map['actionPos'] as Map<String, dynamic>?;

    return PlayerModel(
      user: UserInfos.fromMap(map['user']),
      position: Vector2(position['x'], position['y']),
      action: PlayerAction.values.firstWhere((e) => e.name == map['action']),
      life: map['life'] as int,
      actionPos: actionPos == null
          ? null
          : Vector2(actionPos['x'], actionPos['y']),
    );
  }

  factory PlayerModel.fromJson(String source) =>
      PlayerModel.fromMap(json.decode(source) as Map<String, dynamic>);
  PlayerModel({
    required this.user,
    required this.position,
    required this.action,
    required this.life,
    required this.actionPos,
  });

  final UserInfos user;
  final Vector2 position;
  final PlayerAction action;
  final int life;
  final Vector2? actionPos;

  PlayerModel copyWith({
    UserInfos? user,
    Vector2? position,
    PlayerAction? action,
    int? life,
    Vector2? actionPos,
  }) {
    return PlayerModel(
      user: user ?? this.user,
      position: position ?? this.position,
      action: action ?? this.action,
      life: life ?? this.life,
      actionPos: actionPos ?? this.actionPos,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'user': user.toMap(),
      'position': {'x': position.x, 'y': position.y},
      'action': action.name,
      'life': life,
      'actionPos': actionPos == null
          ? null
          : {'x': actionPos!.x, 'y': actionPos!.y},
    };
  }

  String toJson() => json.encode(toMap());
}
