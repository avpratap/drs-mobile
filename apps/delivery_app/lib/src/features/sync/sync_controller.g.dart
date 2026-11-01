// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// How queued photos are read for upload (overridden in tests).

@ProviderFor(podPhotoReader)
final podPhotoReaderProvider = PodPhotoReaderProvider._();

/// How queued photos are read for upload (overridden in tests).

final class PodPhotoReaderProvider
    extends
        $FunctionalProvider<
          Future<MultipartFile> Function(String path)?,
          Future<MultipartFile> Function(String path)?,
          Future<MultipartFile> Function(String path)?
        >
    with $Provider<Future<MultipartFile> Function(String path)?> {
  /// How queued photos are read for upload (overridden in tests).
  PodPhotoReaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podPhotoReaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podPhotoReaderHash();

  @$internal
  @override
  $ProviderElement<Future<MultipartFile> Function(String path)?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Future<MultipartFile> Function(String path)? create(Ref ref) {
    return podPhotoReader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(
    Future<MultipartFile> Function(String path)? value,
  ) {
    return $ProviderOverride(
      origin: this,
      providerOverride:
          $SyncValueProvider<Future<MultipartFile> Function(String path)?>(
            value,
          ),
    );
  }
}

String _$podPhotoReaderHash() => r'd31434112610db8d53a3417156ff57165b314c68';

@ProviderFor(syncEngine)
final syncEngineProvider = SyncEngineProvider._();

final class SyncEngineProvider
    extends $FunctionalProvider<SyncEngine, SyncEngine, SyncEngine>
    with $Provider<SyncEngine> {
  SyncEngineProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncEngineProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncEngineHash();

  @$internal
  @override
  $ProviderElement<SyncEngine> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncEngine create(Ref ref) {
    return syncEngine(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncEngine value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncEngine>(value),
    );
  }
}

String _$syncEngineHash() => r'07413331fa37c15a0735de35b03055e5882cd22f';

/// Records rider actions locally (instant, works offline) and syncs them.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Records rider actions locally (instant, works offline) and syncs them.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncStatus> {
  /// Records rider actions locally (instant, works offline) and syncs them.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncStatus>(value),
    );
  }
}

String _$syncControllerHash() => r'4431850650a82fe51d3c57f2ff79e632eefde4fe';

/// Records rider actions locally (instant, works offline) and syncs them.

abstract class _$SyncController extends $Notifier<SyncStatus> {
  SyncStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SyncStatus, SyncStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncStatus, SyncStatus>,
              SyncStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
