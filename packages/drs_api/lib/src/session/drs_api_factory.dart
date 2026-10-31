import 'package:dio/dio.dart';

import '../../drs_api.dart';
import 'session_interceptor.dart';
import 'token_store.dart';

/// Builds a [DrsApi] pointed at [baseUrl] with session handling installed.
///
/// [baseUrl] comes from `--dart-define=DRS_API_BASE_URL` (see `DrsEnv`);
/// nothing environment-specific is compiled into this package.
DrsApi buildDrsApi({
  required String baseUrl,
  required TokenStore tokenStore,
  void Function()? onSessionExpired,
  Duration connectTimeout = const Duration(seconds: 10),
  Duration receiveTimeout = const Duration(seconds: 20),
  HttpClientAdapter? httpClientAdapter,
  List<Interceptor> extraInterceptors = const [],
}) {
  BaseOptions options() => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: connectTimeout,
    receiveTimeout: receiveTimeout,
    headers: const {'Accept': 'application/json'},
  );

  final refreshDio = Dio(options());
  final dio = Dio(options());
  if (httpClientAdapter != null) {
    refreshDio.httpClientAdapter = httpClientAdapter;
    dio.httpClientAdapter = httpClientAdapter;
  }

  return DrsApi(
    dio: dio,
    interceptors: [
      DrsSessionInterceptor(
        tokenStore: tokenStore,
        dio: dio,
        refreshApi: AuthApi(refreshDio),
        onSessionExpired: onSessionExpired,
      ),
      ...extraInterceptors,
    ],
  );
}
