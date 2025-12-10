import 'package:flutter/widgets.dart';

typedef MailId = String;

class Mail {
  const Mail({
    required this.id,
    required this.message,
    required this.userName,
    required this.userId,
    this.timestamp,
  });

  final MailId id;
  final String message;
  final String userName;
  final String userId;
  final String? timestamp;

  Mail copyWith({
    MailId? id,
    String? message,
    String? userName,
    String? userId,
    ValueGetter<String?>? timestamp,
  }) {
    return Mail(
      id: id ?? this.id,
      message: message ?? this.message,
      userName: userName ?? this.userName,
      userId: userId ?? this.userId,
      timestamp: timestamp != null ? timestamp() : this.timestamp,
    );
  }
}
