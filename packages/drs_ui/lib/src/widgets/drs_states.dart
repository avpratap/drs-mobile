import 'package:flutter/material.dart';

import '../theme/drs_colors.dart';
import '../theme/drs_spacing.dart';
import 'drs_button.dart';

/// Centred spinner with an optional message.
class DrsLoading extends StatelessWidget {
  const DrsLoading({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) => Center(
    child: Semantics(
      liveRegion: true,
      label: message ?? 'Loading',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator.adaptive(),
          if (message != null) ...[
            const SizedBox(height: DrsSpacing.md),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    ),
  );
}

/// Illustrative empty / error state with an optional action.
class DrsEmptyState extends StatelessWidget {
  const DrsEmptyState({
    required this.title,
    super.key,
    this.message,
    this.icon = Icons.inventory_2_outlined,
    this.actionLabel,
    this.onAction,
  });

  /// Error variant with a "Try again" action.
  const DrsEmptyState.error({
    required this.title,
    super.key,
    this.message,
    this.onAction,
    this.actionLabel = 'Try again',
  }) : icon = Icons.cloud_off_outlined;

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DrsSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                icon,
                size: 36,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: DrsSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            if (message != null) ...[
              const SizedBox(height: DrsSpacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: DrsSpacing.lg),
              DrsButton.secondary(label: actionLabel!, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}

/// Thin strip telling the user they are seeing cached data.
class DrsOfflineBanner extends StatelessWidget {
  const DrsOfflineBanner({
    super.key,
    this.message = "You're offline — showing saved items.",
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = DrsColors.of(context);
    return Semantics(
      liveRegion: true,
      child: Material(
        color: theme.colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DrsSpacing.md,
            vertical: DrsSpacing.xxs,
          ),
          child: Row(
            children: [
              Icon(Icons.wifi_off, size: 18, color: brand.warning),
              const SizedBox(width: DrsSpacing.xs),
              Expanded(
                child: Text(
                  message,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                ),
              ),
              if (onRetry != null)
                TextButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
