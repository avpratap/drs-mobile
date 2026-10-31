import 'package:drs_core/drs_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Consent + registered token in Keychain / Keystore-backed storage (the
/// token is personal data).
class SecurePushPrefs implements PushPrefs {
  SecurePushPrefs([FlutterSecureStorage? storage])
    : _s = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _s;
  static const _consentKey = 'drs.push.consent';
  static const _tokenKey = 'drs.push.token';

  @override
  Future<bool?> consent() async => switch (await _s.read(key: _consentKey)) {
    'true' => true,
    'false' => false,
    _ => null,
  };

  @override
  Future<void> setConsent(bool? value) => value == null
      ? _s.delete(key: _consentKey)
      : _s.write(key: _consentKey, value: '$value');

  @override
  Future<String?> registeredToken() => _s.read(key: _tokenKey);

  @override
  Future<void> setRegisteredToken(String? token) => token == null
      ? _s.delete(key: _tokenKey)
      : _s.write(key: _tokenKey, value: token);
}
