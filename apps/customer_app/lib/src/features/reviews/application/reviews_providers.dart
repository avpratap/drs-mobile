import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/reviews_repository.dart';

part 'reviews_providers.g.dart';

@Riverpod(keepAlive: true)
ReviewsRepository reviewsRepository(Ref ref) =>
    ReviewsRepository(ref.watch(drsApiProvider).getReviewsApi());

@riverpod
Future<ReviewSummary> productReviews(
  Ref ref,
  int productId, {
  ReviewSort sort = ReviewSort.recent,
}) => ref.watch(reviewsRepositoryProvider).list(productId, sort: sort);
