import 'package:meta/meta.dart';

enum SubscriptionStatus {
  active,
  paused,
  cancelled,
  unknown;

  static SubscriptionStatus parse(String raw) => switch (raw.toLowerCase()) {
    'active' => SubscriptionStatus.active,
    'paused' => SubscriptionStatus.paused,
    'cancelled' || 'canceled' => SubscriptionStatus.cancelled,
    _ => SubscriptionStatus.unknown,
  };
}

/// Delivery cadence of a subscription line (backend: daily | alternate | weekly).
enum DeliveryFrequency {
  daily,
  alternate,
  weekly;

  static DeliveryFrequency parse(String raw) => switch (raw.toLowerCase()) {
    'alternate' => DeliveryFrequency.alternate,
    'weekly' => DeliveryFrequency.weekly,
    _ => DeliveryFrequency.daily,
  };

  String get wireName => name;
}

@immutable
class SubscriptionItem {
  const SubscriptionItem({
    required this.productId,
    required this.defaultQty,
    this.id,
    this.frequency = DeliveryFrequency.daily,
    this.intervalDays,
    this.daysOfWeek = const [],
    this.active = true,
  }) : assert(defaultQty >= 0, 'defaultQty must be >= 0');

  final int? id;
  final int productId;
  final double defaultQty;
  final DeliveryFrequency frequency;

  /// For [DeliveryFrequency.alternate]: deliver every N days.
  final int? intervalDays;

  /// For [DeliveryFrequency.weekly]: ISO weekdays (Mon=1 … Sun=7).
  final List<int> daysOfWeek;
  final bool active;

  /// Backend wire format for [daysOfWeek] (`"1,3,5"`), or null when empty.
  String? get daysOfWeekCsv => daysOfWeek.isEmpty ? null : daysOfWeek.join(',');

  static List<int> parseDaysOfWeek(String? csv) => (csv ?? '')
      .split(',')
      .map((s) => int.tryParse(s.trim()))
      .whereType<int>()
      .where((d) => d >= 1 && d <= 7)
      .toList(growable: false);
}

@immutable
class Subscription {
  const Subscription({
    required this.id,
    required this.status,
    required this.startDate,
    this.endDate,
    this.items = const [],
  });

  final int id;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime? endDate;
  final List<SubscriptionItem> items;

  bool get canPause => status == SubscriptionStatus.active;
  bool get canResume => status == SubscriptionStatus.paused;
}
