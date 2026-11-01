// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rider_auth.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Signed-in rider, or null when signed out.

@ProviderFor(RiderAuth)
final riderAuthProvider = RiderAuthProvider._();

/// Signed-in rider, or null when signed out.
final class RiderAuthProvider
    extends $AsyncNotifierProvider<RiderAuth, Account?> {
  /// Signed-in rider, or null when signed out.
  RiderAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'riderAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$riderAuthHash();

  @$internal
  @override
  RiderAuth create() => RiderAuth();
}

String _$riderAuthHash() => r'682f7a10acb74368f68b43e3a5017ce81670a123';

/// Signed-in rider, or null when signed out.

abstract class _$RiderAuth extends $AsyncNotifier<Account?> {
  FutureOr<Account?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Account?>, Account?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Account?>, Account?>,
              AsyncValue<Account?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
