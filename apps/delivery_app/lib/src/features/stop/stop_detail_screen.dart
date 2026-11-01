import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routes.dart';
import '../common.dart';
import '../route/route_providers.dart';
import '../sync/sync_controller.dart';
import 'external_actions.dart';
import 'stop_widgets.dart';

class StopDetailScreen extends ConsumerWidget {
  const StopDetailScreen({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeViewProvider);
    final view = route.value?.byOrder(orderId);
    if (view == null) {
      return DrsScaffold(
        appBar: const DrsAppBar(title: 'Stop'),
        body: route.isLoading
            ? const DrsLoading()
            : const DrsEmptyState(title: 'Stop not found on today\'s route'),
      );
    }
    final s = view.stop;
    final products = ref.watch(productsProvider).value ?? const {};
    final theme = Theme.of(context);
    final open = ref.read(urlOpenerProvider);
    final call = callUri(s);

    return DrsScaffold(
      appBar: DrsAppBar(title: s.title),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(DrsSpacing.md),
              children: [
                // Wraps under large text instead of overflowing.
                Wrap(
                  spacing: DrsSpacing.sm,
                  runSpacing: DrsSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      'Stop ${s.sequence}',
                      style: theme.textTheme.titleMedium,
                    ),
                    StopStatusChip(view: view),
                  ],
                ),
                if (view.needsAttention || view.hasConflict) ...[
                  const SizedBox(height: DrsSpacing.sm),
                  _Attention(view: view),
                ],
                if (s.failureReason != null && view.pending == null) ...[
                  const SizedBox(height: DrsSpacing.xs),
                  Text('Reason: ${s.failureReason!.replaceAll('_', ' ')}'),
                ],
                const SizedBox(height: DrsSpacing.sm),
                DrsSection(
                  title: 'Deliver to',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (s.contactName != null)
                        Text(
                          s.contactName!,
                          style: theme.textTheme.titleMedium,
                        ),
                      if (s.maskedPhone != null) Text(s.maskedPhone!),
                      if (s.addressLine.isNotEmpty) ...[
                        const SizedBox(height: DrsSpacing.xs),
                        Text(s.addressLine),
                      ],
                      const SizedBox(height: DrsSpacing.sm),
                      Wrap(
                        spacing: DrsSpacing.xs,
                        runSpacing: DrsSpacing.xs,
                        children: [
                          DrsButton.secondary(
                            label: 'Navigate',
                            icon: Icons.navigation_outlined,
                            onPressed:
                                s.hasCoordinates || s.addressLine.isNotEmpty
                                ? () => open(navigationUri(s, theme.platform))
                                : null,
                          ),
                          if (call != null)
                            DrsButton.secondary(
                              label: 'Call',
                              icon: Icons.call_outlined,
                              onPressed: () => open(call),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DrsSpacing.sm),
                DrsSection(
                  title: 'Items',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final l in s.lines)
                        DrsSummaryRow(
                          label:
                              products[l.productId]?.name ??
                              'Item #${l.productId}',
                          value: formatQty(
                            s.status.isDone ? l.qtyDelivered : l.qtyPlanned,
                            products[l.productId]?.uom ?? 'piece',
                          ),
                        ),
                      if (!s.amountDue.isZero) ...[
                        const Divider(height: DrsSpacing.lg),
                        DrsSummaryRow(
                          label: 'Amount due',
                          value: s.amountDue.format(compact: false),
                          emphasize: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (view.canAct)
            Material(
              color: theme.colorScheme.surfaceContainerLow,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(DrsSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: DrsButton.secondary(
                          label: "Couldn't deliver",
                          onPressed: () => _fail(context, ref, s),
                        ),
                      ),
                      const SizedBox(width: DrsSpacing.sm),
                      Expanded(
                        child: DrsButton(
                          label: 'Mark delivered',
                          onPressed: () =>
                              context.push(Routes.deliver(s.orderId)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _fail(
    BuildContext context,
    WidgetRef ref,
    DeliveryStop s,
  ) async {
    final reason = await showModalBottomSheet<FailReason>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: DrsSpacing.maxContentWidth),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Why couldn't you deliver?",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: DrsSpacing.xs),
            for (final r in FailReason.values)
              ListTile(
                title: Text(r.label),
                onTap: () => Navigator.of(context).pop(r),
              ),
          ],
        ),
      ),
    );
    if (reason == null) return;
    await ref.read(syncControllerProvider.notifier).fail(s, reason);
    if (context.mounted) {
      showSnack(
        context,
        'Marked as not delivered (${reason.label.toLowerCase()})',
      );
      context.pop();
    }
  }
}

class _Attention extends ConsumerWidget {
  const _Attention({required this.view});

  final StopView view;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = view.pending!;
    final c = ref.read(syncControllerProvider.notifier);
    if (view.hasConflict) {
      return Card(
        color: Theme.of(context).colorScheme.errorContainer,
        child: Padding(
          padding: const EdgeInsets.all(DrsSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Changed by the office',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (p.lastError != null) Text(p.lastError!),
              const SizedBox(height: DrsSpacing.xs),
              TextButton(
                onPressed: () => c.acknowledge(p),
                child: const Text("OK, show the office's version"),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        padding: const EdgeInsets.all(DrsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The server rejected this update',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (p.lastError != null) Text(p.lastError!),
            const SizedBox(height: DrsSpacing.xs),
            Wrap(
              spacing: DrsSpacing.xs,
              children: [
                TextButton(
                  onPressed: () => c.retry(p.id),
                  child: const Text('Retry'),
                ),
                TextButton(
                  onPressed: () => c.discard(p),
                  child: const Text('Discard'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
