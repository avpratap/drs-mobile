import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// iOS needs `GMSServices.provideAPIKey` before the first map; the key comes
/// from the same `--dart-define=DRS_GOOGLE_MAPS_API_KEY` the Dart side reads,
/// so there is a single source of truth. Android reads it from the manifest
/// placeholder filled at build time from the same define.
abstract final class MapsKey {
  static const _channel = MethodChannel('drs/maps');
  static Future<bool>? _done;

  static Future<bool> ensure(String key) => _done ??= _provide(key);

  static Future<bool> _provide(String key) async {
    if (key.isEmpty) return false;
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) return true;
    try {
      return await _channel.invokeMethod<bool>('provideApiKey', key) ?? false;
    } on Object {
      return false;
    }
  }
}
