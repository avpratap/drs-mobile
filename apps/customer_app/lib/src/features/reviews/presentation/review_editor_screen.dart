import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/reviews_providers.dart';

/// Write, edit or delete the caller's review of a product (one per product;
/// saving again replaces it).
class ReviewEditorScreen extends ConsumerWidget {
  const ReviewEditorScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviews = ref.watch(productReviewsProvider(productId));
    final name = ref.watch(productIndexProvider)[productId]?.name;
    return DrsScaffold(
      appBar: DrsAppBar(
        title: reviews.value?.mine == null ? 'Write a review' : 'Edit review',
      ),
      body: AsyncBody(
        value: reviews,
        onRetry: () => ref.invalidate(productReviewsProvider(productId)),
        errorTitle: "Couldn't load your review",
        builder: (s) =>
            _Editor(productId: productId, productName: name, existing: s.mine),
      ),
    );
  }
}

class _Editor extends HookConsumerWidget {
  const _Editor({
    required this.productId,
    required this.productName,
    required this.existing,
  });

  final int productId;
  final String? productName;
  final Review? existing;

  static const maxComment = 1000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = useState(existing?.stars ?? 0);
    final comment = useTextEditingController(text: existing?.comment ?? '');
    final busy = useState<String?>(null); // 'save' | 'delete'
    final error = useState<String?>(null);
    final theme = Theme.of(context);

    void done(String message) {
      ref.invalidate(productReviewsProvider);
      showSnack(context, message);
      context.pop();
    }

    Future<void> save() async {
      if (stars.value == 0) {
        error.value = 'Choose a star rating.';
        return;
      }
      busy.value = 'save';
      error.value = null;
      try {
        final r = await ref
            .read(reviewsRepositoryProvider)
            .rate(productId, stars: stars.value, comment: comment.text);
        if (!context.mounted) return;
        done(
          r.status == ReviewStatus.pending
              ? 'Thanks! Your review will appear once it’s approved.'
              : 'Thanks for your review',
        );
      } on DrsApiError catch (e) {
        error.value = e.message;
      } finally {
        if (context.mounted) busy.value = null;
      }
    }

    Future<void> delete() async {
      final ok = await showDrsConfirmDialog(
        context,
        title: 'Delete your review?',
        message: 'Your rating and comment will be removed.',
        confirmLabel: 'Delete',
        destructive: true,
      );
      if (!ok || !context.mounted) return;
      busy.value = 'delete';
      error.value = null;
      try {
        await ref.read(reviewsRepositoryProvider).deleteMine(productId);
        if (context.mounted) done('Review deleted');
      } on DrsApiError catch (e) {
        error.value = e.message;
      } finally {
        if (context.mounted) busy.value = null;
      }
    }

    return ListView(
      padding: const EdgeInsets.all(DrsSpacing.md),
      children: [
        if (productName != null)
          Text(productName!, style: theme.textTheme.titleLarge),
        const SizedBox(height: DrsSpacing.md),
        Text('Your rating', style: theme.textTheme.titleSmall),
        const SizedBox(height: DrsSpacing.xs),
        DrsStarInput(
          value: stars.value,
          onChanged: (v) {
            stars.value = v;
            error.value = null;
          },
        ),
        const SizedBox(height: DrsSpacing.lg),
        TextField(
          key: const ValueKey('review-comment'),
          controller: comment,
          minLines: 4,
          maxLines: 8,
          maxLength: maxComment,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Your review (optional)',
            hintText: 'Freshness, taste, packaging, delivery…',
            alignLabelWithHint: true,
          ),
        ),
        Text(
          'Reviews are public but anonymous — please don’t include phone '
          'numbers, addresses or other personal details. Reviews from '
          'customers who haven’t bought this product are checked before they '
          'appear.',
          style: theme.textTheme.bodySmall,
        ),
        if (error.value != null) ...[
          const SizedBox(height: DrsSpacing.sm),
          Text(
            error.value!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
        const SizedBox(height: DrsSpacing.lg),
        DrsButton(
          label: existing == null ? 'Post review' : 'Update review',
          expand: true,
          isLoading: busy.value == 'save',
          onPressed: busy.value == null ? save : null,
        ),
        if (existing != null)
          DrsButton(
            label: 'Delete review',
            variant: DrsButtonVariant.text,
            expand: true,
            isLoading: busy.value == 'delete',
            onPressed: busy.value == null ? delete : null,
          ),
      ],
    );
  }
}
