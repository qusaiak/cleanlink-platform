part of 'base_bloc.dart';

enum BaseStatus { initial, changeBottomNavBarIndex, controlBottomNavBar }

class BaseState extends Equatable {
  final BaseStatus? baseStatus;
  final bool? isShown;
  final int? currentIndex;
  final bool? isOfferBadgeShown;

  const BaseState({
    this.baseStatus,
    this.isShown,
    this.currentIndex,
    this.isOfferBadgeShown,
  });

  BaseState copyWith({
    BaseStatus? baseStatus,
    bool? isShown,
    int? currentIndex,
    bool? isOfferBadgeShown,
  }) => BaseState(
    baseStatus: baseStatus ?? this.baseStatus,
    isShown: isShown ?? this.isShown,
    currentIndex: currentIndex ?? this.currentIndex,
    isOfferBadgeShown: isOfferBadgeShown ?? this.isOfferBadgeShown,
  );

  @override
  List<Object?> get props => [
    baseStatus,
    isShown,
    currentIndex,
    isOfferBadgeShown,
  ];
}
