import 'package:minichatapp/features/chat/models/message_model.dart';
import 'package:minichatapp/features/users/bloc/users_cubit.dart';


class DummyDataGenerator {
  static void loadInitialData(UsersCubit cubit) {
    // Add users
    cubit.addUser('Alice Johnson');
    cubit.addUser('Bob Smith');
    cubit.addUser('Charlie Brown');

    // Add messages and update states
    final now = DateTime.now();

    // User 1: Alice (Online)
    final aliceMessages = [
      Message(
        'Hi Alice!',
        MessageType.sender,
        timestamp: now.subtract(Duration(days: 1)),
      ),
      Message(
        'Hey! How are you?',
        MessageType.receiver,
        timestamp: now.subtract(Duration(days: 1, minutes: 5)),
      ),
      Message(
        'I am good, thanks.',
        MessageType.sender,
        timestamp: now.subtract(Duration(minutes: 5)),
      ),
      Message(
        'See you tomorrow!',
        MessageType.receiver,
        timestamp: now.subtract(Duration(minutes: 2)),
      ),
    ];

    cubit.updateUser(
      cubit.state.users[0].copyWith(
        lastMessage: 'See you tomorrow!',
        lastTime: now.subtract(Duration(minutes: 2)),
        unreadCount: 2,
        messages: aliceMessages,
        isOnline: true,
      ),
    );

    // User 2: Bob (Offline)
    final bobMessages = [
      Message(
        'Can you help me with Flutter?',
        MessageType.receiver,
        timestamp: now.subtract(Duration(minutes: 15)),
      ),
      Message(
        'Sure, what do you need?',
        MessageType.sender,
        timestamp: now.subtract(Duration(minutes: 12)),
      ),
      Message(
        'Thanks for the help',
        MessageType.receiver,
        timestamp: now.subtract(Duration(minutes: 10)),
      ),
    ];

    cubit.updateUser(
      cubit.state.users[1].copyWith(
        lastMessage: 'Thanks for the help',
        lastTime: now.subtract(Duration(minutes: 10)),
        unreadCount: 0,
        messages: bobMessages,
        isOnline: false,
      ),
    );

    // User 3: Charlie (Offline)
    final charlieMessages = List.generate(
      5,
      (index) => Message(
        'Message ${index + 1}',
        MessageType.receiver,
        timestamp: now.subtract(Duration(minutes: 35 - index * 2)),
      ),
    );

    cubit.updateUser(
      cubit.state.users[2].copyWith(
        lastMessage: 'Message 5',
        lastTime: now.subtract(Duration(minutes: 30)),
        unreadCount: 5,
        messages: charlieMessages,
        isOnline: false,
      ),
    );
  }
}
