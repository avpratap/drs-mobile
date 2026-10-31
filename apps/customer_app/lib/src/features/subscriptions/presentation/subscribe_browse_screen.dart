import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../catalogue/presentation/catalogue_view.dart';

/// Subscribable products (milk line first).
class SubscribeBrowseScreen extends StatelessWidget {
  const SubscribeBrowseScreen({super.key});

  @override
  Widget build(BuildContext context) => DrsScaffold(
    appBar: const DrsAppBar(title: 'Subscribe to a product'),
    maxContentWidth: DrsSpacing.maxWideContentWidth,
    body: CatalogueView(
      builder: (context, snapshot) {
        final products = [
          ...snapshot.products.where(
            (p) => p.isSubscribable && p.line.usesSkyAccent,
          ),
          ...snapshot.products.where(
            (p) => p.isSubscribable && !p.line.usesSkyAccent,
          ),
        ];
        if (products.isEmpty) {
          return const DrsEmptyState(
            title: 'Nothing to subscribe to yet',
            message: 'Subscribable products will appear here.',
          );
        }
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(DrsSpacing.md),
              sliver: DrsAdaptiveSliverList(
                itemCount: products.length,
                itemBuilder: (context, i) => DrsProductCard(
                  product: products[i],
                  onTap: () =>
                      context.push(Routes.subscribeProduct(products[i].id)),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
