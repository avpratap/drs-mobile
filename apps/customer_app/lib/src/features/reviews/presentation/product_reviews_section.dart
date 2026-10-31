import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../common/async_views.dart';
import '../application/reviews_providers.dart';
import 'review_tile.dart';

/// "Ratings & reviews" block on the product page: summary, your review and
/// the latest few, with links to all reviews and to write / edit yours.
class ProductReviewsSection extends ConsumerWidget {
  const ProductReviewsSection({required this.productId, super.key});

  final int productId;
  static const _preview = 3;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(productReviewsProvider(productId));
    final theme = Theme.of(context);

    return DrsSection(
      title: 'Ratings & reviews',
      child: switch (reviews) {
        AsyncValue(:final value?) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (value.count > 0)
              DrsRatingSummary(
                average: value.average,
                count: value.count,
                shareOf: value.share,
              )
            else
              Text(
                'No reviews yet. Bought this? Tell others what you think.',
                style: theme.textTheme.bodyMedium,
              ),
            for (final r in [
              ?value.mine,
              ...value.reviews.where((r) => !r.mine),
            ].take(_preview)) ...[
              const Divider(height: DrsSpacing.md),
              ReviewTile(review: r),
            ],
            const SizedBox(height: DrsSpacing.sm),
            Wrap(
              spacing: DrsSpacing.sm,
              runSpacing: DrsSpacing.xs,
              children: [
                DrsButton.secondary(
                  label: value.mine == null
                      ? 'Write a review'
                      : 'Edit your review',
                  icon: Icons.rate_review_outlined,
                  onPressed: () => context.push(Routes.writeReview(productId)),
                ),
                if (value.reviews.length > _preview)
                  DrsButton(
                    label: 'See all reviews',
                    variant: DrsButtonVariant.text,
                    onPressed: () =>
                        context.push(Routes.productReviews(productId)),
                  ),
              ],
            ),
          ],
        ),
        AsyncValue(:final error?) => Row(
          children: [
            Expanded(
              child: Text(
                "Couldn't load reviews. ${errorMessage(error)}",
                style: theme.textTheme.bodySmall,
              ),
            ),
            TextButton(
              onPressed: () =>
                  ref.invalidate(productReviewsProvider(productId)),
              child: const Text('Retry'),
            ),
          ],
        ),
        _ => const Padding(
          padding: EdgeInsets.all(DrsSpacing.md),
          child: Center(child: CircularProgressIndicator.adaptive()),
        ),
      },
    );
  }
}
