import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home_tab_cubit.dart';

class TopTabSwitcher extends StatefulWidget {
  @override
  _TopTabSwitcherState createState() => _TopTabSwitcherState();
}

class _TopTabSwitcherState extends State<TopTabSwitcher>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchTab(int index) {
    context.read<HomeTabCubit>().switchToTab(index);
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeTabCubit, HomeTabState>(
      builder: (context, state) {
        return Container(
          height: 40,
          child: Stack(
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => _switchTab(0),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Users'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _switchTab(1),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text('Chat History'),
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                left: state.currentIndex == 0 ? 0 : 80,
                top: 32,
                child: Container(
                  width: 80,
                  height: 2,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
