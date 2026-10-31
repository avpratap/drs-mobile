import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/reviews_providers.dart';
import '../data/reviews_repository.dart';
import 'review_tile.dart';

/// All reviews of a product, sortable by recency or helpfulness.
class ReviewsScreen extends HookConsumerWidget {
  const ReviewsScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sort = useState(ReviewSort.recent);
    final provider = productReviewsProvider(productId, sort: sort.value);
    final reviews = ref.watch(provider);
    final name = ref.watch(productIndexProvider)[productId]?.name;

    return DrsScaffold(
      appBar: DrsAppBar(title: name == null ? 'Reviews' : 'Reviews · $name'),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.writeReview(productId)),
        icon: const Icon(Icons.rate_review_outlined),
        label: Text(
          reviews.value?.mine == null ? 'Write a review' : 'Edit your review',
        ),
      ),
      body: AsyncBody(
        value: reviews,
        onRetry: () => ref.invalidate(provider),
        errorTitle: "Couldn't load reviews",
        builder: (s) => RefreshIndicator(
          onRefresh: () => ref.refresh(provider.future),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              DrsSpacing.md,
              DrsSpacing.md,
              DrsSpacing.md,
              DrsSpacing.xxl * 2,
            ),
            children: [
              DrsRatingSummary(
                average: s.average,
                count: s.count,
                shareOf: s.share,
              ),
              const SizedBox(height: DrsSpacing.md),
              Wrap(
                spacing: DrsSpacing.sm,
                children: [
                  for (final o in ReviewSort.values)
                    ChoiceChip(
                      label: Text(o.label),
                      selected: sort.value == o,
                      onSelected: (_) => sort.value = o,
                    ),
                ],
              ),
              if (s.reviews.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: DrsSpacing.xl),
                  child: DrsEmptyState(
                    icon: Icons.reviews_outlined,
                    title: 'No reviews yet',
                    message: 'Be the first to review this product.',
                  ),
                ),
              for (final r in [
                ?s.mine,
                ...s.reviews.where((r) => !r.mine),
              ]) ...[const Divider(), ReviewTile(review: r)],
            ],
          ),
        ),
      ),
    );
  }
}
