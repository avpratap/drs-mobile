import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';

DrsTone orderTone(OrderStatus s) => switch (s) {
  OrderStatus.delivered => DrsTone.positive,
  OrderStatus.cancelled || OrderStatus.failed => DrsTone.negative,
  _ => DrsTone.neutral,
};

DrsTone paymentTone(PaymentStatus s) => switch (s) {
  PaymentStatus.paid => DrsTone.positive,
  PaymentStatus.failed => DrsTone.negative,
  PaymentStatus.pending => DrsTone.warning,
  _ => DrsTone.neutral,
};
