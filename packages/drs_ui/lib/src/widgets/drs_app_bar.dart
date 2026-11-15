import 'package:flutter/material.dart';

import 'drs_logo.dart';

/// App bar with either a [title] or, by default, the DRS wordmark.
class DrsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrsAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.bottom,
  });

  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) => AppBar(
    // Titles can be dynamic (product names, a stop's customer name,
    // "Reviews · <product>"). Keep them to one line so a long name
    // ellipsizes instead of wrapping/clipping in the fixed-height toolbar.
    title: title == null
        ? const DrsLogo(size: 36)
        : Text(title!, maxLines: 1, overflow: TextOverflow.ellipsis),
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}
