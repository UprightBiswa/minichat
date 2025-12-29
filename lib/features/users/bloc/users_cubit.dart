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
    final updatedUsers = List<User>.from(state.users)..add(User(name: name));
    emit(UsersState(updatedUsers));
  }

  void updateUser(User updated) {
    final updatedUsers = state.users
        .map((user) => user.id == updated.id ? updated : user)
        .toList();
    emit(UsersState(updatedUsers));
  }
}
