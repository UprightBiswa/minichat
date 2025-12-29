import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_tab_cubit.dart';

class TopTabSwitcher extends StatelessWidget {
  const TopTabSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Container(
          height: 45,
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<HomeTabCubit>().switchToTab(0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: state.currentIndex == 0
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: state.currentIndex == 0
                          ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Users',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: state.currentIndex == 0
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<HomeTabCubit>().switchToTab(1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: state.currentIndex == 1
                          ? Colors.white
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: state.currentIndex == 1
                          ? [BoxShadow(color: Colors.black12, blurRadius: 4)]
                          : [],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Chat History',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: state.currentIndex == 1
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
