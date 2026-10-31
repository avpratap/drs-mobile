import '../../drs_api.dart';
import 'api_error.dart';

/// Push-token registration (`register_device_token` /
/// `unregister_device_token_body`). The token is PII: it only ever travels in
/// request bodies (never URLs) and is never logged.
class DeviceTokensClient {
  DeviceTokensClient(this._api);

  final DevicesApi _api;

  /// [platform] is `ios` | `android` | `web`.
  Future<void> register(String token, String platform) async {
    try {
      await _api.registerDeviceToken(
        deviceTokenIn: DeviceTokenIn(token: token, platform: platform),
      );
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }

  Future<void> unregister(String token) async {
    try {
      await _api.unregisterDeviceTokenBody(
        deviceTokenUnregisterIn: DeviceTokenUnregisterIn(token: token),
      );
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }
}
