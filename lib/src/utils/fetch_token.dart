import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<String?> fetchToken(FlutterSecureStorage storage) async {
  final String? token = await storage.read(key: 'token');
  if (token != null) {
    debugPrint('Token fetched : $token');
  }
  return token;
}
