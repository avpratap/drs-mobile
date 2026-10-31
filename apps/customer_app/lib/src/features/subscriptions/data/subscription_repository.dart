import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/local/app_database.dart';
import '../../../data/mappers.dart';

/// Standing orders (`/api/v1/subscriptions`): one subscription per delivery
/// shop holding item templates; single-day changes are overrides.
class SubscriptionRepository {
  SubscriptionRepository({required this._api, required this._db});

  final SubscriptionsApi _api;
  final AppDatabase _db;

  static const cacheKey = 'subscriptions';

  /// Detailed subscriptions (with items), cached for offline viewing.
  Future<Cached<List<Subscription>>> list() => readThrough(
    db: _db,
    key: cacheKey,
    fetch: () async {
      final subs =
          (await _api.listSubscriptions()).data ?? const <SubscriptionOut>[];
      return [
        for (final s in subs)
          (await _api.getSubscription(subId: s.id)).data!.toJson(),
      ];
    },
    decode: (json) => [
      for (final s in json)
        SubscriptionDetail.fromJson(s! as Map<String, dynamic>).toDomain(),
    ],
  );

  Future<Subscription> get(int id) => guard(
    () async => (await _api.getSubscription(subId: id)).data!.toDomain(),
  );

  /// Creates the retail home-delivery subscription (or returns / reactivates
  /// the existing one — the backend keeps one per shop).
  Future<Subscription> ensure(Address? deliverTo) => guard(
    () async => (await _api.createSubscription(
      subscriptionCreate: SubscriptionCreate(
        homeName: deliverTo?.title,
        homeAddress: deliverTo?.oneLine,
        homeState: deliverTo?.state,
        homePincode: deliverTo?.pincode,
      ),
    )).data!.toDomain(),
  );

  /// Replaces the item templates (upsert by product; missing ones dropped).
  Future<Subscription> setItems(int subId, List<SubscriptionItem> items) =>
      guard(
        () async => (await _api.setSubscriptionItems(
          subId: subId,
          subscriptionItemIn: [for (final i in items) i.toWire()],
        )).data!.toDomain(),
      );

  /// Skips [date] for each product (override qty 0). Dates are sent as UTC
  /// midnight, which the backend parses as a plain date.
  Future<void> skipDay(int subId, Iterable<int> productIds, DateTime date) =>
      guard(() async {
        final day = DateTime.utc(date.year, date.month, date.day);
        for (final pid in productIds) {
          await _api.setOverride(
            subId: subId,
            overrideIn: OverrideIn(
              productId: pid,
              forDate: day,
              overrideQty: 0,
            ),
          );
        }
      });

  Future<Subscription> pause(int id) => guard(
    () async => (await _api.pauseSubscription(subId: id)).data!.toDomain(),
  );

  Future<Subscription> resume(int id) => guard(
    () async => (await _api.resumeSubscription(subId: id)).data!.toDomain(),
  );

  Future<Subscription> cancel(int id) => guard(
    () async => (await _api.cancelSubscription(subId: id)).data!.toDomain(),
  );

  /// Effective quantities for [date] (template merged with overrides).
  Future<Map<int, double>> plan(int subId, DateTime date) => guard(() async {
    final p = (await _api.getSubscriptionPlan(
      subId: subId,
      date: DateTime.utc(date.year, date.month, date.day),
    )).data!;
    return {for (final l in p.lines) l.productId: l.qty.toDouble()};
  });
}
