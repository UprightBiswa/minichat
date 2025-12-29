import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:minichatapp/core/utils/time_formatter.dart';
import '../../../users/bloc/users_cubit.dart';
import '../../../users/models/user_model.dart';

class ChatHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, UsersState>(
      builder: (context, state) {
        return ListView.builder(
          key: PageStorageKey('chat_history'),
          itemCount: state.users.length,
          itemBuilder: (context, index) {
            final user = state.users[index];
            return ListTile(
              title: Text(user.name),
              subtitle: Text(user.lastMessage ?? 'No messages yet'),
              trailing: Text(
                user.lastTime != null ? formatTime(user.lastTime!) : '',
              ),
              onTap: () =>
                  Navigator.pushNamed(context, '/chat', arguments: user),
            );
          },
        );
      },
    );
  }
}
