import 'dart:math';
import '../../chat/models/message_model.dart';

class User {
  final String id;
  final String name;
  final bool isOnline;
  final String? lastMessage;
  final DateTime? lastTime;
  final int unreadCount;
  final List<Message> messages;

  User({
    String? id,
    required this.name,
    this.isOnline = false,
    this.lastMessage,
    this.lastTime,
    this.unreadCount = 0,
    this.messages = const [],
  }) : id =
           id ??
           (DateTime.now().microsecondsSinceEpoch.toString() +
               Random().nextInt(10000).toString());

  User copyWith({
    String? name,
    bool? isOnline,
    String? lastMessage,
    DateTime? lastTime,
    int? unreadCount,
    List<Message>? messages,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
      unreadCount: unreadCount ?? this.unreadCount,
      messages: messages ?? this.messages,
    );
  }
}
