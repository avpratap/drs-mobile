import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;

import '../features/auth/application/auth_controller.dart';
import '../routing/app_router.dart';
import '../routing/routes.dart';
import 'providers.dart';

/// Where a tapped push opens in the customer app (null = just open the app).
/// Delivery-staff kinds are ignored here.
String? customerPushRoute(PushPayload p) => switch (p.kind) {
  PushKind.orderConfirmed ||
  PushKind.orderOutForDelivery ||
  PushKind.orderDelivered =>
    p.orderId == null ? Routes.orders : Routes.order(p.orderId!),
  PushKind.subscription => Routes.subscriptions,
  PushKind.walletLow => Routes.wallet,
  PushKind.promo =>
    p.productId == null ? Routes.shop : Routes.product(p.productId!),
  _ => null,
};

const customerPushReasons = [
  'Order confirmed, out for delivery and delivered',
  'Subscription reminders and low wallet balance',
  'Occasional offers (you can turn these off)',
];

/// Wires the shared notifications service to this app. Firebase is used only
/// when every `DRS_FIREBASE_*` define is set; otherwise push is a no-op.
List<Override> pushOverrides({PushPlatform? platform, PushPrefs? prefs}) => [
  pushPlatformProvider.overrideWith((ref) {
    if (platform != null) return platform;
    final ios = defaultTargetPlatform == TargetPlatform.iOS;
    final options = drsFirebaseOptions(ref.watch(envProvider), ios: ios);
    return options == null
        ? DisabledPushPlatform(ios ? 'ios' : 'android')
        : FirebasePushPlatform(options);
  }),
  pushPrefsProvider.overrideWithValue(prefs ?? SecurePushPrefs()),
  pushTokenApiProvider.overrideWith((ref) {
    final client = DeviceTokensClient(
      ref.watch(drsApiProvider).getDevicesApi(),
    );
    return PushTokenApi(
      register: client.register,
      unregister: client.unregister,
    );
  }),
  pushRouteResolverProvider.overrideWithValue(customerPushRoute),
  pushSignedInProvider.overrideWith(
    (ref) => ref.watch(authControllerProvider).value is SignedIn,
  ),
];

/// Starts the notifications service and opens tapped notifications once a
/// session exists (a cold-start tap waits for sign-in / session restore).
class PushBridge extends ConsumerStatefulWidget {
  const PushBridge({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<PushBridge> createState() => _PushBridgeState();
}

class _PushBridgeState extends ConsumerState<PushBridge> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(notificationsControllerProvider.notifier).start(),
    );
  }

  void _openPending() {
    final route = ref.read(notificationsControllerProvider).pendingRoute;
    if (route == null || !ref.read(pushSignedInProvider)) return;
    ref.read(notificationsControllerProvider.notifier).consumeRoute();
    if (route.isNotEmpty) ref.read(appRouterProvider).go(route);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(
        notificationsControllerProvider.select((s) => s.pendingRoute),
        (_, _) => _openPending(),
      )
      ..listen(pushSignedInProvider, (_, _) => _openPending());
    return widget.child;
  }
}

/// Opt-in card, shown only until the user decides.
class NotificationsOptInCard extends ConsumerWidget {
  const NotificationsOptInCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(notificationsControllerProvider);
    if (!s.shouldOfferOptIn) return const SizedBox.shrink();
    final c = ref.read(notificationsControllerProvider.notifier);
    return Padding(
      padding: const EdgeInsets.only(bottom: DrsSpacing.md),
      child: DrsNotificationOptIn(
        reasons: customerPushReasons,
        onAllow: c.enable,
        onNotNow: c.disable,
      ),
    );
  }
}

class NotificationsSettingsTile extends ConsumerWidget {
  const NotificationsSettingsTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(notificationsControllerProvider);
    final c = ref.read(notificationsControllerProvider.notifier);
    return DrsNotificationSettingsTile(
      available: s.available,
      consent: s.consent,
      permission: s.permission,
      onChanged: (on) => on ? c.enable() : c.disable(),
    );
  }
}
