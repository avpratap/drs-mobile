import 'package:drs_core/drs_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/providers.dart';
import '../data/wallet_repository.dart';

part 'wallet_providers.g.dart';

@Riverpod(keepAlive: true)
WalletRepository walletRepository(Ref ref) =>
    WalletRepository(ref.watch(drsApiProvider).getBillingApi());

@riverpod
Future<WalletSummary> walletSummary(Ref ref) =>
    ref.watch(walletRepositoryProvider).summary();

@riverpod
Future<List<WalletTxn>> walletTransactions(Ref ref) =>
    ref.watch(walletRepositoryProvider).transactions();
