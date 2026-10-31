import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pod_camera.g.dart';

/// Captures a proof-of-delivery photo; returns a temp file path or null if
/// the rider cancelled. Overridden in tests.
abstract interface class PodCamera {
  Future<String?> capture();
}

class ImagePickerCamera implements PodCamera {
  final _picker = ImagePicker();

  @override
  Future<String?> capture() async {
    try {
      final shot = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        // Small enough to upload on a weak connection; still legible.
        maxWidth: 1600,
        imageQuality: 70,
        requestFullMetadata: false,
      );
      return shot?.path;
    } on PlatformException catch (e) {
      // No camera (e.g. iOS simulator): fall back to the gallery.
      if (e.code != 'camera_access_denied') {
        final pick = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1600,
          imageQuality: 70,
          requestFullMetadata: false,
        );
        return pick?.path;
      }
      rethrow;
    }
  }
}

@Riverpod(keepAlive: true)
PodCamera podCamera(Ref ref) => ImagePickerCamera();
