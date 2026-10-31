import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../core/providers.dart';

part 'todays_deliveries.g.dart';

/// Today's date in India (IST, UTC+5:30) — delivery days are IST days, and
/// the backend defaults to *tomorrow* if no date is passed.
DateTime todayIst([DateTime? nowUtc]) {
  final ist = (nowUtc ?? DateTime.now().toUtc()).add(
    const Duration(hours: 5, minutes: 30),
  );
  return DateTime.utc(ist.year, ist.month, ist.day);
}

/// `list_delivery_orders` for today, scoped server-side to the rider.
@riverpod
Future<List<DeliveryOrderOut>> todaysDeliveries(Ref ref) async {
  try {
    final res = await ref
        .watch(drsApiProvider)
        .getDeliveryApi()
        .listDeliveryOrders(date: todayIst(), limit: 200);
    return res.data ?? const [];
  } on Object catch (e) {
    throw DrsApiError.from(e);
  }
}
