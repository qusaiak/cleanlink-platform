import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/review_submission_entity.dart';
import '../../domain/usecases/add_review_use_case.dart';

part 'review_event.dart';
part 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final AddReviewUseCase addReview;

  ReviewBloc(this.addReview) : super(const ReviewState()) {
    on<SubmitReviewEvent>(_onSubmitReview);
    on<ResetReviewEvent>((event, emit) => emit(const ReviewState()));
  }

  Future<void> _onSubmitReview(
    SubmitReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    if (state.isSubmitting) return;
    emit(ReviewState(isSubmitting: true, params: event.params));
    try {
      final result = await addReview(event.params);
      emit(ReviewState(result: result, params: event.params));
    } catch (error) {
      final message = switch (error) {
        Failure failure => failure.message,
        FormatException formatException => formatException.message,
        _ => error.toString().replaceFirst('Exception: ', ''),
      };
      emit(ReviewState(errorMessage: message, params: event.params));
    }
  }
}
