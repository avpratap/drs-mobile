import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../common/async_views.dart';
import '../application/orders_providers.dart';
import 'order_widgets.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    Future<void> refresh() async {
      ref.invalidate(ordersProvider);
      try {
        await ref.read(ordersProvider.future);
      } on Object {
        // Shown by the error state.
      }
    }

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Your orders'),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      banner: orders.value?.fromCache ?? false
          ? DrsOfflineBanner(
              message: 'Offline — showing saved orders.',
              onRetry: refresh,
            )
          : null,
      body: AsyncBody(
        value: orders,
        onRetry: refresh,
        errorTitle: "Couldn't load your orders",
        builder: (cached) => RefreshIndicator.adaptive(
          onRefresh: refresh,
          child: cached.value.isEmpty
              ? ListView(
                  children: [
                    const SizedBox(height: DrsSpacing.xxl),
                    DrsEmptyState(
                      icon: Icons.receipt_long,
                      title: 'No orders yet',
                      message: 'Your one-time orders will show up here.',
                      actionLabel: 'Start shopping',
                      onAction: () => context.go(Routes.shop),
                    ),
                  ],
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(DrsSpacing.md),
                      sliver: DrsAdaptiveSliverList(
                        itemCount: cached.value.length,
                        itemBuilder: (context, i) {
                          final o = cached.value[i];
                          return Card(
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(
                                DrsSpacing.sm,
                              ),
                              title: Text(o.orderNo),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(
                                  top: DrsSpacing.xxs,
                                ),
                                child: Wrap(
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
                              ),
                              trailing: Text(
                                o.total.format(compact: false),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              onTap: () => context.push(Routes.order(o.id)),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
