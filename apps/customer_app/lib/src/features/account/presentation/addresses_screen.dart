import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../checkout/application/checkout_controller.dart';
import '../../common/async_views.dart';
import '../application/account_providers.dart';

/// Saved addresses: list, add, edit, set default, delete.
class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Addresses'),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.newAddress),
        icon: const Icon(Icons.add_location_alt_outlined),
        label: const Text('Add address'),
      ),
      body: AsyncBody(
        value: addresses,
        onRetry: () => ref.invalidate(addressesProvider),
        errorTitle: "Couldn't load addresses",
        builder: (list) => list.isEmpty
            ? const DrsEmptyState(
                icon: Icons.location_on_outlined,
                title: 'No saved addresses',
                message: 'Add one to check out faster.',
              )
            : RefreshIndicator.adaptive(
                onRefresh: () async => ref.invalidate(addressesProvider),
                child: CustomScrollView(
                  slivers: [
                    SliverPadding(
                      // Keep the last card clear of the FAB.
                      padding: const EdgeInsets.fromLTRB(
                        DrsSpacing.md,
                        DrsSpacing.md,
                        DrsSpacing.md,
                        DrsSpacing.xxl * 2,
                      ),
                      sliver: DrsAdaptiveSliverList(
                        itemCount: list.length,
                        itemBuilder: (_, i) => _AddressCard(address: list[i]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _AddressCard extends ConsumerWidget {
  const _AddressCard({required this.address});

  final Address address;

  Future<void> _act(BuildContext context, WidgetRef ref, String action) async {
    final repo = ref.read(accountRepositoryProvider);
    switch (action) {
      case 'edit':
        await context.push<Address>(Routes.editAddress, extra: address);
      case 'default':
        await runWithSnack(
          context,
          () => repo.setDefaultAddress(address.id),
          success: '${address.title} is now your default address',
        );
      case 'delete':
        final ok = await showDrsConfirmDialog(
          context,
          title: 'Delete this address?',
          message: address.oneLine,
          confirmLabel: 'Delete',
          destructive: true,
        );
        if (!ok || !context.mounted) return;
        await runWithSnack(
          context,
          () => repo.deleteAddress(address.id),
          success: 'Address deleted',
        );
    }
    ref.invalidate(addressesProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(DrsSpacing.md, DrsSpacing.sm, 0, DrsSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: DrsSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(address.title, style: theme.textTheme.titleMedium),
                      if (address.isDefault)
                        const DrsStatusChip(label: 'Default', tone: DrsTone.positive),
                    ],
                  ),
                  const SizedBox(height: DrsSpacing.xxs),
                  Text(address.oneLine),
                  if (address.contactName != null || address.maskedPhone != null)
                    Text(
                      [?address.contactName, ?address.maskedPhone].join(' · '),
                      style: theme.textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            PopupMenuButton<String>(
              tooltip: 'Address options',
              onSelected: (v) => _act(context, ref, v),
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Edit')),
                if (!address.isDefault)
                  const PopupMenuItem(value: 'default', child: Text('Set as default')),
                const PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
