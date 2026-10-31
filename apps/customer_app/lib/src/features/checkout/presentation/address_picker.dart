import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../common/async_views.dart';
import '../application/checkout_controller.dart';

/// Saved-address radio list + "Add new address".
class AddressPicker extends ConsumerWidget {
  const AddressPicker({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final Address? selected;
  final ValueChanged<Address> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addresses = ref.watch(addressesProvider);
    Future<void> addNew() async {
      final created = await context.push<Address>(Routes.newAddress);
      if (created != null) onSelected(created);
    }

    return AsyncBody(
      value: addresses,
      onRetry: () => ref.invalidate(addressesProvider),
      errorTitle: "Couldn't load addresses",
      builder: (list) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // One focus stop per address, announced as a radio item
          // ("Home, 12 Gandhi Path…, Default, checked").
          for (final a in list)
            Semantics(
              inMutuallyExclusiveGroup: true,
              checked: a.id == selected?.id,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: ExcludeSemantics(
                  child: Icon(
                    a.id == selected?.id
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                title: Text(a.title),
                subtitle: Text(a.oneLine),
                trailing: a.isDefault
                    ? const DrsStatusChip(label: 'Default')
                    : null,
                onTap: () => onSelected(a),
              ),
            ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: DrsButton(
              label: 'Add new address',
              variant: DrsButtonVariant.text,
              icon: Icons.add_location_alt_outlined,
              onPressed: addNew,
            ),
          ),
        ],
      ),
    );
  }
}
