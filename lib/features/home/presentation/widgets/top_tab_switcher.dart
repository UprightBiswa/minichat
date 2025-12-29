import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minichatapp/core/theme/app_colors.dart';
import 'package:minichatapp/core/theme/app_text_styles.dart';
import '../../bloc/home_tab_cubit.dart';

class TopTabSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.tabSwitcherBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<HomeTabCubit>().switchToTab(0),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: state.currentIndex == 0
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Users',
                      style: AppTextStyles.tabText.copyWith(
                        color: state.currentIndex == 0
                            ? AppColors.tabSwitcherActiveText
                            : AppColors.tabSwitcherInactiveText,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => context.read<HomeTabCubit>().switchToTab(1),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: state.currentIndex == 1
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Chat History',
                      style: AppTextStyles.tabText.copyWith(
                        color: state.currentIndex == 1
                            ? AppColors.tabSwitcherActiveText
                            : AppColors.tabSwitcherInactiveText,
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
