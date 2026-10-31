import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';

/// Placeholder tab — subscription management lands in the next milestone
/// (API client methods `list_subscriptions`, `create_subscription`, … are
/// already generated in drs_api).
class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) => const DrsScaffold(
    appBar: DrsAppBar(title: 'Subscriptions'),
    body: DrsEmptyState(
      icon: Icons.event_repeat,
      title: 'Daily deliveries, your way',
      message:
          'Schedule milk and more for every morning, alternate days or '
          'chosen weekdays. Coming soon.',
    ),
  );
}
