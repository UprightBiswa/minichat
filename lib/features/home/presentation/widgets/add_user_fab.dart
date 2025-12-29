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
                final TextEditingController controller =
                    TextEditingController();
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    'New Chat',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: TextField(
                    controller: controller,
                    autofocus: true,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Enter user name',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final text = controller.text.trim();
                        if (text.isNotEmpty) {
                          Navigator.pop(context, text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
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
