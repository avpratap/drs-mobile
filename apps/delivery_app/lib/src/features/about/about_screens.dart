import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers.dart';
import '../../routes.dart';
import '../common.dart';

/// Version and build details (overridden in tests).
final appInfoProvider = FutureProvider<DrsAppInfo>(
  (ref) =>
      DrsAppInfo.load(appName: 'DRS Delivery', env: ref.watch(envProvider)),
);

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final info = ref.watch(appInfoProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'About'),
      body: switch (info) {
        AsyncValue(:final value?) => DrsAboutView(
          info: value,
          tagline: 'Rider app',
          onPrivacyNotice: () => context.push(Routes.privacyNotice),
        ),
        AsyncValue(:final error?) => DrsEmptyState.error(
          title: "Couldn't read app details",
          message: errorMessage(error),
          onAction: () => ref.invalidate(appInfoProvider),
        ),
        _ => const DrsLoading(),
      },
    );
  }
}

class PrivacyNoticeScreen extends ConsumerWidget {
  const PrivacyNoticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    return DrsPrivacyNoticeScreen(
      sections: riderPrivacySections,
      policyUrl: env.privacyPolicyUrl,
      grievanceEmail: env.grievanceEmail,
    );
  }
}

/// Plain-language notice for delivery staff. Keep in step with the
/// backend's data handling and the published privacy policy.
const riderPrivacySections = [
  DrsPrivacySection('What we collect', [
    'Your mobile number and name, to sign you in.',
    'The deliveries assigned to you and what happened at each stop '
        '(delivered, failed and why, quantities, notes).',
    'Proof-of-delivery photos you take. Take photos of the doorstep or the '
        'goods — not of people.',
    'A notification token for this phone — only if you turn notifications on.',
    'This version of the app does not collect your location.',
  ]),
  DrsPrivacySection('Why we use it', [
    'To plan your route, record deliveries and resolve customer queries.',
    'To pay and manage delivery work.',
    'To send you route updates you have switched on.',
  ]),
  DrsPrivacySection('Customer details you see', [
    'Customer names, phone numbers and addresses are shown only to deliver '
        'today’s orders. Don’t copy, share or keep them.',
    'Today’s route is saved on this phone so you can work offline; it is '
        'wiped when you log out.',
  ]),
  DrsPrivacySection('How long we keep it', [
    'Delivery records and photos are kept as long as needed to settle '
        'orders and as the law requires.',
  ]),
];
