import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../bloc/users_cubit.dart';
import '../models/user_model.dart';
import '../../chat/presentation/chat_screen.dart';

class UsersListPage extends StatelessWidget {
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
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Text(
                        user.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: user.isOnline ? Colors.green : Colors.grey,
                          shape: BoxShape.circle,
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
                  user.isOnline ? 'Online' : 'Offline',
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
