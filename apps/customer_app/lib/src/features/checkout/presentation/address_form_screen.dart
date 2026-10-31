import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/checkout_controller.dart';

/// Add a delivery address. Pops with the created [Address].
class AddressFormScreen extends HookConsumerWidget {
  const AddressFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useMemoized(GlobalKey<FormState>.new);
    final label = useTextEditingController(text: 'Home');
    final name = useTextEditingController();
    final phone = useTextEditingController();
    final line1 = useTextEditingController();
    final line2 = useTextEditingController();
    final landmark = useTextEditingController();
    final city = useTextEditingController();
    final pincode = useTextEditingController();
    final state = useState<String?>(null);
    final makeDefault = useState(true);
    final busy = useState(false);
    final error = useState<String?>(null);

    String? required(String? v) =>
        (v == null || v.trim().isEmpty) ? 'Required' : null;

    Future<void> save() async {
      if (!form.currentState!.validate()) return;
      busy.value = true;
      error.value = null;
      try {
        final phoneE164 = phone.text.trim().isEmpty
            ? null
            : IndianPhone.normalize(phone.text);
        final created = await ref
            .read(checkoutRepositoryProvider)
            .createAddress(
              AddressIn(
                label: label.text.trim().isEmpty ? null : label.text.trim(),
                contactName: name.text.trim().isEmpty ? null : name.text.trim(),
                contactPhone: phoneE164,
                line1: line1.text.trim(),
                line2: line2.text.trim().isEmpty ? null : line2.text.trim(),
                landmark: landmark.text.trim().isEmpty
                    ? null
                    : landmark.text.trim(),
                city: city.text.trim(),
                state: state.value!,
                pincode: pincode.text.trim(),
                isDefault: makeDefault.value,
              ),
            );
        ref.invalidate(addressesProvider);
        if (context.mounted) context.pop(created);
      } on DrsApiError catch (e) {
        error.value = e.message;
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    InputDecoration dec(String l, {String? hint}) =>
        InputDecoration(labelText: l, hintText: hint);
    const gap = SizedBox(height: DrsSpacing.sm);

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'New address'),
      body: Form(
        key: form,
        child: AutofillGroup(
          child: ListView(
            padding: const EdgeInsets.all(DrsSpacing.md),
            children: [
              TextFormField(
                controller: line1,
                decoration: dec('House / flat, street'),
                autofillHints: const [AutofillHints.streetAddressLine1],
                textInputAction: TextInputAction.next,
                validator: required,
              ),
              gap,
              TextFormField(
                controller: line2,
                decoration: dec('Area / locality (optional)'),
                autofillHints: const [AutofillHints.streetAddressLine2],
                textInputAction: TextInputAction.next,
              ),
              gap,
              TextFormField(
                controller: landmark,
                decoration: dec('Landmark (optional)'),
                textInputAction: TextInputAction.next,
              ),
              gap,
              TextFormField(
                controller: city,
                decoration: dec('City'),
                autofillHints: const [AutofillHints.addressCity],
                textInputAction: TextInputAction.next,
                validator: required,
              ),
              gap,
              DropdownButtonFormField<String>(
                initialValue: state.value,
                isExpanded: true,
                decoration: dec('State'),
                items: [
                  for (final s in IndianStates.all)
                    DropdownMenuItem(value: s, child: Text(s)),
                ],
                onChanged: (v) => state.value = v,
                validator: (v) => v == null ? 'Required' : null,
              ),
              gap,
              TextFormField(
                controller: pincode,
                decoration: dec('PIN code'),
                keyboardType: TextInputType.number,
                autofillHints: const [AutofillHints.postalCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                validator: (v) => IndianStates.isValidPincode(v ?? '')
                    ? null
                    : 'Enter a valid 6-digit PIN code',
              ),
              const SizedBox(height: DrsSpacing.lg),
              Text(
                'Delivery contact (optional)',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              gap,
              TextFormField(
                controller: name,
                decoration: dec('Name'),
                autofillHints: const [AutofillHints.name],
                textInputAction: TextInputAction.next,
              ),
              gap,
              TextFormField(
                controller: phone,
                decoration: dec('Mobile', hint: '98765 43210'),
                keyboardType: TextInputType.phone,
                autofillHints: const [AutofillHints.telephoneNumberNational],
                validator: (v) =>
                    (v == null || v.trim().isEmpty || IndianPhone.isValid(v))
                    ? null
                    : 'Enter a valid mobile number',
              ),
              gap,
              TextFormField(
                controller: label,
                decoration: dec('Save as', hint: 'Home, Office…'),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Use as default address'),
                value: makeDefault.value,
                onChanged: (v) => makeDefault.value = v,
              ),
              if (error.value != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: DrsSpacing.sm),
                  child: Text(
                    error.value!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              DrsButton(
                label: 'Save address',
                expand: true,
                isLoading: busy.value,
                onPressed: save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
