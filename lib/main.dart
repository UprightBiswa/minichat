import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_text_styles.dart';
import 'features/home/bloc/home_tab_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/users/bloc/users_cubit.dart';
import 'main_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
              cubit.updateUser(
                cubit.state.users[0].copyWith(
                  lastMessage: 'See you tomorrow',
                  lastTime: DateTime.now().subtract(Duration(hours: 2)),
                ),
              );
              cubit.updateUser(
                cubit.state.users[1].copyWith(
                  lastMessage: 'Hello!',
                  lastTime: DateTime.now().subtract(Duration(days: 1)),
                ),
              );
              cubit.updateUser(
                cubit.state.users[2].copyWith(
                  lastMessage: 'How are you?',
                  lastTime: DateTime.now().subtract(Duration(minutes: 30)),
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
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: MainScreen(),
      ),
    );
  }
}
