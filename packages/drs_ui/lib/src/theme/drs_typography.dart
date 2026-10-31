import 'package:flutter/material.dart';

/// Font families bundled in this package. Use via the theme; reference these
/// constants only for one-off styles (e.g. the wordmark).
abstract final class DrsFonts {
  static const package = 'drs_ui';

  /// UI / body.
  static const poppins = 'Poppins';

  /// DRS logo wordmark only (ExtraBold, w800).
  static const montserrat = 'Montserrat';

  /// Fully-qualified family name for package fonts.
  static String qualified(String family) => 'packages/$package/$family';
}

/// Poppins type scale. Sizes are logical pixels and scale with the user's
/// accessibility text size — never clamp `MediaQuery.textScaler` globally.
TextTheme drsTextTheme(Color onSurface) {
  final family = DrsFonts.qualified(DrsFonts.poppins);
  TextStyle s(double size, FontWeight w, double height, [double ls = 0]) =>
      TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: w,
        height: height,
        letterSpacing: ls,
        color: onSurface,
      );
  return TextTheme(
    displayLarge: s(48, FontWeight.w600, 1.12, -0.5),
    displayMedium: s(40, FontWeight.w600, 1.15),
    displaySmall: s(32, FontWeight.w600, 1.2),
    headlineLarge: s(28, FontWeight.w600, 1.25),
    headlineMedium: s(24, FontWeight.w600, 1.3),
    headlineSmall: s(20, FontWeight.w600, 1.35),
    titleLarge: s(18, FontWeight.w600, 1.35),
    titleMedium: s(16, FontWeight.w600, 1.4, 0.1),
    titleSmall: s(14, FontWeight.w600, 1.4, 0.1),
    bodyLarge: s(16, FontWeight.w400, 1.5),
    bodyMedium: s(14, FontWeight.w400, 1.5),
    bodySmall: s(12, FontWeight.w400, 1.45),
    labelLarge: s(15, FontWeight.w600, 1.3, 0.2),
    labelMedium: s(13, FontWeight.w500, 1.3, 0.2),
    labelSmall: s(11, FontWeight.w500, 1.3, 0.3),
  );
}
