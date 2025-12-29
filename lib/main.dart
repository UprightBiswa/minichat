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
        BlocProvider(create: (context) => UsersCubit()),
        BlocProvider(create: (context) => HomeTabCubit()),
      ],
      child: MaterialApp(
        title: 'Mini Chat App',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: MainScreen(),
      ),
    );
  }
}
