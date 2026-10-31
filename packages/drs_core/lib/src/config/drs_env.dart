import 'package:meta/meta.dart';

/// Deployment flavour, from `--dart-define=DRS_ENV=dev|staging|prod`.
enum DrsFlavor {
  dev,
  staging,
  prod;

  static DrsFlavor parse(String raw) => switch (raw.trim().toLowerCase()) {
    'prod' || 'production' => DrsFlavor.prod,
    'staging' || 'stage' => DrsFlavor.staging,
    _ => DrsFlavor.dev,
  };
}

/// Compile-time configuration, injected with `--dart-define` /
/// `--dart-define-from-file`. **Nothing secret is ever hard-coded here**: every
/// key defaults to an empty string and the app degrades gracefully (e.g. the
/// payment button is hidden) when a key is absent.
///
/// | define                  | purpose                                         |
/// |-------------------------|-------------------------------------------------|
/// | `DRS_ENV`               | `dev` (default) / `staging` / `prod`            |
/// | `DRS_API_BASE_URL`      | FastAPI origin, e.g. `https://api.example.com`  |
/// | `DRS_RAZORPAY_KEY_ID`   | Razorpay *publishable* key id                   |
/// | `DRS_FCM_SENDER_ID`     | Firebase Cloud Messaging sender id              |
/// | `DRS_GOOGLE_MAPS_API_KEY` | Maps SDK key (delivery app, later milestone)  |
@immutable
class DrsEnv {
  const DrsEnv({
    required this.flavor,
    required this.apiBaseUrl,
    this.razorpayKeyId = '',
    this.fcmSenderId = '',
    this.googleMapsApiKey = '',
  });

  /// Reads the values compiled in via `--dart-define`.
  factory DrsEnv.fromEnvironment() {
    const flavor = String.fromEnvironment('DRS_ENV', defaultValue: 'dev');
    const baseUrl = String.fromEnvironment('DRS_API_BASE_URL');
    final parsed = DrsFlavor.parse(flavor);
    return DrsEnv(
      flavor: parsed,
      // Android emulator reaches the host's localhost via 10.0.2.2.
      apiBaseUrl: baseUrl.isNotEmpty ? baseUrl : defaultDevBaseUrl,
      razorpayKeyId: const String.fromEnvironment('DRS_RAZORPAY_KEY_ID'),
      fcmSenderId: const String.fromEnvironment('DRS_FCM_SENDER_ID'),
      googleMapsApiKey: const String.fromEnvironment('DRS_GOOGLE_MAPS_API_KEY'),
    );
  }

  static const defaultDevBaseUrl = 'http://10.0.2.2:8000';

  final DrsFlavor flavor;
  final String apiBaseUrl;
  final String razorpayKeyId;
  final String fcmSenderId;
  final String googleMapsApiKey;

  bool get isProd => flavor == DrsFlavor.prod;

  /// The backend only returns `dev_otp` outside prod; the UI must never show
  /// a "dev code" hint in a prod build even if one somehow arrives.
  bool get allowDevOtpHint => !isProd;

  bool get hasRazorpay => razorpayKeyId.isNotEmpty;
  bool get hasFcm => fcmSenderId.isNotEmpty;
  bool get hasGoogleMaps => googleMapsApiKey.isNotEmpty;

  /// Returns human-readable problems with this config (empty == OK).
  /// Prod builds must talk TLS to a real host.
  List<String> validate() {
    final problems = <String>[];
    final uri = Uri.tryParse(apiBaseUrl);
    if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
      problems.add('DRS_API_BASE_URL is not a valid absolute URL');
    } else if (isProd && uri.scheme != 'https') {
      problems.add('DRS_API_BASE_URL must use https in prod');
    }
    return problems;
  }

  @override
  String toString() =>
      // Never print key material — only whether it is configured.
      'DrsEnv(flavor: ${flavor.name}, apiBaseUrl: $apiBaseUrl, '
      'razorpay: $hasRazorpay, fcm: $hasFcm, maps: $hasGoogleMaps)';
}
