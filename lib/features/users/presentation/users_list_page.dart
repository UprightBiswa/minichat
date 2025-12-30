import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/users_cubit.dart';
import '../../../core/utils/time_formatter.dart';
import '../../chat/presentation/chat_screen.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        if (state.users.isEmpty) {
          return Center(child: Text("No users added yet. Tap + to add."));
        } else {
          return ListView.builder(
            key: PageStorageKey('users'),
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return ListTile(
                leading: Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFFAB47BC), Color(0xFF7B1FA2)],
                        ),
                      ),
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: user.isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                      ),
                    ),
                  ],
                ),
                title: Text(
                  user.name,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  user.isOnline
                      ? 'Online'
                      : (user.lastTime != null
                            ? 'Last seen ${formatTime(user.lastTime!)}'
                            : 'Offline'),
                  style: TextStyle(
                    fontSize: 12,
                    color: user.isOnline ? Colors.green : Colors.grey,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(user: user),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
