import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

typedef Handler = ResponseBody Function(RequestOptions request);

/// Scripted stand-in for the FastAPI backend. Set [offline] to simulate no
/// network (Dio `connectionError`).
class FakeBackend implements HttpClientAdapter {
  FakeBackend(this.routes);

  final Map<String, Handler> routes;
  final requests = <String>[];
  bool offline = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final key = '${options.method} ${options.path}';
    requests.add(key);
    if (offline) {
      throw DioException.connectionError(
        requestOptions: options,
        reason: 'offline',
      );
    }
    final handler = routes[key];
    return handler == null
        ? json(404, {'detail': 'Not Found'})
        : handler(options);
  }

  @override
  void close({bool force = false}) {}

  static ResponseBody json(int status, Object body) => ResponseBody.fromString(
    jsonEncode(body),
    status,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
}

const sampleProducts = [
  {
    'id': 1,
    'sku': 'GHEE-500',
    'name': 'A2 Desi Ghee',
    'status': 'active',
    'category': 'Ghee',
    'uom': 'kg',
    'pack_size': 0.5,
    'from_price': 749,
  },
  {
    'id': 2,
    'sku': 'MILK-500',
    'name': 'Cow Milk',
    'status': 'active',
    'category': 'Milk',
    'uom': 'litre',
    'pack_size': 0.5,
    'from_price': 32,
  },
  {
    'id': 3,
    'sku': 'CHAAS-200',
    'name': 'Masala Buttermilk',
    'status': 'active',
    'category': 'Buttermilk',
    'uom': 'litre',
    'pack_size': 0.2,
    'from_price': 15,
  },
];
