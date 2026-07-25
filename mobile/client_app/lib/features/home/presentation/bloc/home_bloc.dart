import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/usecases/home_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeUseCase getHomeUseCase;

  HomeBloc(this.getHomeUseCase) : super(const HomeInitial()) {
    on<GetHomeEvent>(_onGetHome);
  }

  Future<void> _onGetHome(GetHomeEvent event, Emitter<HomeState> emit) async {
    try {
      emit(const HomeLoading());

      final result = await getHomeUseCase();

      emit(HomeLoaded(result));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
