import 'package:flutter/material.dart';

import '../theme/drs_spacing.dart';

/// Quantity control. At 0 shows a compact "Add" button; above 0 shows − n +.
class DrsQuantityStepper extends StatelessWidget {
  const DrsQuantityStepper({
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max = 99,
    this.addLabel = 'Add',
    this.itemLabel = 'item',
  }) : assert(min >= 0 && max >= min, 'invalid bounds');

  final int value;
  final ValueChanged<int>? onChanged;
  final int min;
  final int max;
  final String addLabel;

  /// Used for screen-reader labels, e.g. "Cow milk 500 ml".
  final String itemLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final enabled = onChanged != null;

    if (value <= 0 && min == 0) {
      return FilledButton.tonalIcon(
        onPressed: enabled && max > 0 ? () => onChanged!(1) : null,
        icon: const Icon(Icons.add, size: 18),
        label: Text(addLabel),
        style: FilledButton.styleFrom(
          backgroundColor: scheme.primaryContainer,
          foregroundColor: scheme.onPrimaryContainer,
          minimumSize: const Size(0, DrsSpacing.minTapTarget),
          padding: const EdgeInsets.symmetric(horizontal: DrsSpacing.md),
        ),
      );
    }

    final canDec = enabled && value > min;
    final canInc = enabled && value < max;
    return Semantics(
      container: true,
      label: '$itemLabel quantity',
      value: '$value',
      increasedValue: canInc ? '${value + 1}' : null,
      decreasedValue: canDec ? '${value - 1}' : null,
      onIncrease: canInc ? () => onChanged!(value + 1) : null,
      onDecrease: canDec ? () => onChanged!(value - 1) : null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primary,
          borderRadius: BorderRadius.circular(DrsRadius.md),
        ),
        child: ExcludeSemantics(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(
                icon: value == 1 && min == 0 ? Icons.delete_outline : Icons.remove,
                tooltip: 'Decrease',
                onPressed: canDec ? () => onChanged!(value - 1) : null,
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 28),
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
              ),
              _StepButton(
                icon: Icons.add,
                tooltip: 'Increase',
                onPressed: canInc ? () => onChanged!(value + 1) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.tooltip, this.onPressed});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onPrimary;
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      color: on,
      disabledColor: on.withValues(alpha: 0.4),
      constraints: const BoxConstraints(
        minWidth: DrsSpacing.minTapTarget,
        minHeight: DrsSpacing.minTapTarget,
      ),
      onPressed: onPressed,
    );
  }
}
