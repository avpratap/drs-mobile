import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('phone → OTP (masked), dev hint, verify, change number', (
    t,
  ) async {
    String? requested;
    String? verified;
    await t.pumpWidget(
      MaterialApp(
        theme: DrsTheme.light,
        home: DrsOtpSignIn(
          showDevHint: true,
          onRequestOtp: (p) async {
            requested = p;
            return '123456';
          },
          onVerify: (p, otp) async => verified = '$p/$otp',
        ),
      ),
    );
    await t.enterText(
      find.byType(TextField),
      '99999 00003'.replaceAll(' ', ''),
    );
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    expect(requested, '+919999900003');
    expect(find.text('Code sent to +91 99•••••003'), findsOneWidget);
    expect(find.text('Resend in 30s'), findsOneWidget);

    await t.tap(find.text('Use dev code 123456'));
    await t.pump();
    await t.tap(find.text('Verify & continue'));
    await t.pumpAndSettle();
    expect(verified, '+919999900003/123456');

    await t.tap(find.text('Change number'));
    await t.pump();
    expect(find.text('Send OTP'), findsOneWidget);
  });

  testWidgets('invalid numbers never reach the callback; errors are mapped', (
    t,
  ) async {
    var calls = 0;
    await t.pumpWidget(
      MaterialApp(
        theme: DrsTheme.light,
        home: DrsOtpSignIn(
          onRequestOtp: (_) async {
            calls++;
            throw StateError('boom');
          },
          onVerify: (_, _) async {},
          errorText: (e) => 'Mapped: ${e.runtimeType}',
        ),
      ),
    );
    await t.enterText(find.byType(TextField), '1234567890');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pump();
    expect(calls, 0);
    expect(find.textContaining('valid 10-digit'), findsOneWidget);

    await t.enterText(find.byType(TextField), '9876543210');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    expect(calls, 1);
    expect(find.text('Mapped: StateError'), findsOneWidget);
    // Dev hint is off by default (prod-safe).
    expect(find.textContaining('dev code'), findsNothing);
  });
}
