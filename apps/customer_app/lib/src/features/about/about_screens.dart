import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers.dart';
import '../../routing/routes.dart';
import '../common/async_views.dart';

/// Version and build details (overridden in tests).
final appInfoProvider = FutureProvider<DrsAppInfo>(
  (ref) => DrsAppInfo.load(appName: 'DRS Dairy', env: ref.watch(envProvider)),
);

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DrsScaffold(
    appBar: const DrsAppBar(title: 'About'),
    body: AsyncBody(
      value: ref.watch(appInfoProvider),
      onRetry: () => ref.invalidate(appInfoProvider),
      builder: (info) => DrsAboutView(
        info: info,
        onPrivacyNotice: () => context.push(Routes.privacyNotice),
      ),
    ),
  );
}

class PrivacyNoticeScreen extends ConsumerWidget {
  const PrivacyNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    return DrsPrivacyNoticeScreen(
      sections: customerPrivacySections,
      policyUrl: env.privacyPolicyUrl,
      grievanceEmail: env.grievanceEmail,
    );
  }
}

/// Plain-language notice for customers. Keep in step with the backend's
/// data handling and the published privacy policy.
const customerPrivacySections = [
  DrsPrivacySection('What we collect', [
    'Your mobile number, to sign you in with a one-time code.',
    'Your name, and optionally a display name and email for receipts.',
    'Delivery addresses you save.',
    'Orders, subscriptions, wallet and payment status. Card and UPI details '
        'are handled by our payment partner, Razorpay — we never see or '
        'store them.',
    'Product reviews you write. Other customers see them without your name.',
    'A notification token for this device — only if you turn notifications on.',
  ]),
  DrsPrivacySection('Why we use it', [
    'To take, deliver and bill your orders and subscriptions.',
    'To keep your account secure.',
    'To send order, delivery and account updates you have switched on.',
    'To send offers — only if you opt in. You can opt out any time under '
        'Notifications in your Account.',
  ]),
  DrsPrivacySection('Who we share it with', [
    'Our delivery staff: your name, address and phone, to deliver to you.',
    'Razorpay, to process payments; Google Firebase, to deliver '
        'notifications you have switched on.',
    'Authorities, only when the law requires it.',
  ]),
  DrsPrivacySection('On this phone and how long we keep it', [
    'Your sign-in is kept in the phone’s secure storage. The app also saves '
        'the product catalogue so it works offline — nothing personal.',
    'We keep your data while your account is active, and invoices for as '
        'long as tax law requires.',
  ]),
];
