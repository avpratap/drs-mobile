import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../features/catalogue/data/product_mapper.dart';

/// Generated wire DTOs → drs_core domain models. Money stays server-computed:
/// nothing here re-derives a total.
Money _m(num v) => Money.fromRupees(v);

extension CartOutMapper on CartOut {
  Cart toDomain() => Cart(
    id: id,
    subtotal: _m(subtotal),
    lines: [
      for (final l in items ?? const <CartLineOut>[])
        CartLine(
          itemId: l.id,
          productId: l.productId,
          qty: l.qty.toDouble(),
          unitPrice: _m(l.unitPrice),
          lineTotal: _m(l.lineTotal),
        ),
    ],
  );
}

extension QuoteOutMapper on QuoteOut {
  CartQuote toDomain() => CartQuote(
    subtotal: _m(subtotal),
    discount: _m(discount),
    taxTotal: _m(taxTotal),
    total: _m(total),
    serviceable: serviceable,
    etaDays: etdDays,
    shipping: shippingRate == null ? null : _m(shippingRate!),
  );
}

extension OrderOutMapper on OrderOut {
  Order toDomain() => Order(
    id: id,
    orderNo: orderNo,
    status: OrderStatus.parse(status),
    paymentStatus: PaymentStatus.parse(paymentStatus),
    subtotal: _m(subtotal),
    discount: _m(discount ?? 0),
    taxTotal: _m(taxTotal ?? 0),
    total: _m(total),
    couponCode: couponCode,
    lines: [
      for (final l in items ?? const <OrderItemOut>[])
        OrderLine(
          productId: l.productId,
          qty: l.qty.toDouble(),
          unitPrice: _m(l.unitPrice),
          lineTotal: _m(l.lineTotal),
          gstRate: (l.gstRate ?? 0).toDouble(),
          gstAmount: _m(l.gstAmount ?? 0),
        ),
    ],
  );
}

extension OrderTrackingOutMapper on OrderTrackingOut {
  OrderTracking toDomain() => OrderTracking(
    orderId: orderId,
    orderNo: orderNo,
    status: OrderStatus.parse(status),
    paymentStatus: PaymentStatus.parse(paymentStatus),
    shipments: [
      for (final s in shipments ?? const <ShipmentTrackOut>[])
        Shipment(
          shipmentNo: s.shipmentNo,
          status: s.status,
          courier: s.courier,
          awb: s.awb,
          trackingUrl: s.trackingUrl,
          events: [
            for (final e in s.events ?? const <TrackingEventOut>[])
              TrackingEvent(
                status: e.status,
                location: e.location,
                note: e.note,
                time: e.eventTime,
              ),
          ],
        ),
    ],
  );
}

extension AddressOutMapper on AddressOut {
  Address toDomain() => Address(
    id: id,
    label: label,
    contactName: contactName,
    contactPhone: contactPhone,
    line1: line1,
    line2: line2,
    landmark: landmark,
    city: city,
    state: state,
    pincode: pincode,
    isDefault: isDefault,
  );
}

extension BillingSummaryMapper on BillingSummary {
  WalletSummary toDomain() => WalletSummary(
    balance: _m(walletBalance),
    creditOutstanding: _m(creditOutstanding),
    billingMode: billingMode,
  );
}

extension WalletTxnMapper on WalletTxnLineOut {
  WalletTxn toDomain() => WalletTxn(
    id: id,
    type: txnType,
    amount: _m(amount),
    balanceAfter: _m(balanceAfter),
    createdAt: createdAt,
    refType: refType,
  );
}

SubscriptionItem _item(SubscriptionItemOut i) => SubscriptionItem(
  id: i.id,
  productId: i.productId,
  defaultQty: i.defaultQty.toDouble(),
  frequency: DeliveryFrequency.parse(i.frequency ?? 'daily'),
  intervalDays: i.intervalDays,
  daysOfWeek: SubscriptionItem.parseDaysOfWeek(i.daysOfWeek),
  active: i.active,
);

extension SubscriptionOutMapper on SubscriptionOut {
  Subscription toDomain() => Subscription(
    id: id,
    status: SubscriptionStatus.parse(status),
    startDate: startDate,
    endDate: endDate,
  );
}

extension SubscriptionDetailMapper on SubscriptionDetail {
  Subscription toDomain() => Subscription(
    id: id,
    status: SubscriptionStatus.parse(status),
    startDate: startDate,
    endDate: endDate,
    items: [
      for (final i in items ?? const <SubscriptionItemOut>[])
        if (i.active) _item(i),
    ],
  );
}

extension SubscriptionItemWire on SubscriptionItem {
  SubscriptionItemIn toWire() => SubscriptionItemIn(
    productId: productId,
    defaultQty: defaultQty,
    frequency: frequency.wireName,
    intervalDays: frequency == DeliveryFrequency.alternate
        ? (intervalDays ?? 2)
        : null,
    daysOfWeek: frequency == DeliveryFrequency.weekly ? daysOfWeekCsv : null,
  );
}

extension ProductFullMapper on ProductFullOut {
  ProductDetail toDomain() {
    final product = ProductOut(
      id: id,
      sku: sku,
      name: name,
      status: status,
      description: description,
      uom: uom,
      packSize: packSize,
      isSubscribable: isSubscribable,
      perishable: perishable,
      category: category,
      imageUrl: imageUrl,
      fromPrice: fromPrice,
      avgRating: avgRating,
      ratingCount: ratingCount,
    ).toDomain();
    final sorted = [...?variants]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final packs = sorted.isEmpty
        ? [
            Pack(
              packSize: product.packSize,
              label: product.packLabel,
              price: product.fromPrice,
            ),
          ]
        : [
            for (final v in sorted)
              Pack(
                id: v.id,
                label: v.label,
                packSize: v.packSize.toDouble(),
                // `price` is a legacy field; checkout charges selling_price.
                price: v.sellingPrice == null ? null : _m(v.sellingPrice!),
                mrp: v.mrp == null ? null : _m(v.mrp!),
              ),
          ];
    return ProductDetail(product: product, packs: packs);
  }
}
