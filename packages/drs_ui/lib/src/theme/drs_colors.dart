import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

/// Raw DRS brand palette. Prefer `Theme.of(context).colorScheme` in widgets;
/// use these only where the scheme has no slot (e.g. [DrsColors.sky]).
abstract final class DrsPalette {
  /// Primary — DRS green.
  static const green = Color(0xFF0D4C3C);

  /// Secondary — maroon.
  static const maroon = Color(0xFF3B0A1E);

  /// Tertiary / accent — gold. Use sparingly (badges, highlights).
  static const gold = Color(0xFFC5A253);

  /// Surface / background — cream. Also onPrimary.
  static const cream = Color(0xFFF4EADE);

  /// onSurface — ink.
  static const ink = Color(0xFF1E1A1E);

  /// Milk / buttermilk line ONLY.
  static const sky = Color(0xFF6FC5F4);
}

/// Brand tokens that Material's [ColorScheme] has no slot for.
@immutable
class DrsColors extends ThemeExtension<DrsColors> {
  const DrsColors({
    required this.sky,
    required this.onSky,
    required this.skyContainer,
    required this.gold,
    required this.onGold,
    required this.success,
    required this.warning,
  });

  static const light = DrsColors(
    sky: DrsPalette.sky,
    onSky: Color(0xFF06283A),
    skyContainer: Color(0xFFDDF1FD),
    gold: DrsPalette.gold,
    onGold: DrsPalette.ink,
    success: Color(0xFF1B6B47),
    warning: Color(0xFF8A5A00),
  );

  static const dark = DrsColors(
    sky: DrsPalette.sky,
    onSky: Color(0xFF06283A),
    skyContainer: Color(0xFF113B52),
    gold: DrsPalette.gold,
    onGold: DrsPalette.ink,
    success: Color(0xFF7FD3A8),
    warning: Color(0xFFF1C26B),
  );

  /// Milk / buttermilk accent. Do not use for other product lines.
  final Color sky;
  final Color onSky;
  final Color skyContainer;
  final Color gold;
  final Color onGold;
  final Color success;
  final Color warning;

  static DrsColors of(BuildContext context) =>
      Theme.of(context).extension<DrsColors>() ?? light;

  /// Accent for a product line: sky for milk/buttermilk, brand green otherwise.
  Color accentFor(ProductLine line, ColorScheme scheme) =>
      line.usesSkyAccent ? sky : scheme.primary;

  @override
  DrsColors copyWith({
    Color? sky,
    Color? onSky,
    Color? skyContainer,
    Color? gold,
    Color? onGold,
    Color? success,
    Color? warning,
  }) => DrsColors(
    sky: sky ?? this.sky,
    onSky: onSky ?? this.onSky,
    skyContainer: skyContainer ?? this.skyContainer,
    gold: gold ?? this.gold,
    onGold: onGold ?? this.onGold,
    success: success ?? this.success,
    warning: warning ?? this.warning,
  );

  @override
  DrsColors lerp(DrsColors? other, double t) {
    if (other == null) return this;
    return DrsColors(
      sky: Color.lerp(sky, other.sky, t)!,
      onSky: Color.lerp(onSky, other.onSky, t)!,
      skyContainer: Color.lerp(skyContainer, other.skyContainer, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      onGold: Color.lerp(onGold, other.onGold, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
    );
  }
}
