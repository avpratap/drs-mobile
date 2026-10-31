import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../application/auth_controller.dart';
import 'otp_screen.dart';

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = useTextEditingController();
    final value = useValueListenable(phone);
    final error = useState<String?>(null);
    final busy = useState(false);
    final theme = Theme.of(context);

    Future<void> submit() async {
      final e164 = IndianPhone.normalize(phone.text);
      if (e164 == null) {
        error.value = 'Enter a valid 10-digit Indian mobile number';
        return;
      }
      error.value = null;
      busy.value = true;
      try {
        final devOtp = await ref
            .read(authControllerProvider.notifier)
            .requestOtp(e164);
        if (!context.mounted) return;
        // Phone travels as `extra`, never in the URL (keeps PII out of
        // route logs / deep-link analytics).
        await context.push(
          Routes.otp,
          extra: OtpArgs(phone: e164, devOtp: devOtp),
        );
      } on DrsApiError catch (e) {
        error.value = e.message;
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    return DrsScaffold(
      padded: true,
      body: ListView(
        children: [
          const SizedBox(height: DrsSpacing.xxl),
          const DrsLogo(size: 44, tagline: 'Pure dairy, delivered daily'),
          const SizedBox(height: DrsSpacing.xl),
          Text('Sign in', style: theme.textTheme.headlineMedium),
          const SizedBox(height: DrsSpacing.xs),
          Text(
            "We'll send a one-time code to your mobile number.",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DrsSpacing.lg),
          AutofillGroup(
            child: DrsPhoneField(
              controller: phone,
              autofocus: true,
              enabled: !busy.value,
              errorText: error.value,
              onSubmitted: (_) => submit(),
            ),
          ),
          const SizedBox(height: DrsSpacing.lg),
          DrsButton(
            label: 'Send OTP',
            expand: true,
            isLoading: busy.value,
            onPressed: value.text.length == 10 ? submit : null,
          ),
          const SizedBox(height: DrsSpacing.md),
          Text(
            'By continuing you agree to DRS processing your mobile number to '
            'sign you in and deliver your orders.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
