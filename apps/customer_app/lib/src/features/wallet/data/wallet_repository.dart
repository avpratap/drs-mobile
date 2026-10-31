import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';

/// Wallet & billing. Not cached on device: balances must be live, and the
/// ledger is financial personal data we don't need to keep locally.
class WalletRepository {
  WalletRepository(this._api);

  final BillingApi _api;

  Future<WalletSummary> summary() =>
      guard(() async => (await _api.myBilling()).data!.toDomain());

  Future<List<WalletTxn>> transactions({int limit = 30}) => guard(
    () async => [
      for (final t
          in (await _api.myWalletTransactions(limit: limit)).data ??
              const <WalletTxnLineOut>[])
        t.toDomain(),
    ],
  );
}
