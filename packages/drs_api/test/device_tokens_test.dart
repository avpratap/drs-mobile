import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:test/test.dart';

class _Capture implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? _,
    Future<void>? _,
  ) async {
    requests.add(o);
    if (o.path.endsWith('/unregister')) return ResponseBody.fromString('', 204);
    return ResponseBody.fromString(
      jsonEncode({'token': 'x', 'platform': 'android', 'active': true}),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  final token = 'f' * 160;

  test(
    'register / unregister send the token in the body, never the URL',
    () async {
      final http = _Capture();
      final api = buildDrsApi(
        baseUrl: 'http://test',
        tokenStore: InMemoryTokenStore(
          const SessionTokens(accessToken: 'a', refreshToken: 'r'),
        ),
        httpClientAdapter: http,
      );
      final client = DeviceTokensClient(api.getDevicesApi());

      await client.register(token, 'ios');
      await client.unregister(token);

      expect(http.requests.map((r) => '${r.method} ${r.path}'), [
        'POST /api/v1/account/device-tokens',
        'POST /api/v1/account/device-tokens/unregister',
      ]);
      expect(jsonDecode(http.requests[0].data as String), {
        'token': token,
        'platform': 'ios',
      });
      expect(jsonDecode(http.requests[1].data as String), {'token': token});
      for (final r in http.requests) {
        expect(r.uri.toString(), isNot(contains(token)));
        expect(r.headers['Authorization'], 'Bearer a');
      }
    },
  );
}
