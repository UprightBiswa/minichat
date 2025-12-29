class User {
  final String id;
  final String name;
  final String? lastMessage;
  final DateTime? lastTime;

  User({required this.name, this.lastMessage, this.lastTime})
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  User copyWith({String? name, String? lastMessage, DateTime? lastTime}) {
    return User(
      name: name ?? this.name,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
    );
  }
}
