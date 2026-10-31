import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

DeliveryStop _s(int id, int seq, int shop, String status) => DeliveryStop(
  orderId: id,
  sequence: seq,
  shopId: shop,
  shopName: 'Shop $shop',
  status: DeliveryStatus.parse(status),
  deliveryDate: DateTime.utc(2026, 11, 1),
  contactPhone: '+919876543210',
);

void main() {
  test('backend statuses map to rider states', () {
    expect(DeliveryStatus.parse('generated'), DeliveryStatus.pending);
    expect(DeliveryStatus.parse('frozen'), DeliveryStatus.outForDelivery);
    expect(DeliveryStatus.parse('partially_delivered').isDone, isTrue);
    expect(DeliveryStatus.parse('failed').isOpen, isFalse);
    expect(FailReason.addressWrong.wire, 'address_wrong');
  });

  test('groups stops by shop in route order', () {
    final groups = ShopGroup.group([
      _s(3, 3, 20, 'frozen'),
      _s(1, 1, 10, 'delivered'),
      _s(2, 2, 10, 'generated'),
    ]);
    expect(groups.map((g) => g.shopId), [10, 20]);
    expect(groups.first.stops.map((s) => s.orderId), [1, 2]);
    expect(groups.first.doneCount, 1);
  });

  test('summary and redaction', () {
    final stops = [
      _s(1, 1, 10, 'delivered'),
      _s(2, 2, 10, 'failed'),
      _s(3, 3, 10, 'frozen'),
    ];
    final sum = RouteSummary.of(stops);
    expect((sum.total, sum.done, sum.failed, sum.remaining), (3, 1, 1, 1));
    expect(stops.first.toString(), isNot(contains('9876543210')));
    expect(stops.first.maskedPhone, '+91 98•••••210');
  });
}
