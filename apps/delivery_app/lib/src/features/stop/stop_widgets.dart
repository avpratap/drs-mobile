import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';

import '../route/route_providers.dart';

DrsTone statusTone(DeliveryStatus s) => switch (s) {
  DeliveryStatus.delivered ||
  DeliveryStatus.partiallyDelivered => DrsTone.positive,
  DeliveryStatus.failed => DrsTone.negative,
  DeliveryStatus.outForDelivery => DrsTone.warning,
  _ => DrsTone.neutral,
};

/// Status chip; a local, not-yet-synced action is labelled as such.
class StopStatusChip extends StatelessWidget {
  const StopStatusChip({required this.view, super.key});

  final StopView view;

  @override
  Widget build(BuildContext context) => DrsStatusChip(
    label: view.needsAttention
        ? 'Needs attention'
        : view.hasConflict
        ? '${view.status.label} · changed by office'
        : view.waitingToSync
        ? '${view.status.label} · syncing'
        : view.status.label,
    tone: view.needsAttention || view.hasConflict
        ? DrsTone.negative
        : statusTone(view.status),
  );
}
