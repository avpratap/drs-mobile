import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:test/test.dart';

/// Answers each request with the next scripted outcome.
class _Script implements HttpClientAdapter {
  _Script(this.outcomes);
  final List<Object> outcomes; // int status or DioExceptionType

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final next = outcomes.removeAt(0);
    if (next is DioExceptionType) {
      throw DioException(requestOptions: o, type: next);
    }
    return ResponseBody.fromString(
      '{}',
      next as int,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  test(
    'responses and HTTP errors mean online; network failures offline',
    () async {
      final seen = <bool>[];
      final dio = Dio(BaseOptions(baseUrl: 'http://test'))
        ..httpClientAdapter = _Script([
          200,
          DioExceptionType.connectionError,
          DioExceptionType.receiveTimeout,
          503,
          DioExceptionType.cancel,
        ])
        ..interceptors.add(
          ConnectivityInterceptor(({required online}) => seen.add(online)),
        );
      for (var i = 0; i < 5; i++) {
        try {
          await dio.get<void>('/x');
        } on DioException {
          // expected for the failures
        }
      }
      expect(seen, [true, false, false, true]);
    },
  );
}
