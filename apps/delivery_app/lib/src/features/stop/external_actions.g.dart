// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_actions.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(urlOpener)
final urlOpenerProvider = UrlOpenerProvider._();

final class UrlOpenerProvider
    extends $FunctionalProvider<UrlOpener, UrlOpener, UrlOpener>
    with $Provider<UrlOpener> {
  UrlOpenerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'urlOpenerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$urlOpenerHash();

  @$internal
  @override
  $ProviderElement<UrlOpener> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UrlOpener create(Ref ref) {
    return urlOpener(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UrlOpener value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UrlOpener>(value),
    );
  }
}

String _$urlOpenerHash() => r'd2502ceeca87dbac1517b37cb66a60198f971d01';
