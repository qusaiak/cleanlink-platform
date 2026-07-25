part of 'base_bloc.dart';

sealed class BaseEvent extends Equatable {
  const BaseEvent();
}

class ChangeBottomNavBarIndex extends BaseEvent {
  final int newIndex;

  const ChangeBottomNavBarIndex(this.newIndex);
  @override
  List<Object> get props => [newIndex];
}

class ControlBottomNavbarVisibility extends BaseEvent {
  final bool isShown;

  const ControlBottomNavbarVisibility(this.isShown);
  @override
  List<Object> get props => [isShown];
}
