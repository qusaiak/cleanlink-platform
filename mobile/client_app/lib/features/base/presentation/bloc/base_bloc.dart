import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'base_event.dart';
part 'base_state.dart';

class BaseBloc extends Bloc<BaseEvent, BaseState> {
  BaseBloc()
    : super(
        const BaseState().copyWith(
          baseStatus: BaseStatus.initial,
          isShown: true,
          isOfferBadgeShown: false,
          currentIndex: 0,
        ),
      ) {
    on<ChangeBottomNavBarIndex>(onChangeBottomNavBarIndex);
    on<UpdateOfferStatus>(onUpdateOfferStatus);
    on<ControlBottomNavbarVisibility>(onControlBottomNavbarVisibility);
  }

  void onChangeBottomNavBarIndex(
    ChangeBottomNavBarIndex event,
    Emitter<BaseState> emit,
  ) async {
    if (event.newIndex == 3) {
      emit(state.copyWith(isOfferBadgeShown: false));
    }
    emit(
      state.copyWith(
        baseStatus: BaseStatus.changeBottomNavBarIndex,
        currentIndex: event.newIndex,
      ),
    );
  }

  void onUpdateOfferStatus(
    UpdateOfferStatus event,
    Emitter<BaseState> emit,
  ) async {
    bool isOfferBadgeShown = event.offerState == "1" ? true : false;
    emit(state.copyWith(isOfferBadgeShown: isOfferBadgeShown));
  }

  void onControlBottomNavbarVisibility(
    ControlBottomNavbarVisibility event,
    Emitter<BaseState> emit,
  ) async {
    emit(
      state.copyWith(
        baseStatus: BaseStatus.controlBottomNavBar,
        isShown: event.isShown,
      ),
    );
  }
}
