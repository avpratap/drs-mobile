import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/orders_providers.dart';
import 'order_widgets.dart';

/// Order detail: tracking timeline, shipments, items with GST, actions.
class OrderDetailScreen extends ConsumerWidget {
  const OrderDetailScreen({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final order = ref.watch(orderDetailProvider(orderId));
    final tracking = ref.watch(orderTrackingProvider(orderId));
    void refresh() {
      ref
        ..invalidate(orderDetailProvider(orderId))
        ..invalidate(orderTrackingProvider(orderId));
    }

    return DrsScaffold(
      appBar: DrsAppBar(title: order.value?.orderNo ?? 'Order'),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      body: AsyncBody(
        value: order,
        onRetry: refresh,
        errorTitle: "Couldn't load this order",
        builder: (o) => RefreshIndicator.adaptive(
          onRefresh: () async => refresh(),
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = !DrsWindowSize.forWidth(c.maxWidth).isCompact;
              final track = DrsSection(
                title: 'Tracking',
                child: switch (tracking) {
                  AsyncValue(:final value?) => _Timeline(tracking: value),
                  AsyncValue(:final error?) => Text(errorMessage(error)),
                  _ => const LinearProgressIndicator(),
                },
              );
              final details = Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Items(order: o),
                  const SizedBox(height: DrsSpacing.sm),
                  _Actions(order: o, onChanged: refresh),
                ],
              );
              return ListView(
                padding: const EdgeInsets.all(DrsSpacing.md),
                children: [
                  Wrap(
                    spacing: DrsSpacing.xs,
                    runSpacing: DrsSpacing.xxs,
                    children: [
                      DrsStatusChip(
                        label: o.status.label,
                        tone: orderTone(o.status),
                      ),
                      DrsStatusChip(
                        label: o.paymentStatus.label,
                        tone: paymentTone(o.paymentStatus),
                      ),
                    ],
                  ),
                  const SizedBox(height: DrsSpacing.sm),
                  if (wide)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: track),
                        const SizedBox(width: DrsSpacing.md),
                        Expanded(child: details),
                      ],
                    )
                  else ...[
                    track,
                    const SizedBox(height: DrsSpacing.sm),
                    details,
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.tracking});

  final OrderTracking tracking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reached = tracking.stepIndex;
    if (reached < 0) {
      return Text(
        'This order was ${tracking.status.label.toLowerCase()}.',
        style: theme.textTheme.bodyMedium,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < OrderTracking.steps.length; i++)
          Semantics(
            container: true,
            label:
                '${OrderTracking.steps[i].label}, '
                '${i <= reached ? 'done' : 'pending'}',
            excludeSemantics: true,
            child: Row(
              children: [
                Icon(
                  i <= reached
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: i <= reached
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                ),
                const SizedBox(width: DrsSpacing.sm),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: DrsSpacing.xs,
                    ),
                    child: Text(
                      OrderTracking.steps[i].label,
                      style: i == reached
                          ? theme.textTheme.titleSmall
                          : theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        for (final s in tracking.shipments) ...[
          const Divider(height: DrsSpacing.lg),
          Text(
            [
              'Shipment ${s.shipmentNo}',
              if (s.courier != null) s.courier!,
              if (s.awb != null) 'AWB ${s.awb}',
            ].join(' · '),
            style: theme.textTheme.titleSmall,
          ),
          for (final e in s.events.take(5))
            Padding(
              padding: const EdgeInsets.only(top: DrsSpacing.xxs),
              child: Text(
                [
                  e.status,
                  if (e.location != null) e.location!,
                  if (e.time != null) _fmt(e.time!.toLocal()),
                ].join(' · '),
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ],
    );
  }

  static String _fmt(DateTime t) =>
      '${t.day}/${t.month} ${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';
}

class _Items extends ConsumerWidget {
  const _Items({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(productIndexProvider);
    return DrsSection(
      title: 'Items',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final l in order.lines)
            DrsSummaryRow(
              label:
                  '${index[l.productId]?.name ?? 'Item #${l.productId}'} · '
                  '${formatQty(l.qty, index[l.productId]?.uom ?? 'piece')}',
              value: l.lineTotal.format(compact: false),
            ),
          const Divider(height: DrsSpacing.lg),
          DrsTotals(
            subtotal: order.subtotal,
            discount: order.discount,
            total: order.total,
            gstIncluded: order.taxTotal,
          ),
        ],
      ),
    );
  }
}

class _Actions extends HookConsumerWidget {
  const _Actions({required this.order, required this.onChanged});

  final Order order;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = useState(false);
    if (!order.canPay && !order.canCancel) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (order.canPay)
          DrsButton(
            label: 'Pay now · ${order.total.format(compact: false)}',
            onPressed: () => context.push(Routes.payOrder, extra: order),
          ),
        if (order.canCancel)
          DrsButton(
            label: 'Cancel order',
            variant: DrsButtonVariant.text,
            isLoading: busy.value,
            onPressed: () async {
              final ok = await showDrsConfirmDialog(
                context,
                title: 'Cancel this order?',
                confirmLabel: 'Cancel order',
                cancelLabel: 'Keep',
                destructive: true,
              );
              if (!ok || !context.mounted) return;
              busy.value = true;
              await runWithSnack(
                context,
                () => ref.read(ordersRepositoryProvider).cancel(order.id),
                success: 'Order cancelled',
              );
              ref.invalidate(ordersProvider);
              if (context.mounted) busy.value = false;
              onChanged();
            },
          ),
      ],
    );
  }
}
