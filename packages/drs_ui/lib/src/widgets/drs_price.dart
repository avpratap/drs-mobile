import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

/// Displays a [Money] amount, optionally "from" and per-unit, with an
/// accessible label (e.g. "from ₹32 per 500 ml").
class DrsPrice extends StatelessWidget {
  const DrsPrice({
    required this.amount,
    super.key,
    this.unitLabel,
    this.isFrom = false,
    this.compareAt,
    this.style,
  });

  final Money amount;

  /// e.g. `500 ml` → rendered as "/ 500 ml".
  final String? unitLabel;

  /// Prefix with "from" (lowest variant price).
  final bool isFrom;

  /// Optional higher reference price, shown struck through.
  final Money? compareAt;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final main = (style ?? theme.textTheme.titleMedium)?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.w700,
    );
    final muted = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final showCompare = compareAt != null && compareAt! > amount;

    final semantics = [
      if (isFrom) 'from',
      amount.format(),
      if (unitLabel != null) 'per $unitLabel',
      if (showCompare) 'was ${compareAt!.format()}',
    ].join(' ');

    return Semantics(
      label: semantics,
      excludeSemantics: true,
      child: Text.rich(
        TextSpan(
          children: [
            if (isFrom) TextSpan(text: 'from ', style: muted),
            TextSpan(text: amount.format(), style: main),
            if (unitLabel != null) TextSpan(text: ' / $unitLabel', style: muted),
            if (showCompare) ...[
              const TextSpan(text: '  '),
              TextSpan(
                text: compareAt!.format(),
                style: muted?.copyWith(decoration: TextDecoration.lineThrough),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

extension on Money {
  bool operator >(Money other) => compareTo(other) > 0;
}
