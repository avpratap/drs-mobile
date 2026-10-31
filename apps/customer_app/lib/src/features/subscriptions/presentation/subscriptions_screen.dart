import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/subscription_providers.dart';
import 'subscription_format.dart';

/// Standing orders: what arrives tomorrow, the item template, and
/// pause / skip-a-day / resume / cancel.
class SubscriptionsScreen extends ConsumerWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subs = ref.watch(subscriptionsProvider);
    Future<void> refresh() async {
      ref.invalidate(subscriptionsProvider);
      try {
        await ref.read(subscriptionsProvider.future);
      } on Object {
        // Shown by the error state.
      }
    }

    return DrsScaffold(
      appBar: DrsAppBar(
        title: 'Subscriptions',
        actions: [
          IconButton(
            tooltip: 'Add a product',
            icon: const Icon(Icons.add),
            onPressed: () => context.push(Routes.subscribeBrowse),
          ),
        ],
      ),
      banner: subs.value?.fromCache ?? false
          ? DrsOfflineBanner(
              message: 'Offline — showing your saved standing order.',
              onRetry: refresh,
            )
          : null,
      body: AsyncBody(
        value: subs,
        onRetry: refresh,
        errorTitle: "Couldn't load subscriptions",
        builder: (cached) {
          final list = cached.value;
          final live = list.where(
            (s) =>
                s.status != SubscriptionStatus.cancelled && s.items.isNotEmpty,
          );
          if (live.isEmpty) {
            return DrsEmptyState(
              icon: Icons.event_repeat,
              title: 'Daily deliveries, your way',
              message:
                  'Get milk, curd and more every morning, on alternate days '
                  'or on the weekdays you choose.',
              actionLabel: 'Choose products',
              onAction: () => context.push(Routes.subscribeBrowse),
            );
          }
          return RefreshIndicator.adaptive(
            onRefresh: refresh,
            child: ListView(
              padding: const EdgeInsets.all(DrsSpacing.md),
              children: [
                for (final s in live) ...[
                  _SubscriptionCard(sub: s, offline: cached.fromCache),
                  const SizedBox(height: DrsSpacing.md),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SubscriptionCard extends HookConsumerWidget {
  const _SubscriptionCard({required this.sub, required this.offline});

  final Subscription sub;
  final bool offline;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(productIndexProvider);
    final plan = offline ? null : ref.watch(nextDeliveryPlanProvider(sub.id));
    final busy = useState(false);
    final actions = ref.read(subscriptionActionsProvider.notifier);
    final theme = Theme.of(context);

    Future<void> run(Future<void> Function() op, String done) async {
      busy.value = true;
      await runWithSnack(context, op, success: done);
      if (context.mounted) busy.value = false;
    }

    Future<void> skip() async {
      final first = firstEditableDate();
      final picked = await showDatePicker(
        context: context,
        helpText: 'Skip delivery on',
        firstDate: first,
        initialDate: first,
        lastDate: first.add(const Duration(days: 60)),
      );
      if (picked == null || !context.mounted) return;
      await run(
        () => actions.skipDay(sub, picked),
        'Delivery on ${dayLabel(picked)} skipped',
      );
    }

    Future<void> cancel() async {
      final ok = await showDrsConfirmDialog(
        context,
        title: 'Cancel standing order?',
        message: 'Deliveries stop from the next undelivered day.',
        confirmLabel: 'Cancel subscription',
        cancelLabel: 'Keep',
        destructive: true,
      );
      if (ok) await run(() => actions.cancel(sub), 'Subscription cancelled');
    }

    String productName(int id) => index[id]?.name ?? 'Item #$id';
    String qty(int id, double q) => formatQty(q, index[id]?.uom ?? 'piece');

    return DrsSection(
      title: 'Home delivery',
      trailing: DrsStatusChip(
        label: statusLabel(sub.status),
        tone: statusTone(sub.status),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (plan != null) ...[
            Text('Tomorrow', style: theme.textTheme.titleSmall),
            const SizedBox(height: DrsSpacing.xxs),
            switch (plan) {
              AsyncValue(:final value?)
                  when value.values.every((q) => q == 0) =>
                const Text('No delivery tomorrow.'),
              AsyncValue(:final value?) => Text(
                [
                  for (final e in value.entries)
                    if (e.value > 0)
                      '${productName(e.key)} ${qty(e.key, e.value)}',
                ].join(' · '),
              ),
              AsyncValue(:final error?) => Text(errorMessage(error)),
              _ => const LinearProgressIndicator(),
            },
            const Divider(height: DrsSpacing.lg),
          ],
          for (final i in sub.items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(productName(i.productId)),
              subtitle: Text(
                '${qty(i.productId, i.defaultQty)} · ${cadenceLabel(i)}',
              ),
              trailing: PopupMenuButton<String>(
                tooltip: 'Item options',
                enabled: !offline && !busy.value,
                onSelected: (v) => switch (v) {
                  'edit' => context.push(Routes.subscribeProduct(i.productId)),
                  _ => run(
                    () => actions.removeItem(sub, i.productId),
                    '${productName(i.productId)} removed',
                  ),
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Change')),
                  PopupMenuItem(value: 'remove', child: Text('Remove')),
                ],
              ),
            ),
          const SizedBox(height: DrsSpacing.sm),
          if (busy.value)
            const LinearProgressIndicator()
          else
            Wrap(
              spacing: DrsSpacing.xs,
              runSpacing: DrsSpacing.xs,
              children: [
                if (sub.canPause)
                  DrsButton.secondary(
                    label: 'Pause',
                    icon: Icons.pause,
                    onPressed: offline
                        ? null
                        : () => run(
                            () => actions.pause(sub),
                            'Deliveries paused',
                          ),
                  ),
                if (sub.canResume)
                  DrsButton(
                    label: 'Resume',
                    icon: Icons.play_arrow,
                    onPressed: offline
                        ? null
                        : () => run(
                            () => actions.resume(sub),
                            'Deliveries resumed',
                          ),
                  ),
                if (sub.status == SubscriptionStatus.active)
                  DrsButton.secondary(
                    label: 'Skip a day',
                    icon: Icons.event_busy,
                    onPressed: offline ? null : skip,
                  ),
                DrsButton(
                  label: 'Cancel',
                  variant: DrsButtonVariant.text,
                  onPressed: offline ? null : cancel,
                ),
              ],
            ),
          const SizedBox(height: DrsSpacing.xs),
          Text(
            'Changes for tomorrow close at $cutoffHourIst:00 IST.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
