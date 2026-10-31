import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/async_views.dart';
import '../application/reviews_providers.dart';

/// One review. Reviewers are anonymous to other customers (the backend does
/// not expose who wrote a review), so only "You" is ever named.
class ReviewTile extends HookConsumerWidget {
  const ReviewTile({required this.review, super.key});

  final Review review;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // (voted, count) after the user toggles; the list doesn't say whether
    // the caller already voted.
    final vote = useState<(bool, int)?>(null);
    final busy = useState(false);
    final count = vote.value?.$2 ?? review.helpfulCount;
    final voted = vote.value?.$1 ?? false;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DrsSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: DrsSpacing.sm,
            runSpacing: DrsSpacing.xxs,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Semantics(
                label: '${review.stars} out of 5 stars',
                child: ExcludeSemantics(
                  child: DrsStars(value: review.stars.toDouble(), size: 16),
                ),
              ),
              if (review.mine)
                Text('Your review', style: theme.textTheme.labelLarge),
              if (review.verifiedPurchase)
                const DrsStatusChip(
                  label: 'Verified purchase',
                  tone: DrsTone.positive,
                ),
              if (review.mine && review.status == ReviewStatus.pending)
                const DrsStatusChip(
                  label: 'Awaiting approval',
                  tone: DrsTone.warning,
                ),
              if (review.mine && review.status == ReviewStatus.rejected)
                const DrsStatusChip(
                  label: 'Not published',
                  tone: DrsTone.negative,
                ),
            ],
          ),
          if (review.comment?.trim().isNotEmpty ?? false) ...[
            const SizedBox(height: DrsSpacing.xs),
            Text(review.comment!, style: theme.textTheme.bodyMedium),
          ],
          if (review.adminReply?.trim().isNotEmpty ?? false)
            Container(
              margin: const EdgeInsets.only(top: DrsSpacing.sm),
              padding: const EdgeInsets.all(DrsSpacing.sm),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(DrsRadius.md),
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'DRS replied: ',
                      style: theme.textTheme.labelLarge,
                    ),
                    TextSpan(text: review.adminReply),
                  ],
                ),
                style: theme.textTheme.bodySmall,
              ),
            ),
          if (!review.mine && review.status == ReviewStatus.approved)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                key: ValueKey('helpful-${review.id}'),
                onPressed: busy.value
                    ? null
                    : () async {
                        busy.value = true;
                        try {
                          vote.value = await ref
                              .read(reviewsRepositoryProvider)
                              .toggleHelpful(review.productId, review.id);
                        } on Object catch (e) {
                          if (context.mounted) {
                            showSnack(context, errorMessage(e));
                          }
                        } finally {
                          if (context.mounted) busy.value = false;
                        }
                      },
                icon: Icon(
                  voted ? Icons.thumb_up : Icons.thumb_up_outlined,
                  size: 18,
                ),
                label: Text(count == 0 ? 'Helpful' : 'Helpful · $count'),
              ),
            ),
        ],
      ),
    );
  }
}
