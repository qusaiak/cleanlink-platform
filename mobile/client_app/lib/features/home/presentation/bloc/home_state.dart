part of 'home_bloc.dart';

class HomeState extends Equatable {
  final bool isLoading;

  final HomeEntity? home;

  final String? error;

  const HomeState({this.isLoading = false, this.home, this.error});

  HomeState copyWith({bool? isLoading, HomeEntity? home, String? error}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      home: home ?? this.home,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, home, error];
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading() : super(isLoading: true);
}

final class HomeLoaded extends HomeState {
  const HomeLoaded(HomeEntity home) : super(home: home);
}

final class HomeError extends HomeState {
  const HomeError(String message) : super(error: message);
}
