import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/user_model.dart';

class UsersState {
  final List<User> users;

  UsersState(this.users);

  UsersState copyWith({List<User>? users}) {
    return UsersState(users ?? this.users);
  }
}

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersState([]));

  void addUser(String name) {
    final isOnline = DateTime.now().millisecondsSinceEpoch % 2 == 0;
    final updatedUsers = List<User>.from(state.users)
      ..add(User(name: name, isOnline: isOnline));
    emit(UsersState(updatedUsers));
  }

  void updateUser(User updated) {
    final updatedUsers = state.users
        .map((user) => user.id == updated.id ? updated.copyWith() : user)
        .toList();
    emit(UsersState(updatedUsers));
  }
}
