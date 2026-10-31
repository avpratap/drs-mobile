import 'package:drs_api/drs_api_session.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../auth/rider_auth.dart';
import 'todays_deliveries.dart';

/// Scaffold for the rider's day. Stop details, proof-of-delivery and maps
/// arrive in later milestones.
class TodaysDeliveriesScreen extends ConsumerWidget {
  const TodaysDeliveriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveries = ref.watch(todaysDeliveriesProvider);
    Future<void> refresh() async {
      ref.invalidate(todaysDeliveriesProvider);
      try {
        await ref.read(todaysDeliveriesProvider.future);
      } on Object {
        // Shown by the error state.
      }
    }

    return DrsScaffold(
      appBar: DrsAppBar(
        title: "Today's deliveries",
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDrsConfirmDialog(
                context,
                title: 'Log out?',
                message: 'You will need a new OTP to log in again.',
                confirmLabel: 'Log out',
                destructive: true,
              );
              if (confirmed) {
                await ref.read(riderAuthProvider.notifier).signOut();
              }
            },
          ),
        ],
      ),
      body: switch (deliveries) {
        AsyncValue(:final value?) => RefreshIndicator.adaptive(
          onRefresh: refresh,
          child: value.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: DrsSpacing.xxl),
                    DrsEmptyState(
                      icon: Icons.local_shipping_outlined,
                      title: 'No deliveries yet',
                      message:
                          "Your route for today will appear here once it's "
                          'assigned. Pull down to refresh.',
                    ),
                  ],
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(DrsSpacing.md),
                  itemCount: value.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: DrsSpacing.xs),
                  itemBuilder: (context, i) {
                    final o = value[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(child: Text('${i + 1}')),
                        title: Text(o.shopName ?? 'Stop #${o.id}'),
                        subtitle: Text(o.status),
                      ),
                    );
                  },
                ),
        ),
        AsyncValue(:final error?) => DrsEmptyState.error(
          title: "Couldn't load deliveries",
          message: error is DrsApiError ? error.message : null,
          onAction: refresh,
        ),
        _ => const DrsLoading(message: "Loading today's route…"),
      },
    );
  }
}
