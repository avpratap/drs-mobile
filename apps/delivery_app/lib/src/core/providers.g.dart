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

String _$envHash() => r'bba14f67b9e043cc3fedea10c254c92cf292f931';

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
