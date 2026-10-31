import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/rider_auth.dart';
import '../../core/providers.dart';
import '../../core/push.dart';
import '../../routes.dart';
import '../common.dart';
import '../map/stops_map.dart';
import '../stop/stop_widgets.dart';
import '../sync/sync_controller.dart';
import 'route_providers.dart';

/// The rider's stops for today across all assigned shops, grouped by shop.
/// On wide screens (tablet / landscape) the map sits beside the list.
class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  static Future<void> refresh(WidgetRef ref) async {
    await ref.read(syncControllerProvider.notifier).syncNow();
    ref
      ..invalidate(routeProvider)
      ..invalidate(productsProvider);
    try {
      await ref.read(routeProvider.future);
    } on Object {
      // Shown by the error state.
    }
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    final unsynced =
        (await ref.read(deliveryDatabaseProvider).allPending()).length;
    if (!context.mounted) return;
    final ok = await showDrsConfirmDialog(
      context,
      title: 'Log out?',
      message: unsynced == 0
          ? 'You will need a new OTP to log in again.'
          : '$unsynced update(s) have not synced yet and will be lost. '
                'Go online and sync first if you can.',
      confirmLabel: 'Log out',
      destructive: true,
    );
    if (ok) await ref.read(riderAuthProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(routeViewProvider);
    final pending = ref.watch(pendingActionsProvider).value ?? const [];
    final sync = ref.watch(syncControllerProvider);
    final day = ref.watch(routeDayProvider);

    final waiting = pending.where((p) => p.state == 'queued').length;
    final attention = pending.where((p) => p.state == 'failed').length;

    Widget? banner;
    if (attention > 0) {
      banner = _Strip(
        icon: Icons.error_outline,
        tone: DrsTone.negative,
        text: '$attention update(s) need your attention.',
      );
    } else if (waiting > 0) {
      banner = _Strip(
        icon: Icons.cloud_upload_outlined,
        tone: DrsTone.warning,
        text: sync.running
            ? 'Syncing $waiting update(s)…'
            : '$waiting update(s) waiting to sync${sync.offline ? ' — offline' : ''}.',
        action: sync.running
            ? null
            : TextButton(
                onPressed: () =>
                    ref.read(syncControllerProvider.notifier).syncNow(),
                child: const Text('Sync now'),
              ),
      );
    } else if (view.value?.fromCache ?? false) {
      banner = DrsOfflineBanner(
        message: "You're offline — showing today's saved route.",
        onRetry: () => refresh(ref),
      );
    }

    return DrsScaffold(
      maxContentWidth: double.infinity,
      appBar: DrsAppBar(
        title: "Today's deliveries",
        actions: [
          IconButton(
            tooltip: 'Map',
            icon: const Icon(Icons.map_outlined),
            onPressed: () => context.push(Routes.map),
          ),
          IconButton(
            tooltip: 'Notifications',
            icon: const Icon(Icons.notifications_none),
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              useSafeArea: true,
              showDragHandle: true,
              constraints: const BoxConstraints(
                maxWidth: DrsSpacing.maxContentWidth,
              ),
              builder: (_) => const SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(bottom: DrsSpacing.md),
                  child: NotificationsSettingsTile(),
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      banner: banner,
      body: switch (view) {
        AsyncValue(:final value?) => LayoutBuilder(
          builder: (context, c) {
            final list = _RouteList(view: value, day: day);
            if (DrsWindowSize.forWidth(c.maxWidth) != DrsWindowSize.expanded) {
              return list;
            }
            return Row(
              children: [
                Expanded(flex: 5, child: list),
                const VerticalDivider(width: 1),
                Expanded(
                  flex: 4,
                  child: StopsMap(
                    stops: value.effectiveStops,
                    onSelect: (s) => context.push(Routes.stop(s.orderId)),
                  ),
                ),
              ],
            );
          },
        ),
        AsyncValue(:final error?) => DrsEmptyState.error(
          title: "Couldn't load today's route",
          message: errorMessage(error),
          onAction: () => refresh(ref),
        ),
        _ => const DrsLoading(message: "Loading today's route…"),
      },
    );
  }
}

class _Strip extends StatelessWidget {
  const _Strip({
    required this.icon,
    required this.tone,
    required this.text,
    this.action,
  });

  final IconData icon;
  final DrsTone tone;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = tone == DrsTone.negative
        ? scheme.errorContainer
        : scheme.tertiaryContainer;
    final fg = tone == DrsTone.negative
        ? scheme.onErrorContainer
        : scheme.onTertiaryContainer;
    return Semantics(
      liveRegion: true,
      child: Material(
        color: bg,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DrsSpacing.md,
            vertical: DrsSpacing.xxs,
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: DrsSpacing.xs),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: DrsSpacing.xs),
                  child: Text(
                    text,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: fg),
                  ),
                ),
              ),
              ?action,
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteList extends ConsumerWidget {
  const _RouteList({required this.view, required this.day});

  final RouteView view;
  final DateTime day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final summary = RouteSummary.of(view.effectiveStops);
    final groups = ShopGroup.group(view.effectiveStops);
    final byOrder = {for (final v in view.stops) v.stop.orderId: v};

    return RefreshIndicator.adaptive(
      onRefresh: () => TodayScreen.refresh(ref),
      child: ListView(
        padding: const EdgeInsets.all(DrsSpacing.md),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(DrsSpacing.md),
              child: Semantics(
                container: true,
                label:
                    '${summary.done} of ${summary.total} delivered, '
                    '${summary.failed} failed, ${summary.remaining} remaining',
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1]} '
                      '${day.day}/${day.month}',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: DrsSpacing.xs),
                    Text(
                      '${summary.done} of ${summary.total} delivered',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: DrsSpacing.xs),
                    LinearProgressIndicator(
                      value: summary.total == 0
                          ? 0
                          : (summary.done + summary.failed) / summary.total,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(DrsRadius.pill),
                    ),
                    const SizedBox(height: DrsSpacing.xs),
                    Text(
                      '${summary.remaining} remaining · ${summary.failed} failed',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: DrsSpacing.md),
          const NotificationsOptInCard(),
          if (groups.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: DrsSpacing.xl),
              child: DrsEmptyState(
                icon: Icons.local_shipping_outlined,
                title: 'No deliveries for today',
                message: "Your route will appear here once it's assigned. Pull down to refresh.",
              ),
            ),
          for (final g in groups) ...[
            DrsSection(
              title: g.name,
              trailing: DrsStatusChip(
                label: '${g.doneCount}/${g.stops.length} done',
              ),
              padding: const EdgeInsets.fromLTRB(
                DrsSpacing.md,
                DrsSpacing.md,
                DrsSpacing.xs,
                DrsSpacing.xs,
              ),
              child: Column(
                children: [
                  for (final s in g.stops) _StopTile(view: byOrder[s.orderId]!),
                ],
              ),
            ),
            const SizedBox(height: DrsSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _StopTile extends StatelessWidget {
  const _StopTile({required this.view});

  final StopView view;

  @override
  Widget build(BuildContext context) {
    final s = view.stop;
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      contentPadding: const EdgeInsets.only(right: DrsSpacing.xs),
      leading: CircleAvatar(
        backgroundColor: view.status.isOpen
            ? scheme.primaryContainer
            : scheme.surfaceContainerHigh,
        foregroundColor: view.status.isOpen
            ? scheme.onPrimaryContainer
            : scheme.onSurfaceVariant,
        child: Text('${s.sequence}'),
      ),
      title: Text(s.contactName ?? 'Stop ${s.sequence}'),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: DrsSpacing.xxs),
        child: Wrap(
          spacing: DrsSpacing.xs,
          runSpacing: DrsSpacing.xxs,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            StopStatusChip(view: view),
            if (s.addressLine.isNotEmpty) Text(s.addressLine),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.push(Routes.stop(s.orderId)),
    );
  }
}
