import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../common/async_views.dart';
import '../application/wallet_providers.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(walletSummaryProvider);
    final txns = ref.watch(walletTransactionsProvider);
    void refresh() => ref
      ..invalidate(walletSummaryProvider)
      ..invalidate(walletTransactionsProvider);
    final theme = Theme.of(context);

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Wallet & billing'),
      body: AsyncBody(
        value: summary,
        onRetry: refresh,
        errorTitle: "Couldn't load your wallet",
        builder: (s) => RefreshIndicator.adaptive(
          onRefresh: () async => refresh(),
          child: ListView(
            padding: const EdgeInsets.all(DrsSpacing.md),
            children: [
              Card(
                color: theme.colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(DrsSpacing.lg),
                  child: Semantics(
                    label: 'Wallet balance ${s.balance.format(compact: false)}',
                    excludeSemantics: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Wallet balance',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(height: DrsSpacing.xs),
                        Text(
                          s.balance.format(compact: false),
                          style: theme.textTheme.displaySmall?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                        if (!s.creditOutstanding.isZero) ...[
                          const SizedBox(height: DrsSpacing.xs),
                          Text(
                            'Credit outstanding '
                            '${s.creditOutstanding.format(compact: false)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: DrsSpacing.md),
              Text('Recent transactions', style: theme.textTheme.titleMedium),
              const SizedBox(height: DrsSpacing.xs),
              switch (txns) {
                AsyncValue(:final value?) when value.isEmpty => const Padding(
                  padding: EdgeInsets.all(DrsSpacing.lg),
                  child: Text(
                    'No transactions yet.',
                    textAlign: TextAlign.center,
                  ),
                ),
                AsyncValue(:final value?) => Card(
                  child: Column(
                    children: [for (final t in value) _TxnTile(txn: t)],
                  ),
                ),
                AsyncValue(:final error?) => Text(errorMessage(error)),
                _ => const LinearProgressIndicator(),
              },
            ],
          ),
        ),
      ),
    );
  }
}

class _TxnTile extends StatelessWidget {
  const _TxnTile({required this.txn});

  final WalletTxn txn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = txn.isCredit
        ? DrsColors.of(context).success
        : theme.colorScheme.onSurface;
    final d = txn.createdAt.toLocal();
    return ListTile(
      leading: Icon(
        txn.isCredit ? Icons.south_west : Icons.north_east,
        color: color,
      ),
      title: Text(txn.label),
      subtitle: Text(
        '${d.day}/${d.month}/${d.year} · balance '
        '${txn.balanceAfter.format(compact: false)}',
      ),
      trailing: Text(
        '${txn.isCredit ? '+' : '−'}'
        '${Money.paise(txn.amount.paise.abs()).format(compact: false)}',
        style: theme.textTheme.titleSmall?.copyWith(color: color),
      ),
    );
  }
}
