import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

import '../../../core/push.dart';
import '../../common/async_views.dart';
import '../application/account_providers.dart';

/// Notification preferences.
///
/// Two layers, both explicit and reversible (DPDP):
/// * **This device** — the M4 push consent. Turning it off unregisters this
///   device's token; nothing is sent here regardless of the categories below.
/// * **Categories** — account-wide switches stored on the server (apply to
///   all the user's devices): service messages via `profile.notify_push`,
///   offers via the `marketing_push` consent-ledger entry.
class NotificationPrefsScreen extends ConsumerWidget {
  const NotificationPrefsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final device = ref.watch(notificationsControllerProvider);
    final profile = ref.watch(profileProvider);
    final consents = ref.watch(consentsProvider);
    final theme = Theme.of(context);

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Notifications'),
      body: ListView(
          padding: const EdgeInsets.all(DrsSpacing.md),
          children: [
            const _Header('This device'),
            const Card(child: NotificationsSettingsTile()),
            const SizedBox(height: DrsSpacing.lg),
            const _Header('What we send'),
            Padding(
              padding: const EdgeInsets.only(bottom: DrsSpacing.sm),
              child: Text(
                device.enabled
                    ? 'These apply to every device you sign in on.'
                    : 'Push is off on this device, so nothing is shown here. '
                          'These choices still apply to your other devices.',
                style: theme.textTheme.bodySmall,
              ),
            ),
            switch ((profile, consents)) {
              (AsyncData(value: final p), AsyncData(value: final c)) =>
                _Categories(profile: p, consents: c),
              (AsyncError(), _) || (_, AsyncError()) => DrsEmptyState.error(
                title: "Couldn't load your preferences",
                onAction: () {
                  ref
                    ..invalidate(profileProvider)
                    ..invalidate(consentsProvider);
                },
              ),
              _ => const Padding(
                padding: EdgeInsets.all(DrsSpacing.lg),
                child: DrsLoading(),
              ),
            },
          ],
        ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: DrsSpacing.sm),
    child: Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    ),
  );
}

class _Categories extends HookConsumerWidget {
  const _Categories({required this.profile, required this.consents});

  final Profile profile;
  final Map<String, String> consents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimistic values while a request is in flight.
    final service = useState<bool?>(null);
    final offers = useState<bool?>(null);
    final serviceOn = service.value ?? profile.notifyPush;
    final offersOn =
        offers.value ?? consents[ConsentPurpose.marketingPush] == 'granted';

    Future<void> run(
      ValueNotifier<bool?> state,
      bool next,
      Future<void> Function() call,
      ProviderOrFamily refresh,
    ) async {
      state.value = next;
      try {
        await call();
        ref.invalidate(refresh);
      } on DrsApiError catch (e) {
        if (context.mounted) showSnack(context, e.message);
        state.value = null;
        return;
      }
      if (context.mounted) state.value = null;
    }

    final repo = ref.read(accountRepositoryProvider);
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            key: const ValueKey('pref-service'),
            secondary: const Icon(Icons.local_shipping_outlined),
            title: const Text('Orders, deliveries & account'),
            subtitle: const Text(
              'Delivery updates, payment reminders and subscription changes',
            ),
            value: serviceOn,
            onChanged: service.value != null
                ? null
                : (v) => run(
                    service,
                    v,
                    () => repo.updateProfile(notifyPush: v),
                    profileProvider,
                  ),
          ),
          const Divider(height: 1),
          SwitchListTile(
            key: const ValueKey('pref-offers'),
            secondary: const Icon(Icons.local_offer_outlined),
            title: const Text('Offers & promotions'),
            subtitle: const Text(
              'New products and deals. Optional — you can change this anytime.',
            ),
            value: offersOn,
            onChanged: offers.value != null
                ? null
                : (v) => run(
                    offers,
                    v,
                    () => repo.setConsent(
                      ConsentPurpose.marketingPush,
                      granted: v,
                    ),
                    consentsProvider,
                  ),
          ),
        ],
      ),
    );
  }
}
