import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

import '../theme/drs_colors.dart';
import '../theme/drs_spacing.dart';
import 'drs_price.dart';

/// App-bar cart action with an item-count badge.
class DrsCartButton extends StatelessWidget {
  const DrsCartButton({
    required this.count,
    required this.onPressed,
    super.key,
  });

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: count == 0 ? 'Cart' : 'Cart, $count items',
    onPressed: onPressed,
    icon: Badge.count(
      count: count,
      isLabelVisible: count > 0,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      textColor: Theme.of(context).colorScheme.onSecondary,
      child: const Icon(Icons.shopping_bag_outlined),
    ),
  );
}

/// Pack-size picker (e.g. 500 ml · ₹32 / 1 L · ₹64). Unavailable packs are
/// shown disabled rather than hidden so the range stays understandable.
class DrsPackSelector extends StatelessWidget {
  const DrsPackSelector({
    required this.packs,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final List<Pack> packs;
  final Pack? selected;
  final ValueChanged<Pack> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: DrsSpacing.xs,
      runSpacing: DrsSpacing.xs,
      children: [
        for (final p in packs)
          ChoiceChip(
            showCheckmark: false,
            selected: identical(p, selected),
            onSelected: p.available ? (_) => onSelected(p) : null,
            label: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.label, style: theme.textTheme.labelLarge),
                Text(
                  p.price?.format() ?? 'Unavailable',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// "Label ........ ₹value" row for order/cart summaries.
class DrsSummaryRow extends StatelessWidget {
  const DrsSummaryRow({
    required this.label,
    required this.value,
    super.key,
    this.emphasize = false,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool emphasize;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = emphasize
        ? theme.textTheme.titleMedium
        : theme.textTheme.bodyMedium;
    final style = muted
        ? base?.copyWith(color: theme.colorScheme.onSurfaceVariant)
        : base;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: DrsSpacing.xxs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: style)),
          const SizedBox(width: DrsSpacing.sm),
          Text(value, style: style, textAlign: TextAlign.end),
        ],
      ),
    );
  }
}

/// GST-inclusive totals block shared by cart, checkout and order detail.
class DrsTotals extends StatelessWidget {
  const DrsTotals({
    required this.subtotal,
    required this.total,
    super.key,
    this.discount,
    this.gstIncluded,
    this.shipping,
  });

  final Money subtotal;
  final Money total;
  final Money? discount;

  /// GST portion inside [total] (prices are GST-inclusive).
  final Money? gstIncluded;
  final Money? shipping;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      DrsSummaryRow(
        label: 'Item total',
        value: subtotal.format(compact: false),
      ),
      if (discount != null && !discount!.isZero)
        DrsSummaryRow(
          label: 'Discount',
          value: '−${discount!.format(compact: false)}',
        ),
      if (shipping != null)
        DrsSummaryRow(
          label: 'Delivery',
          value: shipping!.isZero ? 'Free' : shipping!.format(compact: false),
        ),
      const Divider(height: DrsSpacing.md),
      Semantics(
        label: 'Total ${total.format(compact: false)}',
        excludeSemantics: true,
        child: DrsSummaryRow(
          label: 'Total',
          value: total.format(compact: false),
          emphasize: true,
        ),
      ),
      if (gstIncluded != null)
        DrsSummaryRow(
          label: 'Includes GST',
          value: gstIncluded!.format(compact: false),
          muted: true,
        ),
    ],
  );
}

enum DrsTone { neutral, positive, warning, negative }

/// Small rounded status label.
class DrsStatusChip extends StatelessWidget {
  const DrsStatusChip({
    required this.label,
    super.key,
    this.tone = DrsTone.neutral,
  });

  final String label;
  final DrsTone tone;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = DrsColors.of(context);
    final (bg, fg) = switch (tone) {
      DrsTone.neutral => (scheme.surfaceContainerHigh, scheme.onSurface),
      DrsTone.positive => (scheme.primaryContainer, scheme.onPrimaryContainer),
      DrsTone.warning => (scheme.tertiaryContainer, brand.warning),
      DrsTone.negative => (scheme.errorContainer, scheme.onErrorContainer),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(DrsRadius.pill),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DrsSpacing.sm,
          vertical: DrsSpacing.xxs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
        ),
      ),
    );
  }
}

/// Titled card section.
class DrsSection extends StatelessWidget {
  const DrsSection({
    required this.child,
    super.key,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(DrsSpacing.md),
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null) ...[
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: DrsSpacing.sm),
          ],
          child,
        ],
      ),
    ),
  );
}

/// Price + pack label line for a pack, used on product pages and sheets.
class DrsPackPrice extends StatelessWidget {
  const DrsPackPrice({required this.pack, super.key});

  final Pack pack;

  @override
  Widget build(BuildContext context) => pack.price == null
      ? const Text('Currently unavailable')
      : DrsPrice(
          amount: pack.price!,
          unitLabel: pack.label,
          compareAt: pack.showMrpStrike ? pack.mrp : null,
        );
}
