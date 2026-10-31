import 'package:customer_app/src/features/checkout/application/payment_gateway.dart';
import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_drs_server.dart';
import 'support/harness.dart';

Future<void> _toReview(WidgetTester t, Harness h) async {
  h.server.seedCart(2, 1);
  await h.start(t);
  await goTo(t, Routes.cart);
  await t.tap(find.text('Checkout · ₹64.00'));
  await t.pumpAndSettle();
}

Future<void> _addAddress(WidgetTester t) async {
  await t.tap(find.text('Add new address'));
  await t.pumpAndSettle();
  await t.enterText(
    find.widgetWithText(TextFormField, 'House / flat, street'),
    '12 Gandhi Path',
  );
  await t.enterText(find.widgetWithText(TextFormField, 'City'), 'Jaipur');
  await t.tap(find.text('State'));
  await t.pumpAndSettle();
  await t.scrollUntilVisible(
    find.text('Rajasthan').hitTestable(),
    200,
    scrollable: find.byType(Scrollable).last, // the open dropdown menu
  );
  await t.tap(find.text('Rajasthan').hitTestable().last);
  await t.pumpAndSettle();
  await t.enterText(find.widgetWithText(TextFormField, 'PIN code'), '302001');
  await t.ensureVisible(find.text('Save address'));
  await t.pumpAndSettle();
  await t.tap(find.text('Save address'));
  await t.pumpAndSettle();
}

void main() {
  testWidgets('address entry → review with GST → place order → dev test '
      'payment success → order detail with tracking', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    await _toReview(t, h);

    // No saved address: add one; it comes back selected.
    expect(find.text('Place order & pay · ₹64.00'), findsOneWidget);
    await _addAddress(t);
    expect(
      find.textContaining('12 Gandhi Path, Jaipur, Rajasthan 302001'),
      findsOneWidget,
    );
    expect(find.text('Estimated delivery in 1 day(s)'), findsOneWidget);

    await t.tap(find.text('Place order & pay · ₹64.00'));
    await t.pumpAndSettle();
    final checkout = h.server.callsTo('POST /api/v1/cart/checkout').single;
    expect(checkout.headers['Idempotency-Key'], isNotEmpty);
    expect(checkout.body, {
      'address': '12 Gandhi Path, Jaipur, Rajasthan 302001',
      'state': 'Rajasthan',
      'pincode': '302001',
    });

    // Backend has no Razorpay key → dev build offers the test gateway.
    expect(find.text('Test payment'), findsOneWidget);
    await t.tap(find.text('Simulate success'));
    await t.pumpAndSettle();
    expect(
      h.server.callsTo('POST /api/v1/payments/verify').single.body,
      containsPair('signature', 'dev'),
    );
    expect(find.text('Order placed'), findsOneWidget);

    await t.tap(find.text('View order'));
    await t.pumpAndSettle();
    expect(find.text('DRS-001'), findsWidgets);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Confirmed'), findsWidgets);
    expect(find.bySemanticsLabel('Confirmed, done'), findsOneWidget);
    // Paid orders can't be cancelled from the app.
    expect(find.text('Cancel order'), findsNothing);
  });

  testWidgets('a lost checkout response is retried with the SAME '
      'idempotency key (no duplicate order)', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness();
    h.server.addresses.add({
      'id': 1,
      'account_id': 1,
      'line1': 'A',
      'city': 'Jaipur',
      'state': 'Rajasthan',
      'pincode': '302001',
      'country': 'IN',
      'is_default': true,
      'status': 'active',
    });
    h.server.failOnceWithNetwork.add('POST /api/v1/cart/checkout');
    await _toReview(t, h);

    await t.tap(find.text('Place order & pay · ₹64.00'));
    await t.pumpAndSettle();
    expect(find.text('You appear to be offline.'), findsOneWidget);
    await t.tap(find.text('Place order & pay · ₹64.00'));
    await t.pumpAndSettle();

    final keys = h.server
        .callsTo('POST /api/v1/cart/checkout')
        .map((c) => c.headers['Idempotency-Key'])
        .toList();
    expect(keys, hasLength(2));
    expect(keys.toSet(), hasLength(1));
    expect(h.server.orders, hasLength(1));
  });

  group('Razorpay gateway (test key via --dart-define)', () {
    const env = DrsEnv(
      flavor: DrsFlavor.staging,
      apiBaseUrl: 'https://staging.example.invalid',
      razorpayKeyId: 'rzp_test_PLACEHOLDER',
    );

    Harness withAddress(GatewayResult r) {
      final h = Harness(
        env: env,
        gateway: FakeGateway(r),
        server: FakeDrsServer()..serverKeyId = 'rzp_test_server',
      );
      h.server.addresses.add({
        'id': 1,
        'account_id': 1,
        'line1': 'A',
        'city': 'Jaipur',
        'state': 'Rajasthan',
        'pincode': '302001',
        'country': 'IN',
        'is_default': true,
        'status': 'active',
      });
      return h;
    }

    testWidgets('success verifies the signature server-side', (t) async {
      setDevice(t, const Size(412, 915));
      final h = withAddress(
        const GatewaySuccess(
          paymentId: 'pay_1',
          orderId: 'order_1',
          signature: 'sig_ok',
        ),
      );
      await _toReview(t, h);
      await t.tap(find.text('Place order & pay · ₹64.00'));
      await t.pumpAndSettle();

      final req = (h.gateway! as FakeGateway).requests.single;
      expect(req.keyId, 'rzp_test_PLACEHOLDER'); // dart-define wins
      expect(req.amount, Money.fromRupees(64));
      expect(req.gatewayOrderId, 'order_1');
      expect(find.text('Order placed'), findsOneWidget);
    });

    testWidgets('cancelled checkout keeps the order and offers retry', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final h = withAddress(const GatewayCancelled());
      await _toReview(t, h);
      await t.tap(find.text('Place order & pay · ₹64.00'));
      await t.pumpAndSettle();
      expect(find.text('Payment not completed'), findsOneWidget);
      expect(find.textContaining('Your order is saved'), findsOneWidget);

      // Retry succeeds on the same order (no second checkout).
      (h.gateway! as FakeGateway).result = const GatewaySuccess(
        paymentId: 'pay_2',
        orderId: 'order_1',
        signature: 'sig_ok',
      );
      await t.tap(find.text('Try payment again'));
      await t.pumpAndSettle();
      expect(find.text('Order placed'), findsOneWidget);
      expect(h.server.callsTo('POST /api/v1/cart/checkout'), hasLength(1));
    });

    testWidgets('external wallet → pending; check status settles it', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final h = withAddress(const GatewayPending('PhonePe'));
      await _toReview(t, h);
      await t.tap(find.text('Place order & pay · ₹64.00'));
      await t.pumpAndSettle();
      expect(find.text('Payment pending'), findsOneWidget);
      expect(find.text('Complete the payment in PhonePe.'), findsOneWidget);

      h.server.orders.first['payment_status'] = 'paid'; // webhook arrived
      await t.tap(find.text('Check status'));
      await t.pumpAndSettle();
      expect(find.text('Order placed'), findsOneWidget);
    });

    testWidgets('lost connection while verifying is pending, never failed', (
      t,
    ) async {
      setDevice(t, const Size(412, 915));
      final h = withAddress(
        const GatewaySuccess(
          paymentId: 'pay_1',
          orderId: 'order_1',
          signature: 'sig_ok',
        ),
      );
      h.server.failOnceWithNetwork.add('POST /api/v1/payments/verify');
      await _toReview(t, h);
      await t.tap(find.text('Place order & pay · ₹64.00'));
      await t.pumpAndSettle();
      expect(find.text('Payment pending'), findsOneWidget);
    });
  });

  testWidgets('prod build without any Razorpay key never shows the test '
      'gateway', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(
      env: const DrsEnv(
        flavor: DrsFlavor.prod,
        apiBaseUrl: 'https://api.example.invalid',
      ),
    );
    h.server.addresses.add({
      'id': 1,
      'account_id': 1,
      'line1': 'A',
      'city': 'Jaipur',
      'state': 'Rajasthan',
      'pincode': '302001',
      'country': 'IN',
      'is_default': true,
      'status': 'active',
    });
    await _toReview(t, h);
    await t.tap(find.text('Place order & pay · ₹64.00'));
    await t.pumpAndSettle();
    expect(find.text('Test payment'), findsNothing);
    expect(find.text('Payment not completed'), findsOneWidget);
  });
}
