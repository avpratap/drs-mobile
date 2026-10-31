import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/providers.dart';
import '../../cart/application/cart_providers.dart';
import '../../orders/application/orders_providers.dart';
import '../data/checkout_repository.dart';
import 'payment_gateway.dart';

part 'checkout_controller.g.dart';

@Riverpod(keepAlive: true)
CheckoutRepository checkoutRepository(Ref ref) {
  final api = ref.watch(drsApiProvider);
  return CheckoutRepository(
    account: api.getAccountApi(),
    cart: api.getCartApi(),
    payments: api.getPaymentsApi(),
  );
}

@Riverpod(keepAlive: true)
PaymentGateway paymentGateway(Ref ref) => RazorpayGateway();

@riverpod
Future<List<Address>> addresses(Ref ref) =>
    ref.watch(checkoutRepositoryProvider).addresses();

/// Checkout state machine.
sealed class CheckoutState {
  const CheckoutState();
}

final class CheckoutIdle extends CheckoutState {
  const CheckoutIdle();
}

final class CheckoutBusy extends CheckoutState {
  const CheckoutBusy(this.message);
  final String message;
}

/// Order could not be placed; nothing was charged.
final class CheckoutError extends CheckoutState {
  const CheckoutError(this.message);
  final String message;
}

/// Non-prod backend without Razorpay keys: the UI offers simulated outcomes
/// that go through the backend's dev-stub verification.
final class CheckoutTestPayment extends CheckoutState {
  const CheckoutTestPayment(this.order, this.intent);
  final Order order;
  final PaymentIntent intent;
}

final class CheckoutPaid extends CheckoutState {
  const CheckoutPaid(this.order);
  final Order order;
}

/// Order placed but payment failed / was cancelled. Retrying reuses the order.
final class CheckoutPaymentFailed extends CheckoutState {
  const CheckoutPaymentFailed(this.order, this.message);
  final Order order;
  final String message;
}

/// Outcome unknown yet (UPI app, external wallet, lost connection while
/// verifying). The backend settles it via webhook; the user can re-check.
final class CheckoutPaymentPending extends CheckoutState {
  const CheckoutPaymentPending(this.order, this.message);
  final Order order;
  final String message;
}

enum TestPaymentOutcome { success, failure, pending }

@riverpod
class CheckoutController extends _$CheckoutController {
  static const _uuid = Uuid();

  /// Idempotency keys: one per (address, cart snapshot) for placing the
  /// order, one per order for opening its payment. Retries reuse them, so a
  /// lost response is replayed by the server instead of duplicated.
  final _orderKeys = <String, String>{};
  final _paymentKeys = <int, String>{};

  @override
  CheckoutState build() => const CheckoutIdle();

  CheckoutRepository get _repo => ref.read(checkoutRepositoryProvider);

  Future<void> placeOrderAndPay(Address address, Cart cart) async {
    final fingerprint =
        '${address.id}|${cart.id}|${cart.subtotal.paise}|'
        '${cart.lines.map((l) => '${l.productId}:${l.qty}').join(',')}';
    final key = _orderKeys.putIfAbsent(fingerprint, _uuid.v4);
    state = const CheckoutBusy('Placing your order…');
    final Order order;
    try {
      order = await _repo.placeOrder(address: address, idempotencyKey: key);
    } on DrsApiError catch (e) {
      if (ref.mounted) state = CheckoutError(e.message);
      return;
    }
    // The server converted the cart into this order.
    ref
      ..invalidate(cartControllerProvider)
      ..invalidate(ordersProvider);
    await pay(order);
  }

  /// Opens (or resumes) payment for an existing unpaid [order].
  Future<void> pay(Order order) async {
    state = const CheckoutBusy('Opening secure payment…');
    final PaymentIntent intent;
    try {
      intent = await _repo.createPayment(
        orderId: order.id,
        idempotencyKey: _paymentKeys.putIfAbsent(order.id, _uuid.v4),
      );
    } on DrsApiError catch (e) {
      if (ref.mounted) state = CheckoutPaymentFailed(order, e.message);
      return;
    }
    if (intent.isFree) {
      await _settled(order);
      return;
    }

    final env = ref.read(envProvider);
    // A --dart-define key wins (e.g. rzp_test_… in a test build); otherwise
    // use the publishable key id the backend is configured with.
    final keyId = env.hasRazorpay ? env.razorpayKeyId : intent.serverKeyId;
    if (keyId.isEmpty) {
      state = env.allowDevOtpHint
          ? CheckoutTestPayment(order, intent)
          : CheckoutPaymentFailed(
              order,
              'Online payment is unavailable right now. Your order is saved; '
              'please try again later.',
            );
      return;
    }

    final result = await ref
        .read(paymentGatewayProvider)
        .pay(
          PaymentRequest(
            keyId: keyId,
            gatewayOrderId: intent.gatewayOrderId,
            amount: intent.amount,
            description: 'Order ${order.orderNo}',
          ),
        );
    if (!ref.mounted) return;
    await _handle(order, intent, result);
  }

  /// Non-prod only: simulate a gateway outcome against the backend stub.
  Future<void> completeTestPayment(TestPaymentOutcome outcome) async {
    final s = state;
    if (s is! CheckoutTestPayment || !ref.read(envProvider).allowDevOtpHint) {
      return;
    }
    await _handle(s.order, s.intent, switch (outcome) {
      TestPaymentOutcome.success => GatewaySuccess(
        paymentId: 'pay_dev_${_uuid.v4().substring(0, 8)}',
        orderId: s.intent.gatewayOrderId,
        signature: 'dev',
      ),
      TestPaymentOutcome.failure => const GatewayFailure(
        'Test payment declined.',
      ),
      TestPaymentOutcome.pending => const GatewayPending('Test UPI app'),
    });
  }

  Future<void> _handle(
    Order order,
    PaymentIntent intent,
    GatewayResult r,
  ) async {
    switch (r) {
      case GatewaySuccess():
        state = const CheckoutBusy('Confirming payment…');
        try {
          final status = await _repo.verifyPayment(
            gatewayOrderId: r.orderId.isEmpty
                ? intent.gatewayOrderId
                : r.orderId,
            gatewayPaymentId: r.paymentId,
            signature: r.signature,
          );
          if (!ref.mounted) return;
          if (status == PaymentStatus.paid) {
            await _settled(order);
          } else {
            state = CheckoutPaymentPending(
              order,
              "We're confirming your payment with the bank.",
            );
          }
        } on DrsApiError catch (e) {
          if (!ref.mounted) return;
          // Money may have moved: a connectivity failure is "pending", never
          // "failed" (the backend webhook will settle it).
          state = e.isConnectivity || e.kind == DrsApiErrorKind.server
              ? CheckoutPaymentPending(
                  order,
                  "We couldn't confirm the payment yet. If money was "
                  'debited, the order will update automatically.',
                )
              : CheckoutPaymentFailed(order, e.message);
        }
      case GatewayCancelled():
        state = CheckoutPaymentFailed(
          order,
          'Payment cancelled. Your order is saved — you can pay now or later '
          'from Orders.',
        );
      case GatewayFailure(:final message):
        state = CheckoutPaymentFailed(order, message);
      case GatewayPending(:final walletName):
        state = CheckoutPaymentPending(
          order,
          walletName == null
              ? 'Complete the payment in your payment app.'
              : 'Complete the payment in $walletName.',
        );
    }
  }

  /// Re-reads the order's payment status (pending screen "Check again").
  Future<void> refreshStatus(Order order) async {
    state = const CheckoutBusy('Checking payment status…');
    try {
      final fresh = await ref.read(ordersRepositoryProvider).get(order.id);
      if (!ref.mounted) return;
      state = switch (fresh.paymentStatus) {
        PaymentStatus.paid => CheckoutPaid(fresh),
        PaymentStatus.failed => CheckoutPaymentFailed(
          fresh,
          'The payment failed. You can try again.',
        ),
        _ => CheckoutPaymentPending(fresh, 'Still waiting for confirmation.'),
      };
    } on DrsApiError catch (e) {
      if (ref.mounted) state = CheckoutPaymentPending(order, e.message);
    }
  }

  Future<void> _settled(Order order) async {
    ref.invalidate(ordersProvider);
    Order paid = order;
    try {
      paid = await ref.read(ordersRepositoryProvider).get(order.id);
    } on DrsApiError {
      // Show what we have; the order list refreshes on its own.
    }
    if (ref.mounted) state = CheckoutPaid(paid);
  }

  void reset() => state = const CheckoutIdle();
}
