import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../cart/presentation/cart_button.dart';
import 'catalogue_view.dart';

class ShopScreen extends HookConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = useTextEditingController();
    final q = useValueListenable(query).text.trim().toLowerCase();
    final category = useState<String?>(null);

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Shop', actions: [CartAction()]),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      body: CatalogueView(
        builder: (context, snapshot) {
          final products = snapshot.products.where((p) {
            final matchesCat =
                category.value == null || p.category == category.value;
            final matchesQ =
                q.isEmpty ||
                p.name.toLowerCase().contains(q) ||
                p.sku.toLowerCase().contains(q);
            return matchesCat && matchesQ;
          }).toList();
          final categories = snapshot.categories;

          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  DrsSpacing.md,
                  DrsSpacing.xs,
                  DrsSpacing.md,
                  0,
                ),
                sliver: SliverToBoxAdapter(
                  child: TextField(
                    controller: query,
                    textInputAction: TextInputAction.search,
                    decoration: const InputDecoration(
                      hintText: 'Search milk, ghee, paneer…',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              if (categories.isNotEmpty)
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.all(DrsSpacing.md),
                    child: Row(
                      children: [
                        _CategoryChip(
                          label: 'All',
                          selected: category.value == null,
                          onSelected: () => category.value = null,
                        ),
                        for (final c in categories)
                          _CategoryChip(
                            label: categoryLabel(c),
                            selected: category.value == c,
                            onSelected: () => category.value = c,
                          ),
                      ],
                    ),
                  ),
                ),
              if (products.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: DrsEmptyState(
                    icon: Icons.search_off,
                    title: 'Nothing matches',
                    message: 'Try a different search or category.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DrsSpacing.md,
                  ),
                  sliver: DrsAdaptiveSliverList(
                    itemCount: products.length,
                    itemBuilder: (_, i) => ProductTile(product: products[i]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: DrsSpacing.xs),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    ),
  );
}
