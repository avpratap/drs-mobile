import 'package:flutter/material.dart';

enum DrsButtonVariant {
  /// Filled brand green — the one main action on a screen.
  primary,

  /// Outlined green.
  secondary,

  /// Filled maroon — for emphasised secondary actions (e.g. "Subscribe").
  accent,

  /// Text only.
  text,
}

/// The DRS button. Height grows with text scaling (min 48dp); shows a spinner
/// and ignores taps while [isLoading].
class DrsButton extends StatelessWidget {
  const DrsButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = DrsButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  const DrsButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  }) : variant = DrsButtonVariant.secondary;

  final String label;
  final VoidCallback? onPressed;
  final DrsButtonVariant variant;
  final IconData? icon;
  final bool isLoading;

  /// Stretch to the available width.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveOnPressed = isLoading ? null : onPressed;

    final Widget child = isLoading
        ? SizedBox.square(
            dimension: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: switch (variant) {
                DrsButtonVariant.primary => scheme.onPrimary,
                DrsButtonVariant.accent => scheme.onSecondary,
                _ => scheme.primary,
              },
            ),
          )
        : Text(label, textAlign: TextAlign.center);

    final Widget? leading = (icon != null && !isLoading) ? Icon(icon) : null;

    final Widget button = switch (variant) {
      DrsButtonVariant.primary =>
        leading == null
            ? FilledButton(onPressed: effectiveOnPressed, child: child)
            : FilledButton.icon(
                onPressed: effectiveOnPressed,
                icon: leading,
                label: child,
              ),
      DrsButtonVariant.accent =>
        leading == null
            ? FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                ),
                onPressed: effectiveOnPressed,
                child: child,
              )
            : FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: scheme.secondary,
                  foregroundColor: scheme.onSecondary,
                ),
                onPressed: effectiveOnPressed,
                icon: leading,
                label: child,
              ),
      DrsButtonVariant.secondary =>
        leading == null
            ? OutlinedButton(onPressed: effectiveOnPressed, child: child)
            : OutlinedButton.icon(
                onPressed: effectiveOnPressed,
                icon: leading,
                label: child,
              ),
      DrsButtonVariant.text =>
        leading == null
            ? TextButton(onPressed: effectiveOnPressed, child: child)
            : TextButton.icon(
                onPressed: effectiveOnPressed,
                icon: leading,
                label: child,
              ),
    };

    final semantic = Semantics(
      button: true,
      enabled: effectiveOnPressed != null,
      label: isLoading ? '$label, loading' : null,
      excludeSemantics: isLoading,
      child: button,
    );
    return expand ? SizedBox(width: double.infinity, child: semantic) : semantic;
  }
}
