import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../cart/application/cart_providers.dart';
import '../../cart/presentation/pack_picker.dart';
import '../../common/async_views.dart';
import '../application/catalogue_providers.dart';
import '../data/product_repository.dart';

/// Shared async/offline handling for catalogue-backed screens.
class CatalogueView extends ConsumerWidget {
  const CatalogueView({required this.builder, super.key});

  final Widget Function(BuildContext context, CatalogueSnapshot snapshot)
  builder;

  static Future<void> refresh(WidgetRef ref) async {
    ref.invalidate(catalogueProvider);
    try {
      await ref.read(catalogueProvider.future);
    } on Object {
      // Surfaced by the error state below.
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogue = ref.watch(catalogueProvider);
    return switch (catalogue) {
      AsyncValue(:final value?) => Column(
        children: [
          if (value.fromCache && value.error != null)
            DrsOfflineBanner(
              message: value.error!.isConnectivity
                  ? "You're offline — showing saved products."
                  : "Couldn't refresh — showing saved products.",
              onRetry: () => refresh(ref),
            ),
          Expanded(
            child: RefreshIndicator.adaptive(
              onRefresh: () => refresh(ref),
              child: value.products.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: DrsSpacing.xxl),
                        DrsEmptyState(
                          title: 'No products yet',
                          message:
                              'Fresh stock is on its way. Pull to refresh.',
                        ),
                      ],
                    )
                  : builder(context, value),
            ),
          ),
        ],
      ),
      AsyncValue(:final error?) => DrsEmptyState.error(
        title: "Couldn't load products",
        message: error is Exception ? _message(error) : null,
        onAction: () => refresh(ref),
      ),
      _ => const DrsLoading(message: 'Fetching fresh products…'),
    };
  }

  static String? _message(Exception e) {
    final text = e.toString();
    final i = text.indexOf(': ');
    return i == -1 ? null : text.substring(i + 2);
  }
}

/// Product row used by Home and Shop: tap for the product page, "Add" for
/// the quick pack picker (or a stepper once it's in the cart).
class ProductTile extends ConsumerWidget {
  const ProductTile({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final line = ref.watch(
      cartControllerProvider.select((c) => c.value?.lineFor(product.id)),
    );
    return DrsProductCard(
      product: product,
      onTap: () => context.push(Routes.product(product.id)),
      trailing: product.fromPrice == null
          ? null
          : line == null
          ? DrsQuantityStepper(
              value: 0,
              itemLabel: product.name,
              onChanged: (_) => showPackPickerSheet(context, product.id),
            )
          : DrsQuantityStepper(
              value: packsIn(line.qty, product.packSize),
              max: 50,
              itemLabel: product.name,
              onChanged: (v) => runWithSnack(
                context,
                () => ref
                    .read(cartControllerProvider.notifier)
                    .setPacks(line, v, product.packSize),
              ),
            ),
    );
  }
}
