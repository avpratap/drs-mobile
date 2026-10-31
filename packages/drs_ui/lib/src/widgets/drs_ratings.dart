import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/drs_spacing.dart';

/// Read-only star display (supports halves), e.g. 4.3 → ★★★★½.
class DrsStars extends StatelessWidget {
  const DrsStars({required this.value, super.key, this.size = 18});

  final double value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context)
        .colorScheme
        .tertiary; // gold, used sparingly
    return Semantics(
      label: '${value.toStringAsFixed(1)} out of 5 stars',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 5; i++)
            Icon(
              value >= i
                  ? Icons.star_rounded
                  : value >= i - 0.5
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
              size: size,
              color: color,
            ),
        ],
      ),
    );
  }
}

/// Tap-to-rate 1..5 with 48dp targets; adjustable for screen readers.
class DrsStarInput extends StatelessWidget {
  const DrsStarInput({required this.value, required this.onChanged, super.key});

  /// 0 = not rated yet.
  final int value;
  final ValueChanged<int> onChanged;

  static const labels = [
    'Tap to rate',
    'Poor',
    'Fair',
    'Good',
    'Very good',
    'Excellent',
  ];

  void _set(int v) {
    HapticFeedback.selectionClick();
    onChanged(v);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      container: true,
      label: 'Rating',
      value: value == 0 ? 'not rated' : '$value of 5, ${labels[value]}',
      increasedValue: value < 5 ? '${value + 1} of 5' : null,
      decreasedValue: value > 1 ? '${value - 1} of 5' : null,
      onIncrease: value < 5 ? () => _set(value + 1) : null,
      onDecrease: value > 1 ? () => _set(value - 1) : null,
      child: ExcludeSemantics(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    key: ValueKey('star-$i'),
                    constraints: const BoxConstraints(
                      minWidth: DrsSpacing.minTapTarget,
                      minHeight: DrsSpacing.minTapTarget,
                    ),
                    iconSize: 36,
                    color: theme.colorScheme.tertiary,
                    icon: Icon(
                      i <= value
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                    ),
                    onPressed: () => _set(i),
                  ),
              ],
            ),
            Text(labels[value], style: theme.textTheme.labelLarge),
          ],
        ),
      ),
    );
  }
}

/// Average + count + 5..1 distribution bars.
class DrsRatingSummary extends StatelessWidget {
  const DrsRatingSummary({
    required this.average,
    required this.count,
    required this.shareOf,
    super.key,
  });

  final double average;
  final int count;

  /// Share (0..1) of reviews with the given star count.
  final double Function(int stars) shareOf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count == 0 ? '–' : average.toStringAsFixed(1),
              style: theme.textTheme.displaySmall,
            ),
            DrsStars(value: average),
            const SizedBox(height: 2),
            Text(
              count == 1 ? '1 review' : '$count reviews',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(width: DrsSpacing.lg),
        Expanded(
          child: Semantics(
            label: 'Rating distribution',
            child: Column(
              children: [
                for (var s = 5; s >= 1; s--)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 16,
                          child: Text('$s', style: theme.textTheme.labelMedium),
                        ),
                        const SizedBox(width: DrsSpacing.xxs),
                        Expanded(
                          child: LinearProgressIndicator(
                            value: shareOf(s),
                            minHeight: 6,
                            color: theme.colorScheme.tertiary,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(DrsRadius.pill),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
