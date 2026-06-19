import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_bookings_usecase.dart';

part 'bookings_event.dart';
part 'bookings_state.dart';

class BookingsBloc extends Bloc<BookingsEvent, BookingsState> {
  final GetBookingsUseCase getBookings;

  BookingsBloc(this.getBookings) : super(BookingsState.initial()) {
    on(_getBookings);

    on<RefreshBookings>(_refresh);

    on<LoadMoreBookings>(_loadMore);

    on<ChangeTab>(_changeTab);
  }

  Future _getBookings(GetBookings event, Emitter emit) async {
    emit(state.copyWith(loading: true, error: null));

    try {
      final result = await getBookings();

      emit(state.copyWith(loading: false, bookings: result));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future _refresh(RefreshBookings event, Emitter emit) async {
    emit(state.copyWith(refreshing: true));

    try {
      final result = await getBookings();

      emit(state.copyWith(bookings: result, refreshing: false));
    } catch (_) {
      emit(state.copyWith(refreshing: false));
    }
  }

  Future _loadMore(LoadMoreBookings event, Emitter emit) async {
    if (state.loadingMore || state.hasReachedMax) {
      return;
    }

    emit(state.copyWith(loadingMore: true));

    await Future.delayed(const Duration(milliseconds: 600));

    emit(state.copyWith(loadingMore: false));
  }

  void _changeTab(ChangeTab event, Emitter emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }
}
