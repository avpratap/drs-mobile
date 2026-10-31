import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../core/providers.dart';
import 'rider_auth.dart';

/// Two-step phone-OTP login on a single screen.
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneCtl = useTextEditingController();
    final otpCtl = useTextEditingController();
    final phoneText = useValueListenable(phoneCtl).text;
    final otpText = useValueListenable(otpCtl).text;
    final sentTo = useState<String?>(null);
    final devOtp = useState<String?>(null);
    final error = useState<String?>(null);
    final busy = useState(false);
    final env = ref.watch(envProvider);
    final theme = Theme.of(context);
    // Short viewports (landscape phones, split screen): tighten the header so
    // the form stays above the fold.
    final short = MediaQuery.sizeOf(context).height < 500;
    final auth = ref.read(riderAuthProvider.notifier);

    Future<void> run(Future<void> Function() action) async {
      error.value = null;
      busy.value = true;
      try {
        await action();
      } on DrsApiError catch (e) {
        if (context.mounted) error.value = e.message;
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    Future<void> sendOtp() => run(() async {
      final e164 = IndianPhone.normalize(phoneCtl.text);
      if (e164 == null) {
        throw const DrsApiError(
          DrsApiErrorKind.validation,
          'Enter a valid 10-digit mobile number',
        );
      }
      devOtp.value = await auth.requestOtp(e164);
      sentTo.value = e164;
    });

    Future<void> verify() =>
        run(() => auth.verifyOtp(sentTo.value!, otpCtl.text));

    final awaitingOtp = sentTo.value != null;
    return DrsScaffold(
      padded: true,
      body: ListView(
        children: [
          SizedBox(height: short ? DrsSpacing.md : DrsSpacing.xxl),
          DrsLogo(size: short ? 32 : 44, tagline: 'Delivery partner'),
          SizedBox(height: short ? DrsSpacing.md : DrsSpacing.xl),
          Text('Rider login', style: theme.textTheme.headlineMedium),
          const SizedBox(height: DrsSpacing.lg),
          if (!awaitingOtp) ...[
            DrsPhoneField(
              controller: phoneCtl,
              autofocus: true,
              enabled: !busy.value,
              errorText: error.value,
              onSubmitted: (_) => sendOtp(),
            ),
            const SizedBox(height: DrsSpacing.lg),
            DrsButton(
              label: 'Send OTP',
              expand: true,
              isLoading: busy.value,
              onPressed: phoneText.length == 10 ? sendOtp : null,
            ),
          ] else ...[
            Text(
              'Code sent to ${Pii.maskPhone(sentTo.value!)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: DrsSpacing.md),
            DrsOtpField(
              controller: otpCtl,
              enabled: !busy.value,
              errorText: error.value,
              onCompleted: (_) => verify(),
            ),
            if (env.allowDevOtpHint && devOtp.value != null) ...[
              const SizedBox(height: DrsSpacing.xs),
              TextButton(
                onPressed: () => otpCtl.text = devOtp.value!,
                child: Text('Use dev code ${devOtp.value}'),
              ),
            ],
            const SizedBox(height: DrsSpacing.lg),
            DrsButton(
              label: 'Log in',
              expand: true,
              isLoading: busy.value,
              onPressed: otpText.length == 6 ? verify : null,
            ),
            DrsButton(
              label: 'Change number',
              variant: DrsButtonVariant.text,
              onPressed: busy.value
                  ? null
                  : () {
                      sentTo.value = null;
                      otpCtl.clear();
                      error.value = null;
                    },
            ),
          ],
        ],
      ),
    );
  }
}
