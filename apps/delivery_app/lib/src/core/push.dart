import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart' show Override;

import '../auth/rider_auth.dart';
import '../features/route/route_providers.dart';
import '../router.dart';
import '../routes.dart';
import 'providers.dart';

const _routeKinds = {
  PushKind.routeAssigned,
  PushKind.routeChanged,
  PushKind.cutoffReady,
};

/// Where a tapped push opens in the rider app (null = just open the app).
String? deliveryPushRoute(PushPayload p) =>
    _routeKinds.contains(p.kind) ? Routes.today : null;

const deliveryPushReasons = [
  'A new route is assigned to you',
  "Today's route is ready after the cutoff",
  'Stops on your route change',
];

/// See customer_app/lib/src/core/push.dart — same shared service.
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
  pushRouteResolverProvider.overrideWithValue(deliveryPushRoute),
];

/// Starts the service, opens tapped notifications after sign-in, and
/// refreshes today's route when a route push arrives while the app is open.
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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final c = ref.read(notificationsControllerProvider.notifier);
      await c.setSignedIn(ref.read(riderAuthProvider).value != null);
      await c.start();
    });
  }

  void _openPending() {
    final s = ref.read(notificationsControllerProvider);
    final route = s.pendingRoute;
    if (route == null || !s.signedIn) return;
    ref.read(notificationsControllerProvider.notifier).consumeRoute();
    if (route.isEmpty) return;
    ref.invalidate(routeProvider); // the push is about the route: refetch
    ref.read(routerProvider).go(route);
  }

  @override
  Widget build(BuildContext context) {
    ref
      ..listen(
        notificationsControllerProvider.select((s) => s.pendingRoute),
        (_, _) => _openPending(),
      )
      // Report the session to the shared service (it doesn't watch auth).
      ..listen(
        riderAuthProvider.select((a) => a.value != null),
        (_, signedIn) => ref
            .read(notificationsControllerProvider.notifier)
            .setSignedIn(signedIn),
      )
      ..listen(
        notificationsControllerProvider.select((s) => s.signedIn),
        (_, _) => _openPending(),
      )
      ..listen(
        notificationsControllerProvider.select((s) => s.lastForeground),
        (_, p) {
          if (p != null && _routeKinds.contains(p.kind)) {
            ref.invalidate(routeProvider);
          }
        },
      );
    return widget.child;
  }
}

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
        title: 'Get route alerts',
        reasons: deliveryPushReasons,
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
