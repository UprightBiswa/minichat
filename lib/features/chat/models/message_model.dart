enum MessageType { sender, receiver }

class Message {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;

  Message(this.text, this.type, {DateTime? timestamp})
    : id = DateTime.now().millisecondsSinceEpoch.toString(),
      timestamp = timestamp ?? DateTime.now();
}
