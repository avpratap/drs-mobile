import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

extension DeliveryOrderOutMapper on DeliveryOrderOut {
  DeliveryStop toStop(int sequence) => DeliveryStop(
    orderId: id,
    sequence: sequence,
    shopId: shopId,
    status: DeliveryStatus.parse(status),
    deliveryDate: deliveryDate,
    shopName: shopName,
    address: address,
    pincode: pincode,
    lat: lat?.toDouble(),
    lng: lng?.toDouble(),
    contactName: contactName,
    contactPhone: contactPhone,
    failureReason: failureReason,
    amountDue: Money.fromRupees(amountDue),
    total: Money.fromRupees(total),
    lines: [
      for (final i in items ?? const <DeliveryOrderItemOut>[])
        DeliveryLine(
          productId: i.productId,
          qtyPlanned: i.qtyPlanned.toDouble(),
          qtyDelivered: i.qtyDelivered.toDouble(),
          lineTotal: Money.fromRupees(i.lineTotal),
        ),
    ],
  );
}
