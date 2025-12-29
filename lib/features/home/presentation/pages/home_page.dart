import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_tab_cubit.dart';
import '../widgets/top_tab_switcher.dart';
import '../widgets/add_user_fab.dart';
import 'chat_history_page.dart';
import '../../../users/presentation/users_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: AddUserFab(),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(floating: true, snap: true, title: TopTabSwitcher()),
          SliverFillRemaining(
            child: BlocBuilder<HomeTabCubit, HomeTabState>(
              builder: (context, state) {
                return IndexedStack(
                  index: state.currentIndex,
                  children: [UsersListPage(), ChatHistoryPage()],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
