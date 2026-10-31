import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Indian mobile number field with a fixed +91 prefix.
class DrsPhoneField extends StatelessWidget {
  const DrsPhoneField({
    required this.controller,
    super.key,
    this.errorText,
    this.enabled = true,
    this.autofocus = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    enabled: enabled,
    autofocus: autofocus,
    keyboardType: TextInputType.phone,
    textInputAction: TextInputAction.done,
    autofillHints: const [AutofillHints.telephoneNumberNational],
    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      LengthLimitingTextInputFormatter(10),
    ],
    onSubmitted: onSubmitted,
    style: Theme.of(context).textTheme.titleMedium,
    decoration: InputDecoration(
      labelText: 'Mobile number',
      prefixText: '+91 ',
      hintText: '98765 43210',
      errorText: errorText,
    ),
  );
}

/// One-time-code field (6 digits) with SMS autofill hint.
class DrsOtpField extends StatelessWidget {
  const DrsOtpField({
    required this.controller,
    super.key,
    this.length = 6,
    this.errorText,
    this.enabled = true,
    this.autofocus = true,
    this.onCompleted,
  });

  final TextEditingController controller;
  final int length;
  final String? errorText;
  final bool enabled;
  final bool autofocus;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      enabled: enabled,
      autofocus: autofocus,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      autofillHints: const [AutofillHints.oneTimeCode],
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(length),
      ],
      onChanged: (v) {
        if (v.length == length) onCompleted?.call(v);
      },
      style: theme.textTheme.headlineSmall?.copyWith(letterSpacing: 12),
      decoration: InputDecoration(
        labelText: 'One-time code',
        counterText: '',
        errorText: errorText,
      ),
    );
  }
}
