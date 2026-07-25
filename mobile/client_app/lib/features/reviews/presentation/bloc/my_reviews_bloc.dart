import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/my_review_entity.dart';
import '../../domain/usecases/get_my_reviews_use_case.dart';

part 'my_reviews_event.dart';
part 'my_reviews_state.dart';

class MyReviewsBloc extends Bloc<MyReviewsEvent, MyReviewsState> {
  final GetMyReviewsUseCase _getMyReviews;

  MyReviewsBloc(this._getMyReviews) : super(const MyReviewsState()) {
    on<GetMyReviewsEvent>(_load);
    on<RefreshMyReviewsEvent>(_refresh);
  }

  Future<void> _load(
    GetMyReviewsEvent event,
    Emitter<MyReviewsState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearError: true));
    await _request(emit, isRefresh: false);
  }

  Future<void> _refresh(
    RefreshMyReviewsEvent event,
    Emitter<MyReviewsState> emit,
  ) async {
    if (state.isRefreshing) return;
    emit(state.copyWith(isRefreshing: true, clearError: true));
    await _request(emit, isRefresh: true);
  }

  Future<void> _request(
    Emitter<MyReviewsState> emit, {
    required bool isRefresh,
  }) async {
    try {
      final result = await _getMyReviews();
      emit(
        state.copyWith(
          companyReviews: result.companies,
          serviceReviews: result.services,
          isLoading: false,
          isRefreshing: false,
          hasLoaded: true,
          clearError: true,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          hasLoaded: true,
          errorMessage: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          hasLoaded: true,
          errorMessage: 'could_not_load_your_reviews',
        ),
      );
    }
  }
}
