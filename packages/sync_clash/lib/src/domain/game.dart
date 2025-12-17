import 'dart:convert';

import 'package:sync_clash/src/domain/player_model.dart';

class Game {
  factory Game.fromMap(Map<String, dynamic> map) {
    final players = map['players'] as List<dynamic>;
    final blocked = map['blocked'] as List<dynamic>;

    return Game(
      timestamp: map['timestamp'] as int,
      players: players.map((p) => PlayerModel.fromMap(p)).toList(),
      blocked: blocked.cast<String>(),
    );
  }

  factory Game.fromJson(String source) =>
      Game.fromMap(json.decode(source) as Map<String, dynamic>);

  Game({required this.timestamp, required this.players, required this.blocked});

  final int timestamp;
  final List<PlayerModel> players;
  final List<String> blocked;

  Game copyWith({
    String? id,
    int? timestamp,
    List<PlayerModel>? players,
    List<String>? blocked,
  }) {
    return Game(
      timestamp: timestamp ?? this.timestamp,
      players: players ?? this.players,
      blocked: blocked ?? this.blocked,
    );
  }

  static Map<String, dynamic> toMap(Game game) {
    return <String, dynamic>{
      'timestamp': game.timestamp,
      'players': game.players.map((x) => x.toMap()).toList(),
      'blocked': game.blocked,
    };
  }

  String toJson() => json.encode(toMap(this));
}
