import 'dart:async';

/// Bridges the API layer's "refresh failed" signal to the auth controller
/// without a provider dependency cycle.
class SessionEvents {
  final _expired = StreamController<void>.broadcast();

  Stream<void> get expired => _expired.stream;

  void notifyExpired() {
    if (!_expired.isClosed) _expired.add(null);
  }

  Future<void> dispose() => _expired.close();
}
