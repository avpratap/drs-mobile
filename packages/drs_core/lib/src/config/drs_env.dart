import 'package:meta/meta.dart';

/// Which backend the app talks to.
enum DrsBackend {
  /// A backend on the developer's machine.
  dev,

  /// The deployed backend ([DrsEnv.liveBaseUrl]).
  live,

  /// An explicit `DRS_API_BASE_URL`.
  custom,
}

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
/// | `DRS_ENV`               | `dev` / `staging` / `prod`; defaults to the     |
/// |                         | build flavor (`--flavor dev|prod`), else `dev`  |
/// | `DRS_API`               | named backend: `dev` (local) or `live` (the     |
/// |                         | deployed backend). Default: `live` for the prod |
/// |                         | flavor, `dev` otherwise                         |
/// | `DRS_API_BASE_URL`      | explicit origin; overrides `DRS_API`            |
/// | `DRS_RAZORPAY_KEY_ID`   | Razorpay *publishable* key id                   |
/// | `DRS_FCM_SENDER_ID`     | Firebase Cloud Messaging sender id              |
/// | `DRS_FIREBASE_API_KEY`  | Firebase API key (restricted, per platform)     |
/// | `DRS_FIREBASE_PROJECT_ID` | Firebase project id                           |
/// | `DRS_FIREBASE_APP_ID_ANDROID` / `_IOS` | Firebase app ids per platform    |
/// | `DRS_GOOGLE_MAPS_API_KEY` | Maps SDK key (delivery app, later milestone)  |
@immutable
class DrsEnv {
  const DrsEnv({
    required this.flavor,
    required this.apiBaseUrl,
    this.razorpayKeyId = '',
    this.fcmSenderId = '',
    this.googleMapsApiKey = '',
    this.firebaseApiKey = '',
    this.firebaseProjectId = '',
    this.firebaseAppIdAndroid = '',
    this.firebaseAppIdIos = '',
    this.backend = DrsBackend.custom,
    this.privacyPolicyUrl = '',
    this.grievanceEmail = '',
  });

  /// Reads the values compiled in via `--dart-define`.
  ///
  /// [appFlavor] is the native build flavor (`appFlavor` from
  /// `package:flutter/services.dart`), [ios] picks the local dev host the
  /// simulator can reach.
  factory DrsEnv.fromEnvironment({
    String? appFlavor,
    bool ios = false,
  }) => DrsEnv.resolve(
    env: const String.fromEnvironment('DRS_ENV'),
    api: const String.fromEnvironment('DRS_API'),
    baseUrl: const String.fromEnvironment('DRS_API_BASE_URL'),
    appFlavor: appFlavor,
    ios: ios,
    razorpayKeyId: const String.fromEnvironment('DRS_RAZORPAY_KEY_ID'),
    fcmSenderId: const String.fromEnvironment('DRS_FCM_SENDER_ID'),
    googleMapsApiKey: const String.fromEnvironment('DRS_GOOGLE_MAPS_API_KEY'),
    firebaseApiKey: const String.fromEnvironment('DRS_FIREBASE_API_KEY'),
    firebaseProjectId: const String.fromEnvironment('DRS_FIREBASE_PROJECT_ID'),
    firebaseAppIdAndroid: const String.fromEnvironment(
      'DRS_FIREBASE_APP_ID_ANDROID',
    ),
    firebaseAppIdIos: const String.fromEnvironment('DRS_FIREBASE_APP_ID_IOS'),
    privacyPolicyUrl: const String.fromEnvironment('DRS_PRIVACY_URL'),
    grievanceEmail: const String.fromEnvironment('DRS_GRIEVANCE_EMAIL'),
  );

  /// Pure resolution of the raw defines (testable without `--dart-define`).
  factory DrsEnv.resolve({
    String env = '',
    String api = '',
    String baseUrl = '',
    String? appFlavor,
    bool ios = false,
    String razorpayKeyId = '',
    String fcmSenderId = '',
    String googleMapsApiKey = '',
    String firebaseApiKey = '',
    String firebaseProjectId = '',
    String firebaseAppIdAndroid = '',
    String firebaseAppIdIos = '',
    String privacyPolicyUrl = '',
    String grievanceEmail = '',
  }) {
    final flavor = DrsFlavor.parse(
      env.trim().isNotEmpty ? env : (appFlavor ?? ''),
    );
    final DrsBackend backend;
    final String url;
    if (baseUrl.trim().isNotEmpty) {
      backend = DrsBackend.custom;
      url = baseUrl.trim();
    } else {
      backend = switch (api.trim().toLowerCase()) {
        'live' || 'prod' || 'production' => DrsBackend.live,
        'dev' || 'local' => DrsBackend.dev,
        _ => flavor == DrsFlavor.prod ? DrsBackend.live : DrsBackend.dev,
      };
      url = backend == DrsBackend.live
          ? liveBaseUrl
          : (ios ? defaultIosDevBaseUrl : defaultDevBaseUrl);
    }
    return DrsEnv(
      flavor: flavor,
      apiBaseUrl: url,
      backend: backend,
      razorpayKeyId: razorpayKeyId,
      fcmSenderId: fcmSenderId,
      googleMapsApiKey: googleMapsApiKey,
      firebaseApiKey: firebaseApiKey,
      firebaseProjectId: firebaseProjectId,
      firebaseAppIdAndroid: firebaseAppIdAndroid,
      firebaseAppIdIos: firebaseAppIdIos,
      privacyPolicyUrl: privacyPolicyUrl,
      grievanceEmail: grievanceEmail,
    );
  }

  /// Local backend from the Android emulator (host's localhost).
  static const defaultDevBaseUrl = 'http://10.0.2.2:8000';

  /// Local backend from the iOS simulator.
  static const defaultIosDevBaseUrl = 'http://localhost:8000';

  /// The deployed DRS backend (`DRS_API=live`). Public origin, not a secret.
  static const liveBaseUrl = 'https://drs-backend-zvb1.onrender.com';

  final DrsFlavor flavor;
  final String apiBaseUrl;
  final String razorpayKeyId;
  final String fcmSenderId;
  final String googleMapsApiKey;
  final String firebaseApiKey;
  final String firebaseProjectId;
  final String firebaseAppIdAndroid;
  final String firebaseAppIdIos;

  /// Which backend [apiBaseUrl] points at (shown on the About screen).
  final DrsBackend backend;

  /// Full privacy notice (DPDP) web page; '' = in-app summary only.
  final String privacyPolicyUrl;

  /// Grievance officer contact (DPDP s.8(10)); '' = shown as "in the app".
  final String grievanceEmail;

  bool get isProd => flavor == DrsFlavor.prod;

  /// The backend only returns `dev_otp` outside prod; the UI must never show
  /// a "dev code" hint in a prod build even if one somehow arrives.
  bool get allowDevOtpHint => !isProd;

  bool get hasRazorpay => razorpayKeyId.isNotEmpty;
  bool get hasFcm => fcmSenderId.isNotEmpty;
  bool get hasGoogleMaps => googleMapsApiKey.isNotEmpty;

  /// Firebase app id for the platform, or '' if push isn't configured.
  String firebaseAppId({required bool ios}) =>
      ios ? firebaseAppIdIos : firebaseAppIdAndroid;

  /// Push works only when every Firebase value for the platform is defined.
  /// Otherwise the app runs with notifications disabled (no crash, no init).
  bool hasFirebase({required bool ios}) =>
      firebaseApiKey.isNotEmpty &&
      firebaseProjectId.isNotEmpty &&
      fcmSenderId.isNotEmpty &&
      firebaseAppId(ios: ios).isNotEmpty;

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
      'DrsEnv(flavor: ${flavor.name}, backend: ${backend.name}, '
      'apiBaseUrl: $apiBaseUrl, '
      'razorpay: $hasRazorpay, fcm: $hasFcm, maps: $hasGoogleMaps, '
      'firebase: ${firebaseProjectId.isNotEmpty})';
}
