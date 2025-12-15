import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:sync_clash/sync_clash.dart';

import 'components/action_icon.dart';
import 'components/grid.dart';
import 'components/player.dart';

class MyGame extends FlameGame {
  static const int gridSize = 9;
  static const double cellSize = 54;

  static const playerColors = [
    0xffff4538,
    0xffffda38,
    0xff8fff38,
    0xff38ff77,
    0xff38f2ff,
    0xff385dff,
    0xffa838ff,
    0xffff38c0,
  ];

  late Grid grid;
  final List<Player> players = [];
  final List<ActionIcon> actionIcons = [];

  GameStatus status = GameStatus.choosing;

  late TextComponent timerText;
  late TextComponent statusText;

  double _roundTimer = 10.0;
  double _currentTime = 0;

  bool isInit = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _initGame();
  }

  void _initGame() {
    grid = Grid(sizeInCells: gridSize, cellSize: cellSize);
    add(grid);

    _spawnMockPlayers();

    timerText = TextComponent(
      position: Vector2(8, 8),
      textRenderer: TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 18),
      ),
    );

    statusText = TextComponent(
      position: Vector2(8, 32),
      textRenderer: TextPaint(
        style: TextStyle(color: BasicPalette.white.color, fontSize: 18),
      ),
    );

    add(timerText);
    add(statusText);
    isInit = true;
  }

  void _spawnMockPlayers() {
    final mockPositions = [Vector2(2, 2), Vector2(6, 6)];

    for (int i = 0; i < mockPositions.length; i++) {
      final player = Player(
        id: 'player_$i',
        color: Color(playerColors[i]),
        lives: 3,
        position: mockPositions[i] * cellSize,
      );

      players.add(player);
      add(player);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    _currentTime += dt;
    timerText.text = 'Temps restant : ${(_roundTimer - _currentTime).ceil()}s';
    statusText.text = 'Status : ${status.name}';

    if (_currentTime >= _roundTimer) {
      _resolveTurn();
    }
  }

  void _resolveTurn() {
    _currentTime = 0;

    if (status == GameStatus.choosing) {
      status = GameStatus.showing;
      grid.clearHighlights();
      _showMockActions();
      // players.map((p)
      for (Player p in players) {
        p.action.name == PlayerAction.melee.name
            ? highlightMeleeZone(p.id)
            : null;
        p.action.name == PlayerAction.block.name
            ? highlightBlockZone(p.id)
            : null;
        p.action = PlayerAction.none;
      }
      // );
    } else {
      status = GameStatus.choosing;
      clearActionIcons();
      grid.clearHighlights();
      _removeDeadPlayers();
    }
  }

  void _showMockActions() {
    for (final player in players) {
      if (player.target != null &&
          player.action.name != PlayerAction.none.name) {
        showActionOnCell(player.target!, player.action);
        if (player.action.name == PlayerAction.move.name) {
          player.moveToCell(player.target!);
        }
      }
    }
  }

  void selectAction(String playerId, PlayerAction action) {
    if (status == GameStatus.showing) return;
    final player = getPlayerById(playerId);
    player.action = action;

    grid.clearHighlights();

    switch (action) {
      case PlayerAction.move:
        highlightMoveZone(playerId);
        break;
      case PlayerAction.melee:
        highlightMeleeZone(playerId);
        break;
      case PlayerAction.shoot:
        highlightShootZone(playerId);
        break;
      case PlayerAction.block:
        highlightBlockZone(playerId);
        break;
      case PlayerAction.none:
        break;
    }
  }

  void selectTarget(String playerId, Vector2 cell) {
    final player = getPlayerById(playerId);
    player.target = cell;
  }

  Player getPlayerById(String id) {
    return players.firstWhere((p) => p.id == id);
  }

  void _removeDeadPlayers() {
    players.removeWhere((player) {
      if (player.lives <= 0) {
        remove(player);
        return true;
      }
      return false;
    });
  }

  void showActionOnCell(Vector2 cell, PlayerAction action) {
    final pixelPos = Vector2(
      cell.x * cellSize + cellSize / 2 + 2,
      cell.y * cellSize + cellSize / 2 + 2,
    );

    final icon = ActionIcon(
      action: action,
      position: pixelPos,
      size: cellSize * 0.8,
    );

    actionIcons.add(icon);
    add(icon);
  }

  void clearActionIcons() {
    for (final icon in actionIcons) {
      remove(icon);
    }
    actionIcons.clear();
  }

  void highlightMoveZone(String playerId) {
    final player = getPlayerById(playerId);
    grid.action = PlayerAction.move;
    grid.attackedCell = false;

    final gridPos = _gridPosition(player);

    final neighbors = <Vector2>[];

    void add(double x, double y) {
      if (_isValidCell(x, y)) neighbors.add(Vector2(x, y));
    }

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        add(gridPos.x + dx, gridPos.y + dy);
      }
    }

    add(gridPos.x + 2, gridPos.y);
    add(gridPos.x - 2, gridPos.y);
    add(gridPos.x, gridPos.y + 2);
    add(gridPos.x, gridPos.y - 2);

    grid.highlightCells(neighbors);
  }

  void highlightMeleeZone(String playerId) {
    final player = getPlayerById(playerId);
    grid.action = PlayerAction.melee;
    grid.attackedCell = true;

    final gridPos = _gridPosition(player);
    final neighbors = <Vector2>[];

    void add(double x, double y) {
      if (_isValidCell(x, y)) neighbors.add(Vector2(x, y));
    }

    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        if (dx == 0 && dy == 0) continue;
        add(gridPos.x + dx, gridPos.y + dy);
      }
    }

    grid.highlightCells(neighbors);
  }

  void highlightShootZone(String playerId) {
    final player = getPlayerById(playerId);
    grid.action = PlayerAction.shoot;
    grid.attackedCell = false;

    final gridPos = _gridPosition(player);
    final neighbors = <Vector2>[];

    void add(double x, double y) {
      if (_isValidCell(x, y)) neighbors.add(Vector2(x, y));
    }

    final offsets = [
      Vector2(3, 0),
      Vector2(-3, 0),
      Vector2(0, 3),
      Vector2(0, -3),
      Vector2(2, 2),
      Vector2(-2, -2),
      Vector2(2, -2),
      Vector2(-2, 2),
    ];

    for (final o in offsets) {
      add(gridPos.x + o.x, gridPos.y + o.y);
    }

    grid.highlightCells(neighbors);
  }

  void highlightBlockZone(String playerId) {
    final player = getPlayerById(playerId);
    grid.action = PlayerAction.block;
    grid.attackedCell = false;

    final gridPos = _gridPosition(player);
    grid.showShield(gridPos);
  }

  Vector2 _gridPosition(Player player) {
    return Vector2(
      (player.position.x / cellSize).floorToDouble(),
      (player.position.y / cellSize).floorToDouble(),
    );
  }

  bool _isValidCell(double x, double y) {
    return x >= 0 && x < gridSize && y >= 0 && y < gridSize;
  }

  void validateTurn(String playerId) {
    final player = getPlayerById(playerId);

    if (status == GameStatus.showing) return;

    // if (player.action == PlayerAction.none) return;

    // status = GameStatus.showing; // TODO

    if (player.action == PlayerAction.move ||
        player.action == PlayerAction.shoot) {
      player.target = grid.selectedCell;
    } else {
      final selfCell = Vector2(
        (player.position.x / cellSize).floorToDouble(),
        (player.position.y / cellSize).floorToDouble(),
      );
      player.target = selfCell;
    }
  }

  @override
  Color backgroundColor() => const Color(0xFF101010);
}
