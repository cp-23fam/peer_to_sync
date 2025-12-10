import 'dart:convert';

import 'package:flutter/widgets.dart';

typedef MailId = String;

class Mail {
  factory Mail.fromMap(Map<String, dynamic> map) {
    return Mail(
      id: map['id'],
      message: map['message'] ?? '',
      userName: map['userName'] ?? '',
      userId: map['userId'] ?? '',
      timestamp: map['timestamp'],
    );
  }

  factory Mail.fromJson(String source) => Mail.fromMap(json.decode(source));

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

  static Map<String, dynamic> toMap(Mail mail) {
    return {
      'id': mail.id,
      'message': mail.message,
      'userName': mail.userName,
      'userId': mail.userId,
      'timestamp': mail.timestamp,
    };
  }

  String toJson() => json.encode(toMap(this));
}
