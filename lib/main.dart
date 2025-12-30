import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minichatapp/dummy_data_generator.dart';
import 'core/theme/app_theme.dart';
import 'features/home/bloc/home_tab_cubit.dart';
import 'features/users/bloc/users_cubit.dart';
import 'main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final cubit = UsersCubit();
            DummyDataGenerator.loadInitialData(cubit);
            return cubit;
          },
        ),
        BlocProvider(create: (context) => HomeTabCubit()),
      ],
      child: MaterialApp(
        title: 'Mini Chat App',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        home: MainScreen(),
      ),
    );
  }
}
