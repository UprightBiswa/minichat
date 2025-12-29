import 'package:flutter_test/flutter_test.dart';
import 'package:minichatapp/features/users/bloc/users_cubit.dart';
import 'package:minichatapp/features/users/models/user_model.dart';

void main() {
  group('UsersCubit', () {
    late UsersCubit usersCubit;

    setUp(() {
      usersCubit = UsersCubit();
    });

    tearDown(() {
      usersCubit.close();
    });

    test('initial state has empty users list', () {
      expect(usersCubit.state.users, isEmpty);
    });

    test('addUser adds a user to the list', () {
      usersCubit.addUser('Alice');
      expect(usersCubit.state.users.length, 1);
      expect(usersCubit.state.users.first.name, 'Alice');
    });

    test('addUser adds multiple users', () {
      usersCubit.addUser('Alice');
      usersCubit.addUser('Bob');
      expect(usersCubit.state.users.length, 2);
      expect(usersCubit.state.users[0].name, 'Alice');
      expect(usersCubit.state.users[1].name, 'Bob');
    });
  });
}
