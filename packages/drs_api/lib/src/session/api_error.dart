import 'package:dio/dio.dart';

enum DrsApiErrorKind {
  offline,
  timeout,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimited,
  server,
  unknown,
}

/// UI-facing error. [message] is safe to show and to log: it is built from
/// the status code and the backend's `detail` string — never from request
/// bodies, headers or tokens.
class DrsApiError implements Exception {
  const DrsApiError(this.kind, this.message, {this.statusCode});

  factory DrsApiError.from(Object error) {
    if (error is DrsApiError) return error;
    if (error is! DioException) {
      return const DrsApiError(DrsApiErrorKind.unknown, 'Something went wrong.');
    }
    switch (error.type) {
      case DioExceptionType.connectionError:
        return const DrsApiError(
          DrsApiErrorKind.offline,
          'You appear to be offline.',
        );
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const DrsApiError(
          DrsApiErrorKind.timeout,
          'The server took too long to respond.',
        );
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        break;
    }
    final status = error.response?.statusCode;
    final detail = _detail(error.response?.data);
    return switch (status) {
      401 => DrsApiError(
        DrsApiErrorKind.unauthorized,
        detail ?? 'Please sign in again.',
        statusCode: status,
      ),
      403 => DrsApiError(
        DrsApiErrorKind.forbidden,
        detail ?? 'You do not have access to this.',
        statusCode: status,
      ),
      404 => DrsApiError(
        DrsApiErrorKind.notFound,
        detail ?? 'Not found.',
        statusCode: status,
      ),
      422 => DrsApiError(
        DrsApiErrorKind.validation,
        detail ?? 'Please check the details and try again.',
        statusCode: status,
      ),
      429 => DrsApiError(
        DrsApiErrorKind.rateLimited,
        detail ?? 'Too many attempts. Please wait a moment.',
        statusCode: status,
      ),
      final int s when s >= 500 => DrsApiError(
        DrsApiErrorKind.server,
        'Our server had a problem. Please try again.',
        statusCode: s,
      ),
      _ => DrsApiError(
        DrsApiErrorKind.unknown,
        detail ?? 'Something went wrong.',
        statusCode: status,
      ),
    };
  }

  final DrsApiErrorKind kind;
  final String message;
  final int? statusCode;

  bool get isConnectivity =>
      kind == DrsApiErrorKind.offline || kind == DrsApiErrorKind.timeout;

  /// FastAPI errors are `{"detail": "..."}` or `{"detail": [{"msg": ...}]}`.
  static String? _detail(Object? data) {
    if (data is! Map) return null;
    final d = data['detail'];
    if (d is String && d.isNotEmpty) return d;
    if (d is List && d.isNotEmpty) {
      final first = d.first;
      if (first is Map && first['msg'] is String) return first['msg'] as String;
    }
    return null;
  }

  @override
  String toString() => 'DrsApiError(${kind.name}, $statusCode): $message';
}
