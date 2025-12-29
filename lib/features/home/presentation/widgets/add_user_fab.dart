import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_tab_cubit.dart';
import '../../../users/bloc/users_cubit.dart';

class AddUserFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        if (state.currentIndex != 0) return SizedBox.shrink();
        return FloatingActionButton(
          onPressed: () async {
            final name = await showDialog<String>(
              context: context,
              builder: (context) {
                String? inputName;
                return AlertDialog(
                  title: Text('Add User'),
                  content: TextField(
                    onChanged: (value) => inputName = value,
                    decoration: InputDecoration(hintText: 'Enter user name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, inputName),
                      child: Text('Add'),
                    ),
                  ],
                );
              },
            );
            if (name != null && name.isNotEmpty) {
              context.read<UsersCubit>().addUser(name);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('User $name added')));
            }
          },
          child: Icon(Icons.add),
        );
      },
    );
  }
}
