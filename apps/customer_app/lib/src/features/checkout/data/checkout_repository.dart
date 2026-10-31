import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';

/// Gateway order returned by `create_payment`.
class PaymentIntent {
  const PaymentIntent({
    required this.paymentId,
    required this.gatewayOrderId,
    required this.amount,
    required this.serverKeyId,
  });

  final int paymentId;
  final String gatewayOrderId;
  final Money amount;

  /// Razorpay key id the backend is configured with ("" = dev stub).
  final String serverKeyId;

  /// Fully discounted orders are settled server-side without a gateway.
  bool get isFree => amount.isZero;
}

class CheckoutRepository {
  CheckoutRepository({
    required this._account,
    required this._cart,
    required this._payments,
  });

  final AccountApi _account;
  final CartApi _cart;
  final PaymentsApi _payments;

  Future<List<Address>> addresses() => guard(
    () async => [
      for (final a
          in (await _account.listAddresses()).data ?? const <AddressOut>[])
        if (a.status != 'deleted') a.toDomain(),
    ],
  );

  Future<Address> createAddress(AddressIn input) => guard(
    () async =>
        (await _account.createAddress(addressIn: input)).data!.toDomain(),
  );

  /// Converts the server cart into an order. [idempotencyKey] must be reused
  /// on retry so a lost response can't create a second order.
  Future<Order> placeOrder({
    required Address address,
    required String idempotencyKey,
  }) => guard(
    () async => (await _cart.checkoutCart(
      idempotencyKey: idempotencyKey,
      checkoutIn: CheckoutIn(
        address: address.oneLine,
        state: address.state,
        pincode: address.pincode,
      ),
    )).data!.toDomain(),
  );

  /// Opens (or resumes) the order's gateway payment.
  Future<PaymentIntent> createPayment({
    required int orderId,
    required String idempotencyKey,
  }) => guard(() async {
    final p = (await _payments.createPayment(
      idempotencyKey: idempotencyKey,
      paymentCreate: PaymentCreate(purpose: 'order_payment', orderId: orderId),
    )).data!;
    return PaymentIntent(
      paymentId: p.paymentId,
      gatewayOrderId: p.gatewayOrderId,
      amount: Money.fromRupees(p.amount),
      serverKeyId: p.keyId,
    );
  });

  /// Server-side signature check; idempotent.
  Future<PaymentStatus> verifyPayment({
    required String gatewayOrderId,
    required String gatewayPaymentId,
    required String signature,
  }) => guard(() async {
    final r = (await _payments.verifyPayment(
      paymentVerify: PaymentVerify(
        gatewayOrderId: gatewayOrderId,
        gatewayPaymentId: gatewayPaymentId,
        signature: signature,
      ),
    )).data!;
    return PaymentStatus.parse(r.status);
  });
}
