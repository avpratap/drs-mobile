/// Hand-written session layer on top of the generated `drs_api` client:
/// token storage contract, bearer + refresh-on-401 interceptor, a factory
/// that wires it all up, and a PII-safe error type for the UI.
library;

export 'src/session/api_error.dart';
export 'src/session/device_tokens.dart';
export 'src/session/drs_api_factory.dart';
export 'src/session/session_interceptor.dart';
export 'src/session/token_store.dart';
