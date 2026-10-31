import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:test/test.dart';

/// Minimal scripted HTTP adapter: maps "METHOD path" to a handler.
class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.routes);

  final Map<String, ResponseBody Function(RequestOptions)> routes;
  final calls = <String>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    calls.add('$key ${options.headers['Authorization'] ?? '-'}');
    final h = routes[key];
    if (h == null) return _json(404, {'detail': 'Not Found'});
    return h(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Object body) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  const me = {
    'id': 7,
    'phone': '+919876543210',
    'role': 'customer',
    'status': 'active',
  };

  test('public operations carry no Authorization header', () async {
    final adapter = _FakeAdapter({
      'POST /api/v1/auth/otp/request': (_) =>
          _json(200, {'detail': 'OTP sent', 'dev_otp': '123456'}),
    });
    final api = buildDrsApi(
      baseUrl: 'http://test',
      tokenStore: InMemoryTokenStore(
        const SessionTokens(accessToken: 'a1', refreshToken: 'r1'),
      ),
      httpClientAdapter: adapter,
    );
    final res = await api.getAuthApi().requestOtp(
      oTPRequest: OTPRequest(phone: '+919876543210'),
    );
    expect(res.data!.devOtp, '123456');
    expect(adapter.calls.single, endsWith(' -'));
  });

  test('refreshes once on 401 and retries with the new token', () async {
    final store = InMemoryTokenStore(
      const SessionTokens(accessToken: 'old', refreshToken: 'r1'),
    );
    final adapter = _FakeAdapter({
      'GET /api/v1/auth/me': (o) => o.headers['Authorization'] == 'Bearer new'
          ? _json(200, me)
          : _json(401, {'detail': 'expired'}),
      'POST /api/v1/auth/refresh': (_) =>
          _json(200, {'access_token': 'new', 'refresh_token': 'r2'}),
    });
    final api = buildDrsApi(
      baseUrl: 'http://test',
      tokenStore: store,
      httpClientAdapter: adapter,
    );

    final res = await api.getAuthApi().getMe();

    expect(res.data!.id, 7);
    expect((await store.read())!.refreshToken, 'r2');
    expect(adapter.calls, [
      'GET /api/v1/auth/me Bearer old',
      'POST /api/v1/auth/refresh -',
      'GET /api/v1/auth/me Bearer new',
    ]);
  });

  test('clears tokens and signals expiry when refresh fails', () async {
    final store = InMemoryTokenStore(
      const SessionTokens(accessToken: 'old', refreshToken: 'bad'),
    );
    var expired = false;
    final api = buildDrsApi(
      baseUrl: 'http://test',
      tokenStore: store,
      onSessionExpired: () => expired = true,
      httpClientAdapter: _FakeAdapter({
        'GET /api/v1/auth/me': (_) => _json(401, {'detail': 'expired'}),
        'POST /api/v1/auth/refresh': (_) => _json(401, {'detail': 'revoked'}),
      }),
    );

    await expectLater(api.getAuthApi().getMe(), throwsA(isA<DioException>()));
    expect(expired, isTrue);
    expect(await store.read(), isNull);
  });

  test('DrsApiError surfaces FastAPI detail without request data', () {
    final err = DrsApiError.from(
      DioException(
        requestOptions: RequestOptions(
          path: '/x',
          data: {'phone': '+919876543210'},
        ),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: 429,
          data: {'detail': 'Too many OTP requests'},
        ),
      ),
    );
    expect(err.kind, DrsApiErrorKind.rateLimited);
    expect(err.message, 'Too many OTP requests');
    expect(err.toString(), isNot(contains('9876543210')));
  });
}
