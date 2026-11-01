import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

class Call {
  Call(this.method, this.path, this.headers, this.body, this.query);

  final String method;
  final String path;
  final Map<String, dynamic> headers;
  final Object? body;
  final Map<String, dynamic> query;

  String get key => '$method $path';
}

ResponseBody _json(
  int status,
  Object body, {
  Map<String, List<String>> headers = const {},
}) => ResponseBody.fromString(
  jsonEncode(body),
  status,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
    ...headers,
  },
);

/// In-memory model of the delivery backend rules the app depends on:
/// rider-scoped route, every planned line must be reported, POD required,
/// only open (generated/frozen) stops can be closed (409 otherwise), and
/// the Idempotency-Key middleware replaying a stored 2xx.
class FakeDeliveryServer implements HttpClientAdapter {
  FakeDeliveryServer({this.role = 'delivery'});

  String role;
  bool offline = false;

  /// Apply the next deliver/fail, then drop the response (lost connection).
  bool loseNextWriteResponse = false;

  /// Deliver/fail answer with this status (e.g. 503 / 429) without applying.
  int? failWritesWith;

  /// Sent as `Retry-After` with [failWritesWith].
  String? retryAfter;

  final calls = <Call>[];
  final _replay = <String, Object>{};
  int uploads = 0;

  /// Active push tokens → platform.
  final deviceTokens = <String, String>{};
  int writesApplied = 0;

  static Map<String, Object?> _order(
    int id,
    int shop,
    String shopName,
    String status,
    List<(int, double)> items, {
    double? lat,
    double? lng,
    String? contact,
    String? phone,
    double due = 0,
  }) => {
    'id': id,
    'delivery_date': '2026-11-01',
    'shop_id': shop,
    'origin': 'subscription',
    'status': status,
    'subtotal': due,
    'total': due,
    'amount_due': due,
    'items': [
      for (final (pid, q) in items)
        {
          'product_id': pid,
          'qty_planned': q,
          'qty_delivered': status == 'delivered' ? q : 0,
          'unit_price': 64,
          'line_total': 64 * q,
          'status': 'planned',
        },
    ],
    'shop_name': shopName,
    'address': '12 Gandhi Path, C-Scheme, Jaipur',
    'pincode': '302001',
    'lat': lat,
    'lng': lng,
    'contact_name': contact,
    'contact_phone': phone,
  };

  final orders = <Map<String, Object?>>[
    _order(
      11,
      1,
      'Shyam Dairy, Malviya Nagar',
      'generated',
      [(2, 1), (3, 0.4)],
      lat: 26.8530,
      lng: 75.8047,
      contact: 'Asha Devi',
      phone: '+919876543210',
      due: 94,
    ),
    _order(
      12,
      1,
      'Shyam Dairy, Malviya Nagar',
      'frozen',
      [(2, 2)],
      lat: 26.8610,
      lng: 75.8120,
      contact: 'Ravi Kumar',
      phone: '+919812345678',
    ),
    _order(
      13,
      2,
      'Gopal Kirana, Vaishali Nagar',
      'delivered',
      [(2, 1)],
      lat: 26.9110,
      lng: 75.7420,
      contact: 'Meena Sharma',
      phone: '+919900112233',
    ),
  ];

  Map<String, Object?> _get(int id) => orders.firstWhere((o) => o['id'] == id);

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = o.data is String && (o.data as String).isNotEmpty
        ? jsonDecode(o.data as String)
        : o.data;
    final c = Call(o.method, o.path, o.headers, body, o.queryParameters);
    calls.add(c);
    if (offline) {
      throw DioException.connectionError(requestOptions: o, reason: 'offline');
    }
    final isWrite = c.path.endsWith('/deliver') || c.path.endsWith('/fail');
    if (isWrite && failWritesWith != null) {
      return _json(
        failWritesWith!,
        {'detail': 'Service unavailable'},
        headers: {
          if (retryAfter != null) 'retry-after': [retryAfter!],
        },
      );
    }
    final (status, out) = _route(c);
    if (loseNextWriteResponse &&
        (c.path.endsWith('/deliver') || c.path.endsWith('/fail')) &&
        status == 200) {
      loseNextWriteResponse = false;
      throw DioException.connectionError(
        requestOptions: o,
        reason: 'response lost',
      );
    }
    return _json(status, out);
  }

  (int, Object) _route(Call c) {
    final p = c.path;
    final b = c.body is Map
        ? (c.body! as Map).cast<String, Object?>()
        : const <String, Object?>{};
    final idem = c.headers['Idempotency-Key'] as String?;
    if (idem != null && _replay.containsKey('${c.key}|$idem')) {
      return (200, _replay['${c.key}|$idem']!);
    }

    if (p == '/api/v1/auth/otp/request') {
      return (200, {'detail': 'OTP sent', 'dev_otp': '246810'});
    }
    if (p == '/api/v1/auth/otp/verify') {
      return b['otp'] == '246810'
          ? (200, {'access_token': 'a', 'refresh_token': 'r'})
          : (401, {'detail': 'Invalid or expired OTP'});
    }
    if (p == '/api/v1/auth/me') {
      return (
        200,
        {
          'id': 3,
          'phone': '+919999900003',
          'role': role,
          'full_name': 'Raju Rider',
          'status': 'active',
        },
      );
    }
    if (p == '/api/v1/auth/logout') return (200, {'detail': 'logged out'});
    if (p == '/api/v1/account/device-tokens') {
      deviceTokens[b['token']! as String] = b['platform']! as String;
      return (
        200,
        {'token': b['token'], 'platform': b['platform'], 'active': true},
      );
    }
    if (p == '/api/v1/account/device-tokens/unregister') {
      deviceTokens.remove(b['token']);
      return (204, '');
    }
    if (p == '/api/v1/products') {
      return (
        200,
        [
          {
            'id': 2,
            'sku': 'MILK',
            'name': 'Cow Milk',
            'status': 'active',
            'uom': 'litre',
          },
          {
            'id': 3,
            'sku': 'CHAAS',
            'name': 'Masala Buttermilk',
            'status': 'active',
            'uom': 'litre',
          },
        ],
      );
    }
    if (p == '/api/v1/delivery/orders/route') {
      return (
        200,
        [
          for (final (i, o) in orders.indexed) {'sequence': i + 1, 'order': o},
        ],
      );
    }
    if (p == '/api/v1/delivery/uploads') {
      uploads++;
      return (
        200,
        {
          'url': 'media:pod/3/abc$uploads.jpg',
          'preview_url': 'https://cdn.invalid/x',
        },
      );
    }
    final m = RegExp(r'^/api/v1/delivery/orders/(\d+)/(deliver|fail)$')
        .firstMatch(p);
    if (m != null) {
      final id = int.parse(m[1]!);
      if (!orders.any((o) => o['id'] == id)) {
        return (404, {'detail': 'Delivery order not found'});
      }
      final o = _get(id);
      if (o['status'] != 'generated' && o['status'] != 'frozen') {
        return (
          409,
          {
            'detail':
                'Order is ${o['status']}; only generated/frozen orders can be delivered',
          },
        );
      }
      final (int, Object) r;
      if (m[2] == 'fail') {
        o['status'] = 'failed';
        o['failure_reason'] = b['reason'];
        r = (200, o);
      } else {
        final items = (b['items']! as List).cast<Map<String, Object?>>();
        final planned = {
          for (final i in (o['items']! as List).cast<Map<String, Object?>>())
            i['product_id'],
        };
        if (!planned.every((pid) => items.any((i) => i['product_id'] == pid))) {
          return (422, {'detail': 'Delivery must report every planned item'});
        }
        final pod = b['pod'] as Map?;
        final any = items.any((i) => (i['qty_delivered']! as num) > 0);
        if (any &&
            !((pod?['photo_url'] as String?)?.startsWith('media:') ?? false)) {
          return (
            422,
            {'detail': 'Proof of delivery (photo or signature) is required'},
          );
        }
        final all = items.every((i) {
          final pl = (o['items']! as List)
              .cast<Map<String, Object?>>()
              .firstWhere((x) => x['product_id'] == i['product_id']);
          return i['qty_delivered'] == pl['qty_planned'];
        });
        o['status'] = all ? 'delivered' : 'partially_delivered';
        r = (200, o);
      }
      writesApplied++;
      if (idem != null) _replay['${c.key}|$idem'] = r.$2;
      return r;
    }
    return (404, {'detail': 'Not Found'});
  }

  @override
  void close({bool force = false}) {}

  Iterable<Call> callsTo(String key) => calls.where((c) => c.key == key);
}
