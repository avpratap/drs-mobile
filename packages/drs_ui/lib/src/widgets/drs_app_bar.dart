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
    title: title == null ? const DrsLogo(size: 24) : Text(title!),
    leading: leading,
    actions: actions,
    bottom: bottom,
  );
}
