import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _Dest {
  const _Dest(this.label, this.icon, this.selectedIcon);

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _destinations = [
  _Dest('Home', Icons.home_outlined, Icons.home),
  _Dest('Shop', Icons.storefront_outlined, Icons.storefront),
  _Dest('Subscriptions', Icons.event_repeat_outlined, Icons.event_repeat),
  _Dest('Account', Icons.person_outline, Icons.person),
];

/// Adaptive navigation shell: a bottom [NavigationBar] on compact widths
/// (phones in portrait) and a [NavigationRail] on medium/expanded widths
/// (phones in landscape, tablets), so content isn't squeezed vertically.
class HomeShell extends StatelessWidget {
  const HomeShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _go(int i) => navigationShell.goBranch(
    i,
    initialLocation: i == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context) {
    final size = DrsWindowSize.of(context);
    if (size.isCompact) {
      return Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: _go,
          destinations: [
            for (final d in _destinations)
              NavigationDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: d.label,
              ),
          ],
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Row(
        children: [
          // Rail keeps clear of a landscape notch / rounded corner on the
          // leading edge; the body handles the trailing edge.
          ColoredBox(
            color: scheme.surfaceContainerLow,
            child: SafeArea(
              right: false,
              child: NavigationRail(
                backgroundColor: Colors.transparent,
                selectedIndex: navigationShell.currentIndex,
                onDestinationSelected: _go,
                extended: size == DrsWindowSize.expanded,
                labelType: size == DrsWindowSize.expanded
                    ? NavigationRailLabelType.none
                    : NavigationRailLabelType.all,
                indicatorColor: scheme.primaryContainer,
                leading: const Padding(
                  padding: EdgeInsets.symmetric(vertical: DrsSpacing.md),
                  child: DrsLogo(size: 22),
                ),
                destinations: [
                  for (final d in _destinations)
                    NavigationRailDestination(
                      icon: Icon(d.icon),
                      selectedIcon: Icon(d.selectedIcon),
                      label: Text(d.label),
                    ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1, thickness: 1),
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeLeft: true,
              child: navigationShell,
            ),
          ),
        ],
      ),
    );
  }
}
