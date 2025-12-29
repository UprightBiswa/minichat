import 'package:flutter_bloc/flutter_bloc.dart';

class HomeTabState {
  final int currentIndex;

  HomeTabState(this.currentIndex);

  HomeTabState copyWith({int? currentIndex}) {
    return HomeTabState(currentIndex ?? this.currentIndex);
  }
}

class HomeTabCubit extends Cubit<HomeTabState> {
  HomeTabCubit() : super(HomeTabState(0));

  void switchToTab(int index) {
    emit(HomeTabState(index));
  }
}
