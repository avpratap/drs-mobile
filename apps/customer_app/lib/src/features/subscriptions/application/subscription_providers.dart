import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../../../data/api_guard.dart';
import '../data/subscription_repository.dart';

part 'subscription_providers.g.dart';

@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) =>
    SubscriptionRepository(
      api: ref.watch(drsApiProvider).getSubscriptionsApi(),
      db: ref.watch(appDatabaseProvider),
    );

@riverpod
Future<Cached<List<Subscription>>> subscriptions(Ref ref) =>
    ref.watch(subscriptionRepositoryProvider).list();

/// Earliest date a standing order can still be changed for: tomorrow (IST),
/// or the day after once the 23:00 IST cutoff has passed. The server enforces
/// this too; the client only avoids offering dates it would reject.
DateTime firstEditableDate([DateTime? nowUtc]) {
  final ist = (nowUtc ?? DateTime.now().toUtc()).add(
    const Duration(hours: 5, minutes: 30),
  );
  final today = DateTime.utc(ist.year, ist.month, ist.day);
  return today.add(Duration(days: ist.hour >= cutoffHourIst ? 2 : 1));
}

/// Backend `CUTOFF_HOUR` (IST).
const cutoffHourIst = 23;

DateTime tomorrowIst([DateTime? nowUtc]) {
  final ist = (nowUtc ?? DateTime.now().toUtc()).add(
    const Duration(hours: 5, minutes: 30),
  );
  return DateTime.utc(ist.year, ist.month, ist.day + 1);
}

/// Effective quantities for tomorrow's (IST) delivery.
@riverpod
Future<Map<int, double>> nextDeliveryPlan(Ref ref, int subId) =>
    ref.watch(subscriptionRepositoryProvider).plan(subId, tomorrowIst());

/// Mutations on the standing order. Each one re-reads the latest template
/// from the server before replacing items, so edits made elsewhere (web app)
/// aren't overwritten with a stale copy. Kept alive: callers only `read` it,
/// and an auto-disposed notifier would be torn down mid-request.
@Riverpod(keepAlive: true)
class SubscriptionActions extends _$SubscriptionActions {
  @override
  void build() {}

  SubscriptionRepository get _repo => ref.read(subscriptionRepositoryProvider);

  void _refresh() => ref.invalidate(subscriptionsProvider);

  /// The subscription new items go to: the first non-cancelled one.
  Future<Subscription?> current() async {
    final subs = (await ref.read(subscriptionsProvider.future)).value;
    return subs
            .where((s) => s.status != SubscriptionStatus.cancelled)
            .firstOrNull ??
        subs.firstOrNull;
  }

  /// Adds (or replaces) the line for [item.productId]. Creates the home
  /// subscription first when there is none ([deliverTo] required then).
  Future<void> upsertItem(SubscriptionItem item, {Address? deliverTo}) async {
    var sub = await current();
    if (sub == null || sub.status == SubscriptionStatus.cancelled) {
      // create_subscription creates or reactivates the home subscription.
      sub = await _repo.ensure(deliverTo);
    }
    final latest = await _repo.get(sub.id);
    await _repo.setItems(sub.id, [
      ...latest.items.where((i) => i.productId != item.productId),
      item,
    ]);
    _refresh();
  }

  Future<void> removeItem(Subscription sub, int productId) async {
    final latest = await _repo.get(sub.id);
    await _repo.setItems(sub.id, [
      ...latest.items.where((i) => i.productId != productId),
    ]);
    _refresh();
  }

  Future<void> skipDay(Subscription sub, DateTime date) async {
    await _repo.skipDay(sub.id, sub.items.map((i) => i.productId), date);
    ref.invalidate(nextDeliveryPlanProvider(sub.id));
  }

  Future<void> pause(Subscription sub) async {
    await _repo.pause(sub.id);
    _refresh();
  }

  Future<void> resume(Subscription sub) async {
    await _repo.resume(sub.id);
    _refresh();
  }

  Future<void> cancel(Subscription sub) async {
    await _repo.cancel(sub.id);
    _refresh();
  }
}
