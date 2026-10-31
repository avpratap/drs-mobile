import 'package:flutter/material.dart';

import '../theme/drs_typography.dart';

/// The DRS wordmark — Montserrat ExtraBold. Scales with text size.
class DrsLogo extends StatelessWidget {
  const DrsLogo({super.key, this.size = 28, this.color, this.tagline});

  final double size;
  final Color? color;

  /// Optional line under the wordmark, e.g. "Pure dairy, daily".
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = color ?? theme.colorScheme.primary;
    final word = Text(
      'DRS',
      style: TextStyle(
        fontFamily: DrsFonts.qualified(DrsFonts.montserrat),
        fontWeight: FontWeight.w800,
        fontSize: size,
        letterSpacing: size * 0.06,
        height: 1,
        color: c,
      ),
    );
    return Semantics(
      label: 'DRS',
      header: true,
      excludeSemantics: tagline == null,
      child: tagline == null
          ? word
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                word,
                const SizedBox(height: 4),
                Text(
                  tagline!,
                  style: theme.textTheme.labelMedium?.copyWith(color: c),
                ),
              ],
            ),
    );
  }
}
