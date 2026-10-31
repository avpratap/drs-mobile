import 'package:meta/meta.dart';

enum ReviewStatus {
  approved,
  pending,
  rejected,
  unknown;

  static ReviewStatus parse(String raw) => switch (raw) {
    'approved' => approved,
    'pending' => pending,
    'rejected' => rejected,
    _ => unknown,
  };
}

/// A product review. Reviewer identity is not exposed for other people's
/// reviews (the backend withholds it); [mine] marks the caller's own.
@immutable
class Review {
  const Review({
    required this.id,
    required this.productId,
    required this.stars,
    required this.status,
    this.comment,
    this.verifiedPurchase = false,
    this.helpfulCount = 0,
    this.adminReply,
    this.mine = false,
  });

  final int id;
  final int productId;
  final int stars;
  final String? comment;
  final ReviewStatus status;
  final bool verifiedPurchase;
  final int helpfulCount;
  final String? adminReply;
  final bool mine;
}

/// Rating summary over approved reviews, plus the visible reviews.
@immutable
class ReviewSummary {
  const ReviewSummary({
    required this.productId,
    required this.count,
    required this.average,
    required this.distribution,
    required this.reviews,
  });

  final int productId;
  final int count;
  final double average;

  /// stars (1..5) → number of approved reviews.
  final Map<int, int> distribution;
  final List<Review> reviews;

  Review? get mine => reviews.where((r) => r.mine).firstOrNull;

  /// Share of reviews with [stars], 0..1.
  double share(int stars) =>
      count == 0 ? 0 : (distribution[stars] ?? 0) / count;
}
