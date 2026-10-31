import 'dart:async';

import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

import '../theme/drs_spacing.dart';
import 'drs_button.dart';
import 'drs_inputs.dart';
import 'drs_logo.dart';
import 'drs_scaffold.dart';

/// Shared phone-OTP sign-in used by DRS apps: Indian mobile entry (validated
/// like the backend), OTP entry with resend cooldown and an optional
/// non-prod "dev code" shortcut. The phone is masked on screen and never
/// leaves this widget except through the callbacks.
class DrsOtpSignIn extends StatefulWidget {
  const DrsOtpSignIn({
    required this.onRequestOtp,
    required this.onVerify,
    super.key,
    this.title = 'Sign in',
    this.tagline = 'Pure dairy, delivered daily',
    this.verifyLabel = 'Verify & continue',
    this.showDevHint = false,
    this.errorText = _defaultError,
    this.resendCooldown = const Duration(seconds: 30),
    this.footer,
  });

  /// Sends the OTP to an E.164 number; returns a dev code when the backend
  /// provides one (non-prod), else null. Throw to show an error.
  final Future<String?> Function(String e164Phone) onRequestOtp;

  /// Verifies the code. Throw to show an error; on success the host app
  /// navigates away (e.g. via a router redirect).
  final Future<void> Function(String e164Phone, String otp) onVerify;

  final String title;
  final String tagline;
  final String verifyLabel;

  /// Only true on non-prod builds.
  final bool showDevHint;

  /// Maps a thrown error to user-facing text (PII-safe).
  final String Function(Object error) errorText;
  final Duration resendCooldown;
  final Widget? footer;

  static String _defaultError(Object _) =>
      'Something went wrong. Please try again.';

  @override
  State<DrsOtpSignIn> createState() => _DrsOtpSignInState();
}

class _DrsOtpSignInState extends State<DrsOtpSignIn> {
  final _phone = TextEditingController();
  final _otp = TextEditingController();
  String? _sentTo;
  String? _devOtp;
  String? _error;
  bool _busy = false;
  int _secondsLeft = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _phone.addListener(_rebuild);
    _otp.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _timer?.cancel();
    _phone.dispose();
    _otp.dispose();
    super.dispose();
  }

  void _startCooldown() {
    _timer?.cancel();
    _secondsLeft = widget.resendCooldown.inSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return t.cancel();
      setState(() => _secondsLeft = (_secondsLeft - 1).clamp(0, 1 << 30));
      if (_secondsLeft == 0) t.cancel();
    });
  }

  Future<void> _run(Future<void> Function() action) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await action();
    } on Object catch (e) {
      if (mounted) setState(() => _error = widget.errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _send() async {
    final e164 = IndianPhone.normalize(_phone.text);
    if (e164 == null) {
      setState(() => _error = 'Enter a valid 10-digit Indian mobile number');
      return;
    }
    await _run(() async {
      final dev = await widget.onRequestOtp(e164);
      if (!mounted) return;
      setState(() {
        _devOtp = dev;
        _sentTo = e164;
        _otp.clear();
      });
      _startCooldown();
    });
  }

  Future<void> _verify() async {
    if (_otp.text.length != 6 || _busy) return;
    await _run(() => widget.onVerify(_sentTo!, _otp.text));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Landscape phones / split screen: keep the form above the fold.
    final short = MediaQuery.sizeOf(context).height < 500;
    final awaitingOtp = _sentTo != null;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return DrsScaffold(
      padded: true,
      body: ListView(
        children: [
          SizedBox(height: short ? DrsSpacing.md : DrsSpacing.xxl),
          DrsLogo(size: short ? 32 : 44, tagline: widget.tagline),
          SizedBox(height: short ? DrsSpacing.md : DrsSpacing.xl),
          Text(widget.title, style: theme.textTheme.headlineMedium),
          const SizedBox(height: DrsSpacing.xs),
          Text(
            awaitingOtp
                ? 'Code sent to ${Pii.maskPhone(_sentTo!)}'
                : "We'll send a one-time code to your mobile number.",
            style: muted,
          ),
          const SizedBox(height: DrsSpacing.lg),
          if (!awaitingOtp) ...[
            AutofillGroup(
              child: DrsPhoneField(
                controller: _phone,
                autofocus: true,
                enabled: !_busy,
                errorText: _error,
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(height: DrsSpacing.lg),
            DrsButton(
              label: 'Send OTP',
              expand: true,
              isLoading: _busy,
              onPressed: _phone.text.length == 10 ? _send : null,
            ),
          ] else ...[
            DrsOtpField(
              controller: _otp,
              enabled: !_busy,
              errorText: _error,
              onCompleted: (_) => _verify(),
            ),
            if (widget.showDevHint && _devOtp != null) ...[
              const SizedBox(height: DrsSpacing.xs),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  icon: const Icon(Icons.developer_mode),
                  onPressed: _busy ? null : () => _otp.text = _devOtp!,
                  label: Text('Use dev code $_devOtp'),
                ),
              ),
            ],
            const SizedBox(height: DrsSpacing.lg),
            DrsButton(
              label: widget.verifyLabel,
              expand: true,
              isLoading: _busy,
              onPressed: _otp.text.length == 6 ? _verify : null,
            ),
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _busy
                      ? null
                      : () => setState(() {
                          _sentTo = null;
                          _error = null;
                        }),
                  child: const Text('Change number'),
                ),
                TextButton(
                  onPressed: _secondsLeft == 0 && !_busy ? _send : null,
                  child: Text(
                    _secondsLeft == 0
                        ? 'Resend code'
                        : 'Resend in ${_secondsLeft}s',
                  ),
                ),
              ],
            ),
          ],
          if (widget.footer != null) ...[
            const SizedBox(height: DrsSpacing.md),
            widget.footer!,
          ],
        ],
      ),
    );
  }
}
