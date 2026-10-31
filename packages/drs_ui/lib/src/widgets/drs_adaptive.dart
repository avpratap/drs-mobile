import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/drs_spacing.dart';

/// A sliver list that flows into columns as the space widens: one column on
/// phones, more on landscape / tablets. Rows keep intrinsic heights, so items
/// still grow with the user's text size (unlike a fixed-extent grid).
class DrsAdaptiveSliverList extends StatelessWidget {
  const DrsAdaptiveSliverList({
    required this.itemCount,
    required this.itemBuilder,
    super.key,
    this.minItemWidth = 340,
    this.maxColumns = 3,
    this.spacing = DrsSpacing.sm,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  /// Columns are added only while each stays at least this wide.
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  static int columnsFor(double width, double minItemWidth, int maxColumns) =>
      (width / minItemWidth).floor().clamp(1, maxColumns);

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) {
      final cols = columnsFor(
        constraints.crossAxisExtent,
        minItemWidth,
        maxColumns,
      );
      final rows = (itemCount / cols).ceil();
      return SliverList.builder(
        itemCount: rows,
        itemBuilder: (context, row) => Padding(
          padding: EdgeInsets.only(bottom: spacing),
          child: cols == 1
              ? itemBuilder(context, row)
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var c = 0; c < cols; c++) ...[
                      if (c > 0) SizedBox(width: spacing),
                      Expanded(
                        child: row * cols + c < itemCount
                            ? itemBuilder(context, row * cols + c)
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ],
                ),
        ),
      );
    },
  );
}

/// Platform-adaptive confirm dialog (Cupertino alert on iOS/macOS, Material
/// elsewhere). Returns true when confirmed.
Future<bool> showDrsConfirmDialog(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? message,
  String cancelLabel = 'Cancel',
  bool destructive = false,
}) async {
  final theme = Theme.of(context);
  final result = await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      title: Text(title),
      content: message == null ? null : Text(message),
      actions: [
        _action(context, cancelLabel, false, theme),
        _action(context, confirmLabel, true, theme, destructive: destructive),
      ],
    ),
  );
  return result ?? false;
}

Widget _action(
  BuildContext context,
  String label,
  bool value,
  ThemeData theme, {
  bool destructive = false,
}) {
  void onPressed() => Navigator.of(context).pop(value);
  switch (theme.platform) {
    case TargetPlatform.iOS:
    case TargetPlatform.macOS:
      return CupertinoDialogAction(
        isDefaultAction: value && !destructive,
        isDestructiveAction: destructive,
        onPressed: onPressed,
        child: Text(label),
      );
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.linux:
    case TargetPlatform.windows:
      return TextButton(
        onPressed: onPressed,
        style: destructive
            ? TextButton.styleFrom(foregroundColor: theme.colorScheme.error)
            : null,
        child: Text(label),
      );
  }
}
