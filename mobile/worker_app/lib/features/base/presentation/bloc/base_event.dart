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

class UpdateOfferStatus extends BaseEvent {

  final String offerState;

  const UpdateOfferStatus(this.offerState);
  @override
  List<Object> get props => [offerState];
}

class ControlBottomNavbarVisibility extends BaseEvent {

  final bool isShown;

  const ControlBottomNavbarVisibility(this.isShown);
  @override
  List<Object> get props => [isShown];
}