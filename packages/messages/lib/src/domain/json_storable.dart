// FromMap
import 'package:collab/collab.dart';

typedef FromMap<T> = T Function(Map<String, dynamic> map);

T genericFromMap<T>(Map<String, dynamic> map) {
  final creator = _fromMapConstructors[T];

  if (creator == null) {
    throw UnimplementedError();
  }

  return creator(map) as T;
}

// ToMap
typedef ToMap<T> = Map<String, dynamic> Function(T object);

Map<String, dynamic> genericToMap<T>(T object) {
  final creator = _toMapConstructors[T];

  if (creator == null) {
    throw UnimplementedError();
  }

  return creator(object);
}

//
final Map<Type, FromMap<dynamic>> _fromMapConstructors = {
  // Example: (map) => Example.fromMap(map),
  Mail: (map) => Mail.fromMap(map),
};

final Map<Type, ToMap<dynamic>> _toMapConstructors = {
  // Example: (object) => Example.toMap(object),
  Mail: (object) => Mail.toMap(object),
};
