import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

void main() {
  test('order statuses map backend values', () {
    expect(OrderStatus.parse('created'), OrderStatus.pending);
    expect(OrderStatus.parse('in_transit'), OrderStatus.outForDelivery);
    expect(PaymentStatus.parse('paid'), PaymentStatus.paid);
    expect(PaymentStatus.parse('partially_refunded'), PaymentStatus.refunded);
  });

  test('order cancel/pay rules mirror the backend', () {
    Order o(OrderStatus s, PaymentStatus p) => Order(
      id: 1,
      orderNo: 'DRS-1',
      status: s,
      subtotal: Money.zero,
      total: Money.zero,
      paymentStatus: p,
    );
    expect(o(OrderStatus.pending, PaymentStatus.pending).canCancel, isTrue);
    expect(o(OrderStatus.pending, PaymentStatus.paid).canCancel, isFalse);
    expect(o(OrderStatus.confirmed, PaymentStatus.pending).canCancel, isFalse);
    expect(o(OrderStatus.pending, PaymentStatus.pending).canPay, isTrue);
  });

  test('tracking step index', () {
    OrderTracking t(OrderStatus s, {bool shipped = false}) => OrderTracking(
      orderId: 1,
      orderNo: 'x',
      status: s,
      paymentStatus: PaymentStatus.paid,
      shipments: shipped
          ? const [Shipment(shipmentNo: 'S1', status: 'x')]
          : const [],
    );
    expect(t(OrderStatus.pending).stepIndex, 0);
    expect(t(OrderStatus.delivered).stepIndex, 4);
    expect(t(OrderStatus.cancelled).stepIndex, -1);
    expect(t(OrderStatus.unknown, shipped: true).stepIndex, 3);
  });

  test('quantity helpers', () {
    expect(formatQty(1.5, 'litre'), '1.5 L');
    expect(formatQty(0.75, 'litre'), '750 ml');
    expect(formatQty(0.2, 'kg'), '200 g');
    expect(formatQty(3, 'piece'), '3 × piece');
    expect(packsIn(1.5, 0.5), 3);
    expect(qtyFor(3, 0.2), 0.6); // no 0.6000000000000001
  });

  test('pack availability and MRP strike', () {
    final p = Pack(
      packSize: 1,
      label: '1 L',
      price: Money.fromRupees(64),
      mrp: Money.fromRupees(70),
    );
    expect(p.available, isTrue);
    expect(p.showMrpStrike, isTrue);
    expect(const Pack(packSize: 1, label: 'x').available, isFalse);
  });

  test('address one-liner, pincode rule, redaction', () {
    const a = Address(
      id: 1,
      line1: '12 Gandhi Path',
      landmark: 'Temple',
      city: 'Jaipur',
      state: 'Rajasthan',
      pincode: '302001',
      contactPhone: '+919876543210',
    );
    expect(a.oneLine, '12 Gandhi Path, Near Temple, Jaipur, Rajasthan 302001');
    expect(a.toString(), isNot(contains('Gandhi')));
    expect(a.maskedPhone, '+91 98•••••210');
    expect(IndianStates.isValidPincode('302001'), isTrue);
    expect(IndianStates.isValidPincode('012345'), isFalse);
  });

  test('cart lookup and wallet labels', () {
    final c = Cart(
      id: 1,
      lines: [
        CartLine(
          itemId: 9,
          productId: 2,
          qty: 1,
          unitPrice: Money.fromRupees(64),
          lineTotal: Money.fromRupees(64),
        ),
      ],
      subtotal: Money.fromRupees(64),
    );
    expect(c.lineFor(2)?.itemId, 9);
    expect(c.lineFor(3), isNull);
    final txn = WalletTxn(
      id: 1,
      type: 'order_debit',
      amount: Money.fromRupees(-64),
      balanceAfter: Money.fromRupees(100),
      createdAt: DateTime(2026),
    );
    expect(txn.isCredit, isFalse);
    expect(txn.label, 'Order debit');
  });
}
