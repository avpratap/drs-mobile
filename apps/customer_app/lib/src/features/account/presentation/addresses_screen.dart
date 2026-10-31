import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../checkout/application/checkout_controller.dart';
import '../../common/async_views.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Addresses'),
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
            : ListView(
                padding: const EdgeInsets.fromLTRB(
                  DrsSpacing.md,
                  DrsSpacing.md,
                  DrsSpacing.md,
                  // Keep the last card clear of the FAB.
                  DrsSpacing.xxl * 2,
                ),
                children: [
                  for (final a in list)
                    Card(
                      child: ListTile(
                        title: Text(a.title),
                        subtitle: Text(
                          [
                            a.oneLine,
                            ?a.contactName,
                            ?a.maskedPhone,
                          ].join('\n'),
                        ),
                        isThreeLine: true,
                        trailing: a.isDefault
                            ? const DrsStatusChip(label: 'Default')
                            : null,
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
