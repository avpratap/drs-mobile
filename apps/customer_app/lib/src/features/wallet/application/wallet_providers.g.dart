// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(walletRepository)
final walletRepositoryProvider = WalletRepositoryProvider._();

final class WalletRepositoryProvider
    extends
        $FunctionalProvider<
          WalletRepository,
          WalletRepository,
          WalletRepository
        >
    with $Provider<WalletRepository> {
  WalletRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletRepositoryHash();

  @$internal
  @override
  $ProviderElement<WalletRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  WalletRepository create(Ref ref) {
    return walletRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(WalletRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<WalletRepository>(value),
    );
  }
}

String _$walletRepositoryHash() => r'3a5e8e98c18cd9fa139841085111acced60d84bc';

@ProviderFor(walletSummary)
final walletSummaryProvider = WalletSummaryProvider._();

final class WalletSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<WalletSummary>,
          WalletSummary,
          FutureOr<WalletSummary>
        >
    with $FutureModifier<WalletSummary>, $FutureProvider<WalletSummary> {
  WalletSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletSummaryHash();

  @$internal
  @override
  $FutureProviderElement<WalletSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WalletSummary> create(Ref ref) {
    return walletSummary(ref);
  }
}

String _$walletSummaryHash() => r'8064b3d8d9e687ce11715d5761f2466b39da5b1f';

@ProviderFor(walletTransactions)
final walletTransactionsProvider = WalletTransactionsProvider._();

final class WalletTransactionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WalletTxn>>,
          List<WalletTxn>,
          FutureOr<List<WalletTxn>>
        >
    with $FutureModifier<List<WalletTxn>>, $FutureProvider<List<WalletTxn>> {
  WalletTransactionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'walletTransactionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$walletTransactionsHash();

  @$internal
  @override
  $FutureProviderElement<List<WalletTxn>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WalletTxn>> create(Ref ref) {
    return walletTransactions(ref);
  }
}

String _$walletTransactionsHash() =>
    r'd083a54aa0b80c0fce0b33521ea36fdd46a1f8b0';
