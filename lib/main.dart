import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/home/bloc/home_tab_cubit.dart';
import 'features/users/bloc/users_cubit.dart';
import 'features/chat/models/message_model.dart';
import 'main_screen.dart';

void main() {
  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = UsersCubit();
            // Add dummy users
            cubit.addUser('Alice Johnson');
            cubit.addUser('Bob Smith');
            cubit.addUser('Charlie Brown');
            // Add dummy messages
            Future.microtask(() {
              final now = DateTime.now();

              // User 1: Alice - Recent conversation
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
                  lastTime: DateTime.now().subtract(Duration(minutes: 2)),
                  unreadCount: 2,
                  messages: aliceMessages,
                ),
              );

              // User 2: Bob - Older conversation
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
                  lastTime: DateTime.now().subtract(Duration(minutes: 10)),
                  unreadCount: 0,
                  messages: bobMessages,
                ),
              );

              // User 3: Charlie - Unread messages
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
                  lastTime: DateTime.now().subtract(Duration(minutes: 30)),
                  unreadCount: 5,
                  messages: charlieMessages,
                ),
              );
            });
            return cubit;
          },
        ),
        BlocProvider(create: (context) => HomeTabCubit()),
      ],
      child: MaterialApp(
        title: 'Mini Chat App',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: MainScreen(),
      ),
    );
  }
}
