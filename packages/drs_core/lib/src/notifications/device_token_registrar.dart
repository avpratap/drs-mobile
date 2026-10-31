/// Persisted push preferences for this install.
abstract interface class PushPrefs {
  /// null = never asked, true = opted in, false = opted out.
  Future<bool?> consent();
  Future<void> setConsent(bool? value);

  /// The token currently registered with the backend (needed to unregister).
  Future<String?> registeredToken();
  Future<void> setRegisteredToken(String? token);
}

class InMemoryPushPrefs implements PushPrefs {
  bool? _consent;
  String? _token;

  @override
  Future<bool?> consent() async => _consent;

  @override
  Future<void> setConsent(bool? value) async => _consent = value;

  @override
  Future<String?> registeredToken() async => _token;

  @override
  Future<void> setRegisteredToken(String? token) async => _token = token;
}

enum TokenSyncResult { registered, unregistered, unchanged, skipped, failed }

/// Keeps the backend's device-token registration in line with consent and the
/// session, treating the FCM token as personal data (DPDP):
///
/// * registered only when signed in **and** the user opted in;
/// * re-registered when FCM rotates the token (old one deactivated first);
/// * deactivated on opt-out, and on sign-out **before** the session is
///   revoked (the call needs a valid access token);
/// * consent is cleared on sign-out — it belongs to that person, not the
///   device, so the next user is asked again.
class DeviceTokenRegistrar {
  DeviceTokenRegistrar({
    required this._register,
    required this._unregister,
    required this._prefs,
    required this._platform,
  });

  final Future<void> Function(String token, String platform) _register;
  final Future<void> Function(String token) _unregister;
  final PushPrefs _prefs;
  final String _platform;

  Future<TokenSyncResult> sync({
    required bool signedIn,
    required String? token,
  }) async {
    final consent = await _prefs.consent() ?? false;
    final current = await _prefs.registeredToken();
    final wanted = signedIn && consent ? token : null;
    if (wanted == current) return TokenSyncResult.unchanged;
    // Signed out: the API can't be called; signOut() handled the server side.
    if (!signedIn) return TokenSyncResult.skipped;
    try {
      if (current != null) {
        await _bestEffortUnregister(current);
        await _prefs.setRegisteredToken(null);
      }
      if (wanted == null) return TokenSyncResult.unregistered;
      await _register(wanted, _platform);
      await _prefs.setRegisteredToken(wanted);
      return TokenSyncResult.registered;
    } on Object {
      return TokenSyncResult.failed;
    }
  }

  /// Call while the session is still valid, before revoking it.
  Future<void> signOut() async {
    final current = await _prefs.registeredToken();
    if (current != null) await _bestEffortUnregister(current);
    await _prefs.setRegisteredToken(null);
    await _prefs.setConsent(null);
  }

  Future<void> _bestEffortUnregister(String token) async {
    try {
      await _unregister(token);
    } on Object {
      // The backend also drops tokens FCM reports as invalid.
    }
  }
}
