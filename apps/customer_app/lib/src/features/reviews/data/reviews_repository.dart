import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';

/// How to order a product's reviews (backend `sort`).
enum ReviewSort {
  recent('recent', 'Most recent'),
  helpful('helpful', 'Most helpful');

  const ReviewSort(this.wire, this.label);
  final String wire;
  final String label;
}

/// Product ratings & reviews (`/api/v1/products/{id}/ratings`).
class ReviewsRepository {
  ReviewsRepository(this._api);

  final ReviewsApi _api;

  Future<ReviewSummary> list(
    int productId, {
    ReviewSort sort = ReviewSort.recent,
  }) => guard(
    () async => (await _api.listProductRatings(
      productId: productId,
      sort: sort.wire,
    )).data!.toDomain(),
  );

  /// Creates or replaces the caller's review (one per product).
  Future<Review> rate(int productId, {required int stars, String? comment}) =>
      guard(
        () async => (await _api.rateProduct(
          productId: productId,
          ratingIn: RatingIn(
            stars: stars,
            comment: comment == null || comment.trim().isEmpty
                ? null
                : comment.trim(),
          ),
        )).data!.toDomain(),
      );

  Future<void> deleteMine(int productId) =>
      guard(() => _api.deleteMyRating(productId: productId));

  /// Toggles the caller's "helpful" vote; returns (voted, new count).
  Future<(bool, int)> toggleHelpful(int productId, int reviewId) =>
      guard(() async {
        final r = (await _api.toggleReviewHelpful(
          productId: productId,
          ratingId: reviewId,
        )).data!;
        return (r.voted, r.helpfulCount);
      });
}
