import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:sync_clash/src/domain/player_model.dart';

class ActionIcon extends SpriteComponent {
  late PlayerAction action;

  ActionIcon({
    required this.action,
    required Vector2 position,
    required double size,
  }) {
    this.position = position;
    this.size = Vector2.all(size);
    anchor = Anchor.center;
  }

  @override
  Future<void> onLoad() async {
    late IconData icon;

    switch (action) {
      case PlayerAction.move:
        icon = Icons.arrow_forward;
        break;

      case PlayerAction.melee:
        icon = Icons.flash_on;
        break;

      case PlayerAction.shoot:
        icon = Icons.bolt;
        break;

      case PlayerAction.block:
        icon = Icons.shield;
        break;

      default:
        icon = Icons.question_mark;
        break;
    }

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          package: icon.fontPackage,
          fontSize: size.x * 0.9,
          color: Colors.white,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    painter.layout();
    painter.paint(canvas, Offset.zero);
    final picture = recorder.endRecording();
    final image = await picture.toImage(size.x.toInt(), size.y.toInt());

    sprite = sprite = Sprite(image);
  }
}
