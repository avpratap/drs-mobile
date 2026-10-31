import 'package:flutter/material.dart';

import 'drs_colors.dart';
import 'drs_spacing.dart';
import 'drs_typography.dart';

/// The ONE DRS [ThemeData], shared by `customer_app` and `delivery_app`.
abstract final class DrsTheme {
  static const lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: DrsPalette.green,
    onPrimary: DrsPalette.cream,
    primaryContainer: Color(0xFFCFE6DC),
    onPrimaryContainer: Color(0xFF052A20),
    secondary: DrsPalette.maroon,
    onSecondary: DrsPalette.cream,
    secondaryContainer: Color(0xFFF1D9E1),
    onSecondaryContainer: DrsPalette.maroon,
    tertiary: DrsPalette.gold,
    onTertiary: DrsPalette.ink,
    tertiaryContainer: Color(0xFFF3E6C4),
    onTertiaryContainer: Color(0xFF3D2F00),
    error: Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: DrsPalette.cream,
    onSurface: DrsPalette.ink,
    onSurfaceVariant: Color(0xFF4B4448),
    surfaceDim: Color(0xFFE2D6C8),
    surfaceBright: Color(0xFFFBF5EE),
    surfaceContainerLowest: Color(0xFFFFFCF8),
    surfaceContainerLow: Color(0xFFF9F2E9),
    surfaceContainer: Color(0xFFEFE4D6),
    surfaceContainerHigh: Color(0xFFE9DDCD),
    surfaceContainerHighest: Color(0xFFE3D6C5),
    outline: Color(0xFF7D7377),
    outlineVariant: Color(0xFFD6C9BB),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: DrsPalette.ink,
    onInverseSurface: DrsPalette.cream,
    inversePrimary: Color(0xFF8FD0B5),
  );

  static const darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF8FD0B5),
    onPrimary: Color(0xFF00382A),
    primaryContainer: DrsPalette.green,
    onPrimaryContainer: DrsPalette.cream,
    secondary: Color(0xFFF0B5C8),
    onSecondary: DrsPalette.maroon,
    secondaryContainer: Color(0xFF5A1B33),
    onSecondaryContainer: Color(0xFFFFD9E3),
    tertiary: DrsPalette.gold,
    onTertiary: DrsPalette.ink,
    tertiaryContainer: Color(0xFF574500),
    onTertiaryContainer: Color(0xFFF3E6C4),
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF171417),
    onSurface: DrsPalette.cream,
    onSurfaceVariant: Color(0xFFD3C6BC),
    surfaceDim: Color(0xFF171417),
    surfaceBright: Color(0xFF3D383C),
    surfaceContainerLowest: Color(0xFF110E11),
    surfaceContainerLow: DrsPalette.ink,
    surfaceContainer: Color(0xFF231F23),
    surfaceContainerHigh: Color(0xFF2D292D),
    surfaceContainerHighest: Color(0xFF383438),
    outline: Color(0xFF9C9097),
    outlineVariant: Color(0xFF4B4448),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: DrsPalette.cream,
    onInverseSurface: DrsPalette.ink,
    inversePrimary: DrsPalette.green,
  );

  static ThemeData get light => _build(lightScheme, DrsColors.light);

  /// Optional dark theme.
  static ThemeData get dark => _build(darkScheme, DrsColors.dark);

  static ThemeData _build(ColorScheme scheme, DrsColors brand) {
    final text = drsTextTheme(scheme.onSurface);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(DrsRadius.md),
    );
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: DrsSpacing.lg,
      vertical: DrsSpacing.sm,
    );
    const buttonMinSize = Size(64, DrsSpacing.minTapTarget);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      fontFamily: DrsFonts.qualified(DrsFonts.poppins),
      textTheme: text,
      scaffoldBackgroundColor: scheme.surface,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [brand],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: text.titleLarge,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: shape,
          textStyle: text.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonMinSize,
          padding: buttonPadding,
          shape: shape,
          foregroundColor: scheme.primary,
          side: BorderSide(color: scheme.primary, width: 1.5),
          textStyle: text.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonMinSize,
          shape: shape,
          foregroundColor: scheme.primary,
          textStyle: text.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DrsRadius.lg),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DrsSpacing.md,
          vertical: DrsSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DrsRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DrsRadius.md),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DrsRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.primaryContainer,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStatePropertyAll(text.labelMedium),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primaryContainer,
        labelStyle: text.labelMedium,
        side: BorderSide(color: scheme.outlineVariant),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DrsRadius.pill),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: text.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DrsRadius.md),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, space: 1),
    );
  }
}
