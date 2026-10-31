import 'package:drs_api/drs_api_session.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/rider_auth.dart';
import '../core/providers.dart';

/// Rider login: the shared DRS phone-OTP flow, gated to delivery staff by
/// [RiderAuth].
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.read(riderAuthProvider.notifier);
    return DrsOtpSignIn(
      title: 'Rider login',
      tagline: 'Delivery partner',
      verifyLabel: 'Log in',
      showDevHint: ref.watch(envProvider).allowDevOtpHint,
      onRequestOtp: auth.requestOtp,
      onVerify: auth.verifyOtp,
      errorText: (e) => e is DrsApiError
          ? e.message
          : 'Something went wrong. Please try again.',
    );
  }
}
