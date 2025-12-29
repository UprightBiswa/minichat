import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                leading: CircleAvatar(child: Text(user.name[0])),
                title: Text(user.name),
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
