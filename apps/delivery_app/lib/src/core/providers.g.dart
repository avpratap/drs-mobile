// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(env)
final envProvider = EnvProvider._();

final class EnvProvider extends $FunctionalProvider<DrsEnv, DrsEnv, DrsEnv>
    with $Provider<DrsEnv> {
  EnvProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'envProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$envHash();

  @$internal
  @override
  $ProviderElement<DrsEnv> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrsEnv create(Ref ref) {
    return env(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrsEnv value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrsEnv>(value),
    );
  }
}

String _$envHash() => r'733f043f471f513e17dd5a47729bb5a68e8c72c9';

/// Wall clock (pinned in tests: "updated at" / staleness / retry backoff).

@ProviderFor(clock)
final clockProvider = ClockProvider._();

/// Wall clock (pinned in tests: "updated at" / staleness / retry backoff).

final class ClockProvider
    extends
        $FunctionalProvider<
          DateTime Function(),
          DateTime Function(),
          DateTime Function()
        >
    with $Provider<DateTime Function()> {
  /// Wall clock (pinned in tests: "updated at" / staleness / retry backoff).
  ClockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clockProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clockHash();

  @$internal
  @override
  $ProviderElement<DateTime Function()> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DateTime Function() create(Ref ref) {
    return clock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DateTime Function() value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DateTime Function()>(value),
    );
  }
}

String _$clockHash() => r'3f65ad34ac6fcd532de9004042bdf2ed2bd85b13';

@ProviderFor(tokenStore)
final tokenStoreProvider = TokenStoreProvider._();

final class TokenStoreProvider
    extends $FunctionalProvider<TokenStore, TokenStore, TokenStore>
    with $Provider<TokenStore> {
  TokenStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tokenStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tokenStoreHash();

  @$internal
  @override
  $ProviderElement<TokenStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TokenStore create(Ref ref) {
    return tokenStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TokenStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TokenStore>(value),
    );
  }
}

String _$tokenStoreHash() => r'e1af499041ec8e3fd653ab4576cba8185f657d98';

@ProviderFor(sessionEvents)
final sessionEventsProvider = SessionEventsProvider._();

final class SessionEventsProvider
    extends $FunctionalProvider<SessionEvents, SessionEvents, SessionEvents>
    with $Provider<SessionEvents> {
  SessionEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionEventsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionEventsHash();

  @$internal
  @override
  $ProviderElement<SessionEvents> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SessionEvents create(Ref ref) {
    return sessionEvents(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionEvents value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionEvents>(value),
    );
  }
}

String _$sessionEventsHash() => r'e11d40f19d2b43c3e06c460fc54ac3882ba22132';

@ProviderFor(drsApi)
final drsApiProvider = DrsApiProvider._();

final class DrsApiProvider extends $FunctionalProvider<DrsApi, DrsApi, DrsApi>
    with $Provider<DrsApi> {
  DrsApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drsApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drsApiHash();

  @$internal
  @override
  $ProviderElement<DrsApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrsApi create(Ref ref) {
    return drsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrsApi>(value),
    );
  }
}

String _$drsApiHash() => r'56584b908e825e2aa0de0cb7afdd0bde1c3ccca0';

@ProviderFor(deliveryDatabase)
final deliveryDatabaseProvider = DeliveryDatabaseProvider._();

final class DeliveryDatabaseProvider
    extends
        $FunctionalProvider<
          DeliveryDatabase,
          DeliveryDatabase,
          DeliveryDatabase
        >
    with $Provider<DeliveryDatabase> {
  DeliveryDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deliveryDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deliveryDatabaseHash();

  @$internal
  @override
  $ProviderElement<DeliveryDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeliveryDatabase create(Ref ref) {
    return deliveryDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeliveryDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeliveryDatabase>(value),
    );
  }
}

String _$deliveryDatabaseHash() => r'e744b686db294369c6e1d707946d9b179b9f17a2';

@ProviderFor(podFiles)
final podFilesProvider = PodFilesProvider._();

final class PodFilesProvider
    extends $FunctionalProvider<PodFiles, PodFiles, PodFiles>
    with $Provider<PodFiles> {
  PodFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podFilesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podFilesHash();

  @$internal
  @override
  $ProviderElement<PodFiles> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PodFiles create(Ref ref) {
    return podFiles(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodFiles value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodFiles>(value),
    );
  }
}

String _$podFilesHash() => r'1ab0ea9333a154d8e0257e1d13d849ce8b28b3cf';

/// Background sync triggers (connectivity, resume, timer). Off in tests.

@ProviderFor(autoSync)
final autoSyncProvider = AutoSyncProvider._();

/// Background sync triggers (connectivity, resume, timer). Off in tests.

final class AutoSyncProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Background sync triggers (connectivity, resume, timer). Off in tests.
  AutoSyncProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'autoSyncProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$autoSyncHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return autoSync(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$autoSyncHash() => r'f0212f956b59545a8108c2b046506e6ebdb13726';
