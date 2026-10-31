import 'package:flutter/material.dart';

import '../theme/drs_spacing.dart';

/// Scaffold that keeps content readable on tablets / landscape by centring it
/// at [DrsSpacing.maxContentWidth], and applies SafeArea.
class DrsScaffold extends StatelessWidget {
  const DrsScaffold({
    required this.body,
    super.key,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.banner,
    this.padded = false,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  /// Full-width strip pinned above the body (e.g. an offline banner).
  final Widget? banner;

  /// Apply standard horizontal padding to [body].
  final bool padded;

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: DrsSpacing.maxContentWidth),
      child: padded
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: DrsSpacing.md),
              child: body,
            )
          : body,
    );
    content = Align(alignment: Alignment.topCenter, child: content);
    if (banner != null) {
      content = Column(
        children: [
          banner!,
          Expanded(child: content),
        ],
      );
    }
    return Scaffold(
      appBar: appBar,
      body: SafeArea(bottom: bottomNavigationBar == null, child: content),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}
