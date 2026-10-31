import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../cart/presentation/cart_button.dart';
import '../../cart/presentation/pack_picker.dart';
import '../../common/async_views.dart';
import '../../reviews/presentation/product_reviews_section.dart';
import '../application/product_detail_provider.dart';

/// Product page: image, description, pack sizes, add to cart, subscribe.
/// Two columns (image | details) on medium+ widths.
class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(productId));
    return DrsScaffold(
      appBar: DrsAppBar(
        title: detail.value?.product.name ?? 'Product',
        actions: const [CartAction()],
      ),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      body: AsyncBody(
        value: detail,
        onRetry: () => ref.invalidate(productDetailProvider(productId)),
        errorTitle: "Couldn't load this product",
        builder: (d) => LayoutBuilder(
          builder: (context, c) {
            final wide = !DrsWindowSize.forWidth(c.maxWidth).isCompact;
            final image = _Hero(product: d.product);
            final info = _Info(detail: d);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(DrsSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: image),
                        const SizedBox(width: DrsSpacing.lg),
                        Expanded(child: info),
                      ],
                    )
                  else ...[
                    image,
                    const SizedBox(height: DrsSpacing.md),
                    info,
                  ],
                  const SizedBox(height: DrsSpacing.lg),
                  ProductReviewsSection(productId: d.product.id),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final brand = DrsColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    final tint = product.line.usesSkyAccent
        ? brand.skyContainer
        : scheme.primaryContainer;
    final icon = Icon(
      Icons.local_drink_outlined,
      size: 72,
      color: brand.accentFor(product.line, scheme),
    );
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DrsRadius.lg),
        child: ColoredBox(
          color: tint,
          child: product.imageUrl == null || product.imageUrl!.isEmpty
              ? Center(child: icon)
              : Image.network(
                  product.imageUrl!,
                  fit: BoxFit.cover,
                  semanticLabel: product.name,
                  errorBuilder: (_, _, _) => Center(child: icon),
                ),
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.detail});

  final ProductDetail detail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = detail.product;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(p.name, style: theme.textTheme.headlineSmall),
        if (p.category != null) ...[
          const SizedBox(height: DrsSpacing.xxs),
          Text(
            p.category!,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (p.description?.trim().isNotEmpty ?? false) ...[
          const SizedBox(height: DrsSpacing.sm),
          Text(p.description!, style: theme.textTheme.bodyMedium),
        ],
        const SizedBox(height: DrsSpacing.lg),
        PackPicker(detail: detail),
        if (p.isSubscribable) ...[
          const SizedBox(height: DrsSpacing.lg),
          DrsButton(
            label: 'Subscribe for regular delivery',
            variant: DrsButtonVariant.accent,
            icon: Icons.event_repeat,
            expand: true,
            onPressed: () => context.push(Routes.subscribeProduct(p.id)),
          ),
        ],
      ],
    );
  }
}
