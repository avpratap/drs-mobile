import 'dart:async';

import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/providers.dart';
import '../application/auth_controller.dart';

/// Navigation payload for [OtpScreen].
class OtpArgs {
  const OtpArgs({required this.phone, this.devOtp});

  /// E.164 phone.
  final String phone;

  /// Only present in non-prod backends.
  final String? devOtp;

  @override
  String toString() => 'OtpArgs(<redacted>)';
}

class OtpScreen extends HookConsumerWidget {
  const OtpScreen({required this.args, super.key});

  final OtpArgs args;

  static const resendCooldown = Duration(seconds: 30);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = useTextEditingController();
    final value = useValueListenable(code);
    final error = useState<String?>(null);
    final busy = useState(false);
    final devOtp = useState(args.devOtp);
    final secondsLeft = useState(resendCooldown.inSeconds);
    final env = ref.watch(envProvider);
    final theme = Theme.of(context);

    useEffect(() {
      final t = Timer.periodic(const Duration(seconds: 1), (_) {
        if (secondsLeft.value > 0) secondsLeft.value--;
      });
      return t.cancel;
    }, const []);

    Future<void> verify() async {
      if (code.text.length != 6 || busy.value) return;
      error.value = null;
      busy.value = true;
      try {
        await ref
            .read(authControllerProvider.notifier)
            .verifyOtp(args.phone, code.text);
        // Router redirect takes over on success.
      } on DrsApiError catch (e) {
        if (context.mounted) error.value = e.message;
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    Future<void> resend() async {
      error.value = null;
      try {
        devOtp.value = await ref
            .read(authControllerProvider.notifier)
            .requestOtp(args.phone);
        secondsLeft.value = resendCooldown.inSeconds;
      } on DrsApiError catch (e) {
        error.value = e.message;
      }
    }

    final showDevHint = env.allowDevOtpHint && devOtp.value != null;

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Verify'),
      padded: true,
      body: ListView(
        children: [
          const SizedBox(height: DrsSpacing.lg),
          Text('Enter the code', style: theme.textTheme.headlineMedium),
          const SizedBox(height: DrsSpacing.xs),
          Text(
            'Sent to ${Pii.maskPhone(args.phone)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DrsSpacing.lg),
          DrsOtpField(
            controller: code,
            enabled: !busy.value,
            errorText: error.value,
            onCompleted: (_) => verify(),
          ),
          if (showDevHint) ...[
            const SizedBox(height: DrsSpacing.sm),
            _DevOtpHint(
              code: devOtp.value!,
              onUse: () {
                code.text = devOtp.value!;
                unawaited(verify());
              },
            ),
          ],
          const SizedBox(height: DrsSpacing.lg),
          DrsButton(
            label: 'Verify & continue',
            expand: true,
            isLoading: busy.value,
            onPressed: value.text.length == 6 ? verify : null,
          ),
          const SizedBox(height: DrsSpacing.xs),
          Center(
            child: TextButton(
              onPressed: secondsLeft.value == 0 && !busy.value ? resend : null,
              child: Text(
                secondsLeft.value == 0
                    ? 'Resend code'
                    : 'Resend in ${secondsLeft.value}s',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DevOtpHint extends StatelessWidget {
  const _DevOtpHint({required this.code, required this.onUse});

  final String code;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.tertiaryContainer,
      borderRadius: BorderRadius.circular(DrsRadius.md),
      child: ListTile(
        leading: const Icon(Icons.developer_mode),
        title: Text('Dev code: $code'),
        subtitle: const Text('Shown only on non-production builds'),
        trailing: TextButton(onPressed: onUse, child: const Text('Use')),
      ),
    );
  }
}
