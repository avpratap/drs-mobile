import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../checkout/application/checkout_controller.dart';
import '../../checkout/presentation/address_picker.dart';
import '../../common/async_views.dart';
import '../application/subscription_providers.dart';
import 'subscription_format.dart';

/// Configure a standing-order line: pack, packs per delivery, cadence, and
/// (for a first subscription) the delivery address.
class SubscribeProductScreen extends ConsumerWidget {
  const SubscribeProductScreen({required this.productId, super.key});

  final int productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(productDetailProvider(productId));
    final subs = ref.watch(subscriptionsProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Standing order'),
      body: AsyncBody(
        value: detail,
        onRetry: () => ref.invalidate(productDetailProvider(productId)),
        builder: (d) => switch (subs) {
          AsyncValue(:final value?) => _Form(
            detail: d,
            existing: value.value
                .where((s) => s.status != SubscriptionStatus.cancelled)
                .expand((s) => s.items)
                .where((i) => i.productId == productId)
                .firstOrNull,
            needsAddress: value.value.every(
              (s) => s.status == SubscriptionStatus.cancelled,
            ),
          ),
          AsyncValue(:final error?) => DrsEmptyState.error(
            title: "Couldn't load your subscriptions",
            message: errorMessage(error),
            onAction: () => ref.invalidate(subscriptionsProvider),
          ),
          _ => const DrsLoading(),
        },
      ),
    );
  }
}

class _Form extends HookConsumerWidget {
  const _Form({
    required this.detail,
    required this.existing,
    required this.needsAddress,
  });

  final ProductDetail detail;
  final SubscriptionItem? existing;
  final bool needsAddress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = detail.product;
    // Prefer the pack that divides the existing quantity evenly.
    Pack? initialPack() {
      if (existing == null) return detail.defaultPack;
      for (final p in detail.packs) {
        if (p.available &&
            packsIn(existing!.defaultQty, p.packSize) * p.packSize ==
                existing!.defaultQty) {
          return p;
        }
      }
      return detail.defaultPack;
    }

    final pack = useState<Pack?>(initialPack());
    final count = useState(
      existing == null || pack.value == null
          ? 1
          : packsIn(existing!.defaultQty, pack.value!.packSize).clamp(1, 20),
    );
    final freq = useState(existing?.frequency ?? DeliveryFrequency.daily);
    final interval = useState(existing?.intervalDays ?? 2);
    final days = useState<Set<int>>({...?existing?.daysOfWeek});
    final address = useState<Address?>(null);
    final addresses = ref.watch(addressesProvider);
    final busy = useState(false);
    final theme = Theme.of(context);

    final deliverTo =
        address.value ??
        addresses.value?.where((a) => a.isDefault).firstOrNull ??
        addresses.value?.firstOrNull;
    final weeklyInvalid =
        freq.value == DeliveryFrequency.weekly && days.value.isEmpty;
    final canSave =
        pack.value != null &&
        !weeklyInvalid &&
        (!needsAddress || deliverTo != null);
    final perDelivery = pack.value?.price?.times(count.value);

    Future<void> save() async {
      busy.value = true;
      final item = SubscriptionItem(
        productId: product.id,
        defaultQty: qtyFor(count.value, pack.value!.packSize),
        frequency: freq.value,
        intervalDays: freq.value == DeliveryFrequency.alternate
            ? interval.value
            : null,
        daysOfWeek: freq.value == DeliveryFrequency.weekly
            ? (days.value.toList()..sort())
            : const [],
      );
      final ok = await runWithSnack(
        context,
        () => ref
            .read(subscriptionActionsProvider.notifier)
            .upsertItem(item, deliverTo: deliverTo),
        success: '${product.name} added to your standing order',
      );
      if (!context.mounted) return;
      busy.value = false;
      if (ok) context.go(Routes.subscriptions);
    }

    return ListView(
      padding: const EdgeInsets.all(DrsSpacing.md),
      children: [
        Text(product.name, style: theme.textTheme.headlineSmall),
        const SizedBox(height: DrsSpacing.md),
        DrsSection(
          title: 'Each delivery',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrsPackSelector(
                packs: detail.packs,
                selected: pack.value,
                onSelected: (p) => pack.value = p,
              ),
              const SizedBox(height: DrsSpacing.sm),
              Row(
                children: [
                  DrsQuantityStepper(
                    value: count.value,
                    min: 1,
                    max: 20,
                    itemLabel: '${product.name} packs per delivery',
                    onChanged: (v) => count.value = v,
                  ),
                  const SizedBox(width: DrsSpacing.md),
                  Expanded(
                    child: Text(
                      pack.value == null
                          ? ''
                          : '${formatQty(qtyFor(count.value, pack.value!.packSize), product.uom)}'
                                '${perDelivery == null ? '' : ' · ${perDelivery.format()}'}',
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: DrsSpacing.sm),
        DrsSection(
          title: 'How often',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<DeliveryFrequency>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: DeliveryFrequency.daily,
                    label: Text('Daily'),
                  ),
                  ButtonSegment(
                    value: DeliveryFrequency.alternate,
                    label: Text('Every few days'),
                  ),
                  ButtonSegment(
                    value: DeliveryFrequency.weekly,
                    label: Text('Weekdays'),
                  ),
                ],
                selected: {freq.value},
                onSelectionChanged: (s) => freq.value = s.first,
              ),
              const SizedBox(height: DrsSpacing.sm),
              if (freq.value == DeliveryFrequency.alternate)
                Row(
                  children: [
                    const Text('Every'),
                    const SizedBox(width: DrsSpacing.sm),
                    DrsQuantityStepper(
                      value: interval.value,
                      min: 2,
                      max: 7,
                      itemLabel: 'Days between deliveries',
                      onChanged: (v) => interval.value = v,
                    ),
                    const SizedBox(width: DrsSpacing.sm),
                    const Text('days'),
                  ],
                ),
              if (freq.value == DeliveryFrequency.weekly) ...[
                Wrap(
                  spacing: DrsSpacing.xs,
                  runSpacing: DrsSpacing.xs,
                  children: [
                    for (var d = 1; d <= 7; d++)
                      FilterChip(
                        label: Text(weekdayShort[d - 1]),
                        selected: days.value.contains(d),
                        onSelected: (on) => days.value = on
                            ? {...days.value, d}
                            : ({...days.value}..remove(d)),
                      ),
                  ],
                ),
                if (weeklyInvalid)
                  Padding(
                    padding: const EdgeInsets.only(top: DrsSpacing.xs),
                    child: Text(
                      'Pick at least one day.',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
              ],
            ],
          ),
        ),
        if (needsAddress) ...[
          const SizedBox(height: DrsSpacing.sm),
          DrsSection(
            title: 'Deliver to',
            child: AddressPicker(
              selected: deliverTo,
              onSelected: (a) => address.value = a,
            ),
          ),
        ],
        const SizedBox(height: DrsSpacing.md),
        Text(
          'Deliveries start from the next available morning. You can pause, '
          'skip a day or cancel any time before the $cutoffHourIst:00 IST '
          'cutoff. Billed per delivery at the GST-inclusive price.',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: DrsSpacing.md),
        DrsButton(
          label: existing == null ? 'Start standing order' : 'Save changes',
          variant: DrsButtonVariant.accent,
          expand: true,
          isLoading: busy.value,
          onPressed: canSave ? save : null,
        ),
      ],
    );
  }
}
