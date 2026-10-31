import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/cart_providers.dart';

/// Pack size + count + "Add to cart". Used inline on the product page and in
/// the quick-add sheet from catalogue cards.
class PackPicker extends HookConsumerWidget {
  const PackPicker({required this.detail, super.key, this.onAdded});

  final ProductDetail detail;
  final VoidCallback? onAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pack = useState<Pack?>(detail.defaultPack);
    final count = useState(1);
    final busy = useState(false);
    final theme = Theme.of(context);
    final selected = pack.value;
    final total = selected?.price?.times(count.value);

    Future<void> add() async {
      busy.value = true;
      final ok = await runWithSnack(
        context,
        () => ref
            .read(cartControllerProvider.notifier)
            .addPacks(detail.product.id, selected!, count.value),
        success: 'Added to cart',
      );
      if (context.mounted) busy.value = false;
      if (ok) onAdded?.call();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Pack size', style: theme.textTheme.titleSmall),
        const SizedBox(height: DrsSpacing.xs),
        DrsPackSelector(
          packs: detail.packs,
          selected: selected,
          onSelected: (p) => pack.value = p,
        ),
        const SizedBox(height: DrsSpacing.md),
        Row(
          children: [
            DrsQuantityStepper(
              value: count.value,
              min: 1,
              max: 20,
              itemLabel: '${detail.product.name} packs',
              onChanged: selected == null ? null : (v) => count.value = v,
            ),
            const SizedBox(width: DrsSpacing.md),
            Expanded(
              child: DrsButton(
                label: total == null
                    ? 'Unavailable'
                    : 'Add · ${total.format()}',
                icon: Icons.add_shopping_cart,
                isLoading: busy.value,
                onPressed: selected == null ? null : add,
              ),
            ),
          ],
        ),
        if (selected?.showMrpStrike ?? false) ...[
          const SizedBox(height: DrsSpacing.xs),
          DrsPackPrice(pack: selected!),
        ],
        const SizedBox(height: DrsSpacing.xs),
        Text(
          'Prices include GST.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Quick-add bottom sheet from a catalogue card. Safe-area aware and
/// scrollable so it works at large text sizes and in landscape.
Future<void> showPackPickerSheet(BuildContext context, int productId) =>
    showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: DrsSpacing.maxContentWidth),
      builder: (context) => _PackSheet(productId: productId),
    );

class _PackSheet extends ConsumerWidget {
  const _PackSheet({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(productId));
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          DrsSpacing.md,
          0,
          DrsSpacing.md,
          DrsSpacing.lg,
        ),
        child: AsyncBody(
          value: detail,
          onRetry: () => ref.invalidate(productDetailProvider(productId)),
          errorTitle: "Couldn't load pack sizes",
          builder: (d) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                d.product.name,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: DrsSpacing.md),
              PackPicker(
                detail: d,
                onAdded: () => Navigator.of(context).maybePop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
