/// 4-pt spacing + radius scale.
abstract final class DrsSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
  static const xxl = 48.0;

  /// Minimum interactive target (Material / WCAG).
  static const minTapTarget = 48.0;

  /// Content is centred and capped at this width on tablets / landscape.
  static const maxContentWidth = 640.0;
}

abstract final class DrsRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 20.0;
  static const pill = 999.0;
}
