import 'package:flutter/widgets.dart';

/// Material 3 window-size classes, by available width in logical pixels.
enum DrsWindowSize {
  /// < 600 — phones in portrait (incl. small 320dp devices).
  compact,

  /// 600–839 — large phones in landscape, small tablets, foldables.
  medium,

  /// ≥ 840 — tablets in landscape.
  expanded;

  static const mediumMin = 600.0;
  static const expandedMin = 840.0;

  static DrsWindowSize forWidth(double width) => width >= expandedMin
      ? expanded
      : width >= mediumMin
      ? medium
      : compact;

  /// Size class of the whole window (use [forWidth] with a LayoutBuilder for
  /// the space a widget actually gets).
  static DrsWindowSize of(BuildContext context) =>
      forWidth(MediaQuery.sizeOf(context).width);

  bool get isCompact => this == compact;
}
