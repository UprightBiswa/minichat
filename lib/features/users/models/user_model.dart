class User {
  final String id;
  final String name;
  final bool isOnline;
  final String? lastMessage;
  final DateTime? lastTime;

  User({required this.name, this.isOnline = false, this.lastMessage, this.lastTime})
    : id = DateTime.now().millisecondsSinceEpoch.toString();

  User copyWith({String? name, bool? isOnline, String? lastMessage, DateTime? lastTime}) {
    return User(
      name: name ?? this.name,
      isOnline: isOnline ?? this.isOnline,
      lastMessage: lastMessage ?? this.lastMessage,
      lastTime: lastTime ?? this.lastTime,
    );
  }
}
