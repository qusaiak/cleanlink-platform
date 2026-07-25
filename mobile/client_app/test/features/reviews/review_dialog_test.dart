import 'package:client_app/features/reviews/domain/entities/review_submission_entity.dart';
import 'package:client_app/features/reviews/domain/entities/my_review_entity.dart';
import 'package:client_app/features/reviews/domain/entities/reviewable_type.dart';
import 'package:client_app/features/reviews/domain/repositories/reviews_repo.dart';
import 'package:client_app/features/reviews/domain/usecases/add_review_use_case.dart';
import 'package:client_app/features/reviews/presentation/bloc/review_bloc.dart';
import 'package:client_app/features/reviews/presentation/widgets/review_dialog.dart';
import 'package:client_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final type in ReviewableType.values) {
    testWidgets(
      '$type success closes dialog and requests the correct refresh',
      (tester) async {
        final repo = _ImmediateReviewsRepo();
        var refreshRequested = false;

        await tester.pumpWidget(
          BlocProvider(
            create: (_) => ReviewBloc(AddReviewUseCase(repo)),
            child: ScreenUtilInit(
              designSize: const Size(390, 844),
              builder: (_, _) => MaterialApp(
                locale: const Locale('en'),
                supportedLocales: AppLocalizations.supportedLocales,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                home: Builder(
                  builder: (context) => Scaffold(
                    body: ElevatedButton(
                      onPressed: () => showReviewDialog(
                        context: context,
                        type: type,
                        id: 17,
                        onSuccess: () => refreshRequested = true,
                      ),
                      child: const Text('Open review'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open review'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.star_border_rounded).first);
        await tester.tap(find.text('Submit Review'));
        await tester.pumpAndSettle();

        expect(refreshRequested, isTrue);
        expect(repo.lastParams?.type, type);
        expect(repo.lastParams?.id, 17);
        expect(find.text('Write a Review'), findsNothing);
      },
    );
  }
}

class _ImmediateReviewsRepo implements ReviewsRepo {
  AddReviewParams? lastParams;

  @override
  Future<ReviewSubmissionEntity> addReview(AddReviewParams params) async {
    lastParams = params;
    return const ReviewSubmissionEntity(
      status: 211,
      message: 'Review submitted successfully',
      reviewId: 1,
    );
  }

  @override
  Future<MyReviewsEntity> getMyReviews() async => const MyReviewsEntity();
}
