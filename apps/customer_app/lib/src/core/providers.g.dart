// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Compile-time config (`--dart-define`). Override in tests.

@ProviderFor(env)
final envProvider = EnvProvider._();

/// Compile-time config (`--dart-define`). Override in tests.

final class EnvProvider extends $FunctionalProvider<DrsEnv, DrsEnv, DrsEnv>
    with $Provider<DrsEnv> {
  /// Compile-time config (`--dart-define`). Override in tests.
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

/// The generated, typed DRS client with session handling.

@ProviderFor(drsApi)
final drsApiProvider = DrsApiProvider._();

/// The generated, typed DRS client with session handling.

final class DrsApiProvider extends $FunctionalProvider<DrsApi, DrsApi, DrsApi>
    with $Provider<DrsApi> {
  /// The generated, typed DRS client with session handling.
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

String _$drsApiHash() => r'c0bbd12529addd529360fdc76d0748a5557edcad';

/// Local Drift database (catalogue cache — no personal data).

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

/// Local Drift database (catalogue cache — no personal data).

final class AppDatabaseProvider
    extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  /// Local Drift database (catalogue cache — no personal data).
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppDatabase>(value),
    );
  }
}

String _$appDatabaseHash() => r'59cce38d45eeaba199eddd097d8e149d66f9f3e1';
