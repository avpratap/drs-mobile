import 'package:drs_api/drs_api_session.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/providers.dart';
import '../application/auth_controller.dart';

/// Customer sign-in: the shared DRS phone-OTP flow (same widget as the rider
/// app). On success the router redirect takes over.
class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(authControllerProvider.notifier);
    final theme = Theme.of(context);
    return DrsOtpSignIn(
      showDevHint: ref.watch(envProvider).allowDevOtpHint,
      onRequestOtp: auth.requestOtp,
      onVerify: auth.verifyOtp,
      errorText: (e) => e is DrsApiError
          ? e.message
          : 'Something went wrong. Please try again.',
      footer: Text(
        'By continuing you agree to DRS processing your mobile number to '
        'sign you in and deliver your orders.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
