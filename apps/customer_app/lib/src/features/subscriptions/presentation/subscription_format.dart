import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';

const weekdayShort = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

String cadenceLabel(SubscriptionItem i) => switch (i.frequency) {
  DeliveryFrequency.daily => 'Every day',
  DeliveryFrequency.alternate => 'Every ${i.intervalDays ?? 2} days',
  DeliveryFrequency.weekly =>
    i.daysOfWeek.isEmpty
        ? 'Weekly'
        : i.daysOfWeek.map((d) => weekdayShort[d - 1]).join(', '),
};

String statusLabel(SubscriptionStatus s) => switch (s) {
  SubscriptionStatus.active => 'Active',
  SubscriptionStatus.paused => 'Paused',
  SubscriptionStatus.cancelled => 'Cancelled',
  SubscriptionStatus.unknown => 'Unknown',
};

DrsTone statusTone(SubscriptionStatus s) => switch (s) {
  SubscriptionStatus.active => DrsTone.positive,
  SubscriptionStatus.paused => DrsTone.warning,
  SubscriptionStatus.cancelled => DrsTone.negative,
  SubscriptionStatus.unknown => DrsTone.neutral,
};

String dayLabel(DateTime d) =>
    '${weekdayShort[d.weekday - 1]} ${d.day}/${d.month}';
