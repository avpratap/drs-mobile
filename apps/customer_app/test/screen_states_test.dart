import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_drs_server.dart';
import 'support/harness.dart';
import 'support/seed.dart';

/// Every screen, three ways the world goes wrong. Each must end in a settled
/// state (no exception, no endless spinner) that tells the user what's up.
final routes = [
  Routes.home,
  Routes.shop,
  Routes.product(2),
  Routes.productReviews(2),
  Routes.writeReview(2),
  Routes.cart,
  Routes.checkout,
  Routes.subscriptions,
  Routes.subscribeBrowse,
  Routes.subscribeProduct(2),
  Routes.account,
  Routes.orders,
  Routes.order(2),
  Routes.wallet,
  Routes.addresses,
  Routes.profile,
  Routes.notificationPrefs,
  Routes.about,
];

Iterable<DrsEmptyState> states() =>
    find.byType(DrsEmptyState).evaluate().map((e) => e.widget as DrsEmptyState);

bool get offlineState => states().any((s) => s.icon == Icons.wifi_off);
bool get errorStateShown =>
    states().any((s) => s.icon == Icons.cloud_off_outlined);
bool get strip => find
    .text("You're offline — saved information is shown where available.")
    .evaluate()
    .isNotEmpty;

Future<void> settled(WidgetTester t, String route) async {
  await goTo(t, route); // pumpAndSettle times out on an endless spinner
  expect(t.takeException(), isNull, reason: route);
  expect(find.byType(DrsLoading), findsNothing, reason: route);
}

void main() {
  testWidgets('offline mid-session: every screen says so (strip or an '
      'offline state), keeps saved data, never a server-error state', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.offline = true;
    // The app learns it's offline from the first request that fails to
    // connect (screens showing already-loaded data make none).
    await settled(t, Routes.orders);
    expect(strip, isTrue);
    for (final r in routes) {
      await settled(t, r);
      // Once known, the strip stays until a request succeeds; screens
      // that had nothing to show use the offline state.
      expect(strip || offlineState, isTrue, reason: r);
      expect(errorStateShown, isFalse, reason: r);
    }
  });

  testWidgets('server down: error states with "Try again", never claims '
      'to be offline', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.failAllWith = 503;
    for (final r in routes) {
      await settled(t, r);
      expect(offlineState, isFalse, reason: r);
      expect(strip, isFalse, reason: r);
    }
    // Spot-check the copy on a screen with nothing cached.
    await settled(t, Routes.wallet);
    expect(find.text("Couldn't load your wallet"), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('new account with nothing yet: empty states, no errors', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: FakeDrsServer());
    await h.start(t);
    for (final r in routes) {
      await settled(t, r);
      expect(errorStateShown || offlineState, isFalse, reason: r);
    }
    for (final (route, title) in [
      (Routes.cart, 'Your cart is empty'),
      (Routes.orders, 'No orders yet'),
      (Routes.addresses, 'No saved addresses'),
      (Routes.productReviews(2), 'No reviews yet'),
    ]) {
      await settled(t, route);
      expect(find.text(title), findsOneWidget, reason: route);
    }
    // A missing order is "not found", without a pointless retry.
    await settled(t, Routes.order(2));
    expect(states().single.icon, Icons.search_off);
    expect(find.text('Try again'), findsNothing);
  });

  testWidgets('the offline strip clears on the next successful request', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: seededServer());
    await h.start(t);
    h.server.offline = true;
    await settled(t, Routes.orders);
    expect(strip, isTrue);

    h.server.offline = false;
    await t.tap(find.text('Retry'));
    await t.pumpAndSettle();
    expect(strip, isFalse);
  });

  testWidgets('a stored session the server has revoked ends on sign-in '
      '(the app opens at once, then confirms in the background)', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: FakeDrsServer(loggedIn: false));
    await h.start(t);
    expect(find.text('Send OTP'), findsOneWidget);
  });
}
