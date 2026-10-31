import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// WCAG 2.1 contrast ratio between two opaque colours.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final hi = la > lb ? la : lb;
  final lo = la > lb ? lb : la;
  return (hi + 0.05) / (lo + 0.05);
}

void main() {
  for (final (name, theme) in [
    ('light', DrsTheme.light),
    ('dark', DrsTheme.dark),
  ]) {
    group('$name theme meets WCAG AA', () {
      final s = theme.colorScheme;
      // Body text pairs need 4.5:1.
      final text = <String, (Color, Color)>{
        'onSurface/surface': (s.onSurface, s.surface),
        'onSurfaceVariant/surface': (s.onSurfaceVariant, s.surface),
        'onSurface/surfaceContainerLowest': (
          s.onSurface,
          s.surfaceContainerLowest,
        ),
        'onSurfaceVariant/surfaceContainerLowest': (
          s.onSurfaceVariant,
          s.surfaceContainerLowest,
        ),
        'onSurface/surfaceContainerHigh': (s.onSurface, s.surfaceContainerHigh),
        'onPrimary/primary': (s.onPrimary, s.primary),
        'onPrimaryContainer/primaryContainer': (
          s.onPrimaryContainer,
          s.primaryContainer,
        ),
        'onSecondary/secondary': (s.onSecondary, s.secondary),
        'onSecondaryContainer/secondaryContainer': (
          s.onSecondaryContainer,
          s.secondaryContainer,
        ),
        'onTertiaryContainer/tertiaryContainer': (
          s.onTertiaryContainer,
          s.tertiaryContainer,
        ),
        'onError/error': (s.onError, s.error),
        'error/surface': (s.error, s.surface),
        'primary/surface (text buttons, links)': (s.primary, s.surface),
        'onInverseSurface/inverseSurface (snackbars)': (
          s.onInverseSurface,
          s.inverseSurface,
        ),
      };
      for (final MapEntry(:key, :value) in text.entries) {
        test(key, () {
          expect(
            contrast(value.$1, value.$2),
            greaterThanOrEqualTo(4.5),
            reason: '$key = ${contrast(value.$1, value.$2).toStringAsFixed(2)}',
          );
        });
      }
      test('status chips (warning text on tertiaryContainer, errors)', () {
        final brand = theme.extension<DrsColors>()!;
        expect(
          contrast(brand.warning, s.tertiaryContainer),
          greaterThanOrEqualTo(4.5),
          reason: contrast(brand.warning, s.tertiaryContainer).toString(),
        );
        expect(
          contrast(s.onErrorContainer, s.errorContainer),
          greaterThanOrEqualTo(4.5),
        );
      });
      // Non-text UI (switch tracks, focus outlines, icons) needs 3:1.
      test('outline/surface (component boundaries)', () {
        expect(contrast(s.outline, s.surface), greaterThanOrEqualTo(3));
      });
    });
  }
}
