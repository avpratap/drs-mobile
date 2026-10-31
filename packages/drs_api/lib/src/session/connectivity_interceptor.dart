import 'package:dio/dio.dart';

/// Reports whether the backend is reachable, from real traffic: any response
/// (even an HTTP error) means online; a connection failure or timeout means
/// offline. No polling and no extra requests.
class ConnectivityInterceptor extends Interceptor {
  ConnectivityInterceptor(this.report);

  final void Function({required bool online}) report;

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    report(online: true);
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        report(online: false);
      case DioExceptionType.badResponse:
        report(online: true);
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        break;
    }
    handler.next(err);
  }
}
