// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pod_camera.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(podCamera)
final podCameraProvider = PodCameraProvider._();

final class PodCameraProvider
    extends $FunctionalProvider<PodCamera, PodCamera, PodCamera>
    with $Provider<PodCamera> {
  PodCameraProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'podCameraProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$podCameraHash();

  @$internal
  @override
  $ProviderElement<PodCamera> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PodCamera create(Ref ref) {
    return podCamera(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PodCamera value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PodCamera>(value),
    );
  }
}

String _$podCameraHash() => r'2aaa83592958f93d70248aa28f23d0fb46a7d60b';
