import 'package:drs_api/drs_api_session.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// JWT pair in Keychain (iOS) / Keystore-backed storage (Android). Tokens
/// never touch SharedPreferences, Drift or logs.
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static const _accessKey = 'drs.session.access';
  static const _refreshKey = 'drs.session.refresh';

  @override
  Future<SessionTokens?> read() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access == null || refresh == null) return null;
    return SessionTokens(accessToken: access, refreshToken: refresh);
  }

  @override
  Future<void> write(SessionTokens tokens) async {
    await _storage.write(key: _accessKey, value: tokens.accessToken);
    await _storage.write(key: _refreshKey, value: tokens.refreshToken);
  }

  @override
  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
