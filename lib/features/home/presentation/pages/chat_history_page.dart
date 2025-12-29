import 'package:flutter/material.dart';

class ChatHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: PageStorageKey('chat_history'),
      itemCount: 0, // Placeholder, no chat history yet
      itemBuilder: (context, index) {
        // Placeholder for chat history items
        return ListTile(
          title: Text('Chat with User'),
          subtitle: Text('Last message...'),
          trailing: Text('Time'),
        );
      },
    );
  }
}
