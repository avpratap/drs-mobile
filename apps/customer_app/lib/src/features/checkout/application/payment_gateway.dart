import 'dart:async';

import 'package:drs_core/drs_core.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

/// What the app asks the gateway to collect.
class PaymentRequest {
  const PaymentRequest({
    required this.keyId,
    required this.gatewayOrderId,
    required this.amount,
    required this.description,
  });

  /// Razorpay *publishable* key id (`rzp_test_…` in test mode). Never a secret.
  final String keyId;
  final String gatewayOrderId;
  final Money amount;
  final String description;
}

sealed class GatewayResult {
  const GatewayResult();
}

final class GatewaySuccess extends GatewayResult {
  const GatewaySuccess({
    required this.paymentId,
    required this.orderId,
    required this.signature,
  });

  final String paymentId;
  final String orderId;
  final String signature;
}

final class GatewayCancelled extends GatewayResult {
  const GatewayCancelled();
}

final class GatewayFailure extends GatewayResult {
  const GatewayFailure(this.message);

  final String message;
}

/// The user picked an external wallet / UPI app: the outcome arrives later
/// (server webhook), so the order stays "payment pending".
final class GatewayPending extends GatewayResult {
  const GatewayPending(this.walletName);

  final String? walletName;
}

abstract interface class PaymentGateway {
  Future<GatewayResult> pay(PaymentRequest request);
}

/// Razorpay Standard Checkout via the official plugin (Android + iOS).
class RazorpayGateway implements PaymentGateway {
  @override
  Future<GatewayResult> pay(PaymentRequest r) {
    final razorpay = Razorpay();
    final result = Completer<GatewayResult>();
    void complete(GatewayResult g) {
      if (!result.isCompleted) result.complete(g);
    }

    razorpay
      ..on(Razorpay.EVENT_PAYMENT_SUCCESS, (Object? res) {
        final s = res! as PaymentSuccessResponse;
        complete(
          GatewaySuccess(
            paymentId: s.paymentId ?? '',
            orderId: s.orderId ?? r.gatewayOrderId,
            signature: s.signature ?? '',
          ),
        );
      })
      ..on(Razorpay.EVENT_PAYMENT_ERROR, (Object? res) {
        final f = res! as PaymentFailureResponse;
        complete(
          f.code == Razorpay.PAYMENT_CANCELLED
              ? const GatewayCancelled()
              : GatewayFailure(
                  f.code == Razorpay.NETWORK_ERROR
                      ? 'Network problem during payment. Please try again.'
                      : 'The payment did not go through. Please try again.',
                ),
        );
      })
      ..on(Razorpay.EVENT_EXTERNAL_WALLET, (Object? res) {
        complete(GatewayPending((res as ExternalWalletResponse?)?.walletName));
      });

    razorpay.open({
      'key': r.keyId,
      'order_id': r.gatewayOrderId,
      'amount': r.amount.paise,
      'currency': 'INR',
      'name': 'DRS',
      'description': r.description,
      'theme': {'color': '#0D4C3C'},
      // No prefill: Razorpay collects contact details itself (data minimisation).
    });
    return result.future.whenComplete(razorpay.clear);
  }
}
