enum GameStatus { starting, choosing, showing, ended }

GameStatus gameStatusMapToEnum(Map<String, dynamic> map) {
  return GameStatus.values.firstWhere(
    (s) => s.name == map['status'],
    orElse: () => GameStatus.starting,
  );
}

Map<String, dynamic> gameStatusObjectToMap(GameStatus object) {
  return {'status': object.name};
}
