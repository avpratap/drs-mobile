import 'package:flutter/material.dart';

import '../theme/drs_typography.dart';

/// Brand colours used by the logo (fixed — the lockup never follows theme
/// or dark mode, exactly like the web's `StoreLogo`).
abstract final class DrsBrandColors {
  static const green = Color(0xFF0D4C3C);
  static const gold = Color(0xFFC5A253);
  static const cream = Color(0xFFF4EADE);
  static const ink = Color(0xFF1E1A1E);
}

/// The DRS Dairy lockup, recreated from the web storefront's `StoreLogo`
/// (drs-web `src/components/store/logo.tsx`): the ivory "DRS" mark on a
/// deep-green tile with an antique-gold keyline, beside the two-line
/// "DAIRY · PURE HERITAGE" wordmark.
///
/// [size] is the tile's side (the web header uses 44). Pass [onDark] on
/// green surfaces: the tile drops its fill and the wordmark turns cream.
/// The lockup is a logotype, so it ignores the system text scale (WCAG
/// exempts logos) and is read by screen readers as one label, "DRS Dairy".
class DrsLogo extends StatelessWidget {
  const DrsLogo({
    super.key,
    this.size = 44,
    this.onDark = false,
    this.showWordmark = true,
  });

  final double size;
  final bool onDark;

  /// false = the tile alone (same as [DrsLogoMark]).
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final mark = DrsLogoMark(size: size, onDark: onDark);
    if (!showWordmark) {
      return Semantics(
        label: 'DRS Dairy',
        image: true,
        child: ExcludeSemantics(child: mark),
      );
    }
    // Web proportions at a 44 px tile: gap 10 px; "DAIRY" 17 px bold,
    // tracking 0.16em; "Pure heritage" 9 px medium, tracking 0.24em,
    // uppercase, 3 px below; leading-none.
    final k = size / 44;
    final family = DrsFonts.qualified(DrsFonts.poppins);
    final primary = onDark ? DrsBrandColors.cream : DrsBrandColors.green;
    final secondary = onDark
        ? DrsBrandColors.cream.withValues(alpha: 0.75)
        : DrsBrandColors.ink.withValues(alpha: 0.65);
    return Semantics(
      label: 'DRS Dairy',
      image: true,
      child: ExcludeSemantics(
        child: MediaQuery.withNoTextScaling(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              mark,
              SizedBox(width: 10 * k),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Flutter spreads letter-spacing half before each glyph;
                  // browsers put it all after. Shift back to match the web.
                  Transform.translate(
                    offset: Offset(-17 * k * 0.16 / 2, 0),
                    child: Text(
                      'DAIRY',
                      style: TextStyle(
                        fontFamily: family,
                        fontWeight: FontWeight.w700,
                        fontSize: 17 * k,
                        letterSpacing: 17 * k * 0.16,
                        height: 1,
                        color: primary,
                      ),
                    ),
                  ),
                  SizedBox(height: 3 * k),
                  Transform.translate(
                    offset: Offset(-9 * k * 0.24 / 2, 0),
                    child: Text(
                      'PURE HERITAGE',
                      style: TextStyle(
                        fontFamily: family,
                        fontWeight: FontWeight.w500,
                        fontSize: 9 * k,
                        letterSpacing: 9 * k * 0.24,
                        height: 1,
                        color: secondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The "DRS" tile on its own (app icon, navigation rail, licence page).
///
/// Small-size rule: below [keylineMinSize] the gold keyline is dropped and
/// the plain solid mark is drawn (a 1 px hairline turns to mush when tiny) —
/// the same mark the app icons use.
class DrsLogoMark extends StatelessWidget {
  const DrsLogoMark({super.key, this.size = 44, this.onDark = false});

  final double size;
  final bool onDark;

  static const keylineMinSize = 24.0;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(
      painter: _MarkPainter(
        onDark: onDark,
        keyline: size >= keylineMinSize,
        family: DrsFonts.qualified(DrsFonts.montserrat),
      ),
    ),
  );
}

/// Paints the web SVG (`viewBox="0 0 48 48"`) scaled to the widget:
/// a 44-unit green rounded square at (2,2) with radius 12; a gold keyline
/// at (5.5,5.5), 37 units, radius 8.5, stroke 1.3; and cream "DRS"
/// (13.5 units, weight 800, tracking 0.6) centred on x=24, baseline y=30.5.
class _MarkPainter extends CustomPainter {
  _MarkPainter({
    required this.onDark,
    required this.keyline,
    required this.family,
  });

  final bool onDark;
  final bool keyline;
  final String family;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 48;
    RRect rr(double x, double w, double r) => RRect.fromRectAndRadius(
      Rect.fromLTWH(x * s, x * s, w * s, w * s),
      Radius.circular(r * s),
    );
    if (!onDark) {
      canvas.drawRRect(rr(2, 44, 12), Paint()..color = DrsBrandColors.green);
    }
    if (keyline) {
      canvas.drawRRect(
        rr(5.5, 37, 8.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.3 * s
          ..color = DrsBrandColors.gold,
      );
    }
    final tp = TextPainter(
      text: TextSpan(
        text: 'DRS',
        style: TextStyle(
          fontFamily: family,
          fontWeight: FontWeight.w800,
          fontSize: 13.5 * s,
          letterSpacing: 0.6 * s,
          color: DrsBrandColors.cream,
          height: 1,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    // SVG letter-spacing trails the last glyph too; centre on the glyphs.
    final glyphWidth = tp.width - 0.6 * s;
    final baseline = tp.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    tp.paint(canvas, Offset(24 * s - glyphWidth / 2, 30.5 * s - baseline));
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.onDark != onDark || old.keyline != keyline || old.family != family;
}

/// The in-app twin of the native launch screen: deep green with the on-dark
/// lockup and a quiet progress indicator.
class DrsBrandSplash extends StatelessWidget {
  const DrsBrandSplash({super.key});

  @override
  Widget build(BuildContext context) => const ColoredBox(
    color: DrsBrandColors.green,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DrsLogo(size: 56, onDark: true),
          SizedBox(height: 24),
          SizedBox.square(
            dimension: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: DrsBrandColors.cream,
            ),
          ),
        ],
      ),
    ),
  );
}
