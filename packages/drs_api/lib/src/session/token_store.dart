/// Access + refresh JWT pair as persisted on device.
class SessionTokens {
  const SessionTokens({required this.accessToken, required this.refreshToken});

  final String accessToken;
  final String refreshToken;

  // Never print tokens.
  @override
  String toString() => 'SessionTokens(<redacted>)';
}

/// Persistence for [SessionTokens]. Apps implement this with platform secure
/// storage (Keychain / Android Keystore); tests use [InMemoryTokenStore].
abstract interface class TokenStore {
  Future<SessionTokens?> read();
  Future<void> write(SessionTokens tokens);
  Future<void> clear();
}

class InMemoryTokenStore implements TokenStore {
  InMemoryTokenStore([this._tokens]);

  SessionTokens? _tokens;

  @override
  Future<SessionTokens?> read() async => _tokens;

  @override
  Future<void> write(SessionTokens tokens) async => _tokens = tokens;

  @override
  Future<void> clear() async => _tokens = null;
}
