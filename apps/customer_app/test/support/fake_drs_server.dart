import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'fake_backend.dart';

/// A recorded request.
class Call {
  Call(this.method, this.path, this.headers, this.body, this.query);

  final String method;
  final String path;
  final Map<String, dynamic> headers;
  final Object? body;
  final Map<String, dynamic> query;

  String get key => '$method $path';

  @override
  String toString() => key;
}

/// In-memory stand-in for the DRS FastAPI backend, implementing the money and
/// state rules the app relies on (server-side cart re-pricing, idempotent
/// checkout, dev-stub payments, subscription templates + overrides).
class FakeDrsServer implements HttpClientAdapter {
  FakeDrsServer({this.loggedIn = true});

  bool loggedIn;
  bool offline = false;

  /// Paths (e.g. `POST /api/v1/cart/checkout`) that fail with a connection
  /// error ONCE, to exercise idempotent retries.
  final failOnceWithNetwork = <String>{};

  final calls = <Call>[];

  // --- catalogue ---------------------------------------------------------
  static final products = <Map<String, Object?>>[
    {
      'id': 1,
      'sku': 'GHEE-500',
      'name': 'A2 Desi Ghee',
      'status': 'active',
      'category': 'Ghee',
      'uom': 'kg',
      'pack_size': 0.5,
      'from_price': 749,
      'is_subscribable': false,
    },
    {
      'id': 2,
      'sku': 'MILK',
      'name': 'Cow Milk',
      'status': 'active',
      'category': 'Milk',
      'uom': 'litre',
      'pack_size': 0.5,
      'from_price': 32,
      'is_subscribable': true,
    },
    {
      'id': 3,
      'sku': 'CHAAS',
      'name': 'Masala Buttermilk',
      'status': 'active',
      'category': 'Buttermilk',
      'uom': 'litre',
      'pack_size': 0.2,
      'from_price': 15,
      'is_subscribable': true,
    },
  ];

  /// GST-inclusive RETAIL unit price per uom, and GST rate.
  static const unitPrice = {1: 1498.0, 2: 64.0, 3: 75.0};
  static const gstRate = {1: 12.0, 2: 0.0, 3: 5.0};

  static final variants = <int, List<Map<String, Object?>>>{
    2: [_v(21, 2, '500 ml', 0.5, 32, null, 0), _v(22, 2, '1 L', 1, 64, 70, 1)],
    1: [_v(11, 1, '500 g', 0.5, 749, 799, 0)],
  };

  static Map<String, Object?> _v(
    int id,
    int pid,
    String label,
    double pack,
    double sell,
    double? mrp,
    int sort,
  ) => {
    'id': id,
    'product_id': pid,
    'sku': 'V$id',
    'label': label,
    'pack_size': pack,
    'price': sell,
    'mrp': mrp,
    'status': 'active',
    'sort_order': sort,
    'selling_price': sell,
    'price_available': true,
    'show_mrp_strike': mrp != null && mrp > sell,
  };

  // --- state -------------------------------------------------------------
  final cart = <int, double>{}; // productId -> qty
  final _itemIds = <int, int>{};
  int _nextItemId = 100;
  int cartId = 1;

  final addresses = <Map<String, Object?>>[];
  final orders = <Map<String, Object?>>[];
  final payments = <String, Map<String, Object?>>{};
  final _idem = <String, Object?>{};

  /// Razorpay key the "backend" is configured with ("" = dev stub).
  String serverKeyId = '';

  Map<String, Object?>? subscription;
  final overrides = <String>[]; // "pid@yyyy-mm-dd:qty"

  double walletBalance = 250;

  /// Active push tokens → platform.
  final deviceTokens = <String, String>{};

  /// Puts [qty] of [productId] in the cart (test setup).
  void seedCart(int productId, double qty) {
    cart[productId] = qty;
    _itemIds.putIfAbsent(productId, () => _nextItemId++);
  }

  double _r2(double v) => (v * 100).round() / 100;

  Map<String, Object?> _cartJson() {
    var subtotal = 0.0;
    final items = <Map<String, Object?>>[];
    for (final e in cart.entries) {
      final unit = unitPrice[e.key]!;
      final total = _r2(unit * e.value);
      subtotal += total;
      items.add({
        'id': _itemIds[e.key],
        'product_id': e.key,
        'qty': e.value,
        'unit_price': unit,
        'line_total': total,
      });
    }
    return {
      'id': cartId,
      'status': 'active',
      'items': items,
      'subtotal': _r2(subtotal),
    };
  }

  Map<String, Object?> _quote(String? pincode) {
    final c = _cartJson();
    var tax = 0.0;
    final lines = <Map<String, Object?>>[];
    for (final l in (c['items']! as List).cast<Map<String, Object?>>()) {
      final rate = gstRate[l['product_id']]!;
      final charged = l['line_total']! as double;
      final g = _r2(charged - charged / (1 + rate / 100));
      tax += g;
      lines.add({...l, 'gst_rate': rate, 'gst_amount': g});
    }
    final total = c['subtotal']! as double;
    return {
      'items': lines,
      'subtotal': total,
      'discount': 0,
      'tax_total': _r2(tax),
      'total': total,
      'total_incl_tax': total,
      if (pincode != null) ...{
        'serviceable': pincode != '999999',
        'etd_days': 1,
        'shipping_rate': 0,
      },
    };
  }

  Map<String, Object?> _order(int id) =>
      orders.firstWhere((o) => o['id'] == id);

  Map<String, Object?> _subDetail() => {
    ...subscription!,
    'items': subscription!['items'],
  };

  // --- HTTP --------------------------------------------------------------
  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final body = o.data is String && (o.data as String).isNotEmpty
        ? jsonDecode(o.data as String)
        : o.data;
    final call = Call(o.method, o.path, o.headers, body, o.queryParameters);
    calls.add(call);
    if (offline || failOnceWithNetwork.remove(call.key)) {
      throw DioException.connectionError(requestOptions: o, reason: 'offline');
    }
    final r = _route(call);
    return FakeBackend.json(r.$1, r.$2);
  }

  (int, Object) _route(Call c) {
    final p = c.path;
    final m = c.method;
    final b = c.body is Map
        ? (c.body! as Map).cast<String, Object?>()
        : const <String, Object?>{};
    final idem = c.headers['Idempotency-Key'] as String?;

    // Idempotent replays (the backend middleware does the same).
    if (idem != null && _idem.containsKey('$m $p $idem')) {
      return (200, _idem['$m $p $idem']!);
    }
    (int, Object) remember((int, Object) r) {
      if (idem != null && r.$1 == 200) _idem['$m $p $idem'] = r.$2;
      return r;
    }

    RegExpMatch? match(String pattern) => RegExp('^$pattern\$').firstMatch(p);

    // auth
    if (p == '/api/v1/auth/otp/request') {
      return (200, {'detail': 'OTP sent', 'dev_otp': '123456'});
    }
    if (p == '/api/v1/auth/otp/verify') {
      return b['otp'] == '123456'
          ? (200, {'access_token': 'a', 'refresh_token': 'r'})
          : (401, {'detail': 'Invalid or expired OTP'});
    }
    if (p == '/api/v1/auth/logout') return (200, {'detail': 'logged out'});
    if (p == '/api/v1/auth/me') {
      return loggedIn
          ? (
              200,
              {
                'id': 7,
                'phone': '+919876543210',
                'role': 'customer',
                'full_name': 'Asha Devi',
                'status': 'active',
              },
            )
          : (401, {'detail': 'Not authenticated'});
    }
    // push device tokens
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
    // catalogue
    if (m == 'GET' && p == '/api/v1/products') return (200, products);
    if (match(r'/api/v1/products/(\d+)/full') case final mm?) {
      final id = int.parse(mm[1]!);
      final prod = products.firstWhere((x) => x['id'] == id);
      return (200, {...prod, 'variants': variants[id] ?? const []});
    }
    // cart
    if (p == '/api/v1/cart' && m == 'GET') return (200, _cartJson());
    if (p == '/api/v1/cart/items' && m == 'POST') {
      final pid = b['product_id']! as int;
      final qty = (b['qty']! as num).toDouble();
      cart[pid] = _r3((cart[pid] ?? 0) + qty);
      _itemIds.putIfAbsent(pid, () => _nextItemId++);
      return (200, _cartJson());
    }
    if (match(r'/api/v1/cart/items/(\d+)') case final mm?) {
      final itemId = int.parse(mm[1]!);
      final pid = _itemIds.entries.firstWhere((e) => e.value == itemId).key;
      if (m == 'DELETE') {
        cart.remove(pid);
        _itemIds.remove(pid);
      } else {
        cart[pid] = _r3((b['qty']! as num).toDouble());
      }
      return (200, _cartJson());
    }
    if (p == '/api/v1/cart/quote') {
      return (200, _quote(b['pincode'] as String?));
    }
    if (p == '/api/v1/cart/checkout') {
      if (idem == null) {
        return (422, {'detail': 'Idempotency-Key header required'});
      }
      if (cart.isEmpty) return (422, {'detail': 'Cart is empty'});
      final q = _quote(b['pincode'] as String?);
      final id = orders.length + 1;
      final order = {
        'id': id,
        'order_no': 'DRS-00$id',
        'shop_id': 1,
        'order_type': 'd2c',
        'status': 'created',
        'payment_status': 'pending',
        'subtotal': q['subtotal'],
        'discount': 0,
        'total': q['total'],
        'tax_total': q['tax_total'],
        'total_incl_tax': q['total'],
        'items': [
          for (final l in (q['items']! as List).cast<Map<String, Object?>>())
            {...l, 'price_incl_tax': l['unit_price']},
        ],
      };
      orders.insert(0, order);
      cart.clear();
      _itemIds.clear();
      cartId++;
      return remember((200, order));
    }
    // payments
    if (p == '/api/v1/payments/create') {
      if (idem == null) {
        return (422, {'detail': 'Idempotency-Key header required'});
      }
      final order = _order(b['order_id']! as int);
      if (order['payment_status'] == 'paid') {
        return (409, {'detail': 'Order already paid'});
      }
      final gid = 'order_${serverKeyId.isEmpty ? 'dev_' : ''}${order['id']}';
      payments[gid] = {'order_id': order['id'], 'status': 'initiated'};
      return remember((
        200,
        {
          'payment_id': payments.length,
          'gateway_order_id': gid,
          'amount': order['total'],
          'key_id': serverKeyId,
        },
      ));
    }
    if (p == '/api/v1/payments/verify') {
      final pay = payments[b['gateway_order_id']];
      if (pay == null) return (404, {'detail': 'Payment not found'});
      final ok = serverKeyId.isEmpty
          ? b['signature'] == 'dev'
          : b['signature'] == 'sig_ok';
      if (!ok) return (400, {'detail': 'Signature verification failed'});
      pay['status'] = 'success';
      final order = _order(pay['order_id']! as int)
        ..['payment_status'] = 'paid'
        ..['status'] = 'confirmed';
      return (
        200,
        {
          'detail': 'payment successful',
          'payment_id': 1,
          'status': 'success',
          'order': order['id'],
        },
      );
    }
    // orders
    if (p == '/api/v1/orders' && m == 'GET') return (200, orders);
    if (match(r'/api/v1/orders/(\d+)/tracking') case final mm?) {
      final o = _order(int.parse(mm[1]!));
      return (
        200,
        {
          'order_id': o['id'],
          'order_no': o['order_no'],
          'status': o['status'],
          'payment_status': o['payment_status'],
          'shipments': const <Object>[],
        },
      );
    }
    if (match(r'/api/v1/orders/(\d+)/cancel') case final mm?) {
      final o = _order(int.parse(mm[1]!));
      if (o['payment_status'] == 'paid') {
        return (
          409,
          {
            'detail': 'Order is already paid; contact support for a refund instead of cancelling',
          },
        );
      }
      o['status'] = 'cancelled';
      return (200, o);
    }
    if (match(r'/api/v1/orders/(\d+)') case final mm?) {
      return (200, _order(int.parse(mm[1]!)));
    }
    // addresses
    if (p == '/api/v1/addresses' && m == 'GET') return (200, addresses);
    if (p == '/api/v1/addresses' && m == 'POST') {
      final a = {
        ...b,
        'id': addresses.length + 1,
        'account_id': 1,
        'status': 'active',
        'country': 'IN',
        'is_default': addresses.isEmpty || b['is_default'] == true,
      };
      addresses.add(a);
      return (201, a);
    }
    // billing
    if (p == '/api/v1/billing/me') {
      return (
        200,
        {
          'account_id': 1,
          'billing_mode': 'prepaid_wallet',
          'wallet_balance': walletBalance,
          'credit_outstanding': 0,
        },
      );
    }
    if (p == '/api/v1/billing/transactions') {
      return (
        200,
        [
          {
            'id': 2,
            'txn_type': 'order_debit',
            'amount': -64,
            'balance_after': 250,
            'created_at': '2026-10-30T06:00:00Z',
          },
          {
            'id': 1,
            'txn_type': 'topup',
            'amount': 314,
            'balance_after': 314,
            'created_at': '2026-10-29T06:00:00Z',
          },
        ],
      );
    }
    // subscriptions
    if (p == '/api/v1/subscriptions' && m == 'GET') {
      return (
        200,
        subscription == null
            ? const []
            : [
                {
                  for (final e in subscription!.entries)
                    if (e.key != 'items') e.key: e.value,
                },
              ],
      );
    }
    if (p == '/api/v1/subscriptions' && m == 'POST') {
      subscription ??= {
        'id': 5,
        'shop_id': 9,
        'account_id': 1,
        'status': 'active',
        'start_date': '2026-10-31',
        'items': <Object>[],
      };
      subscription!['status'] = 'active';
      return (
        200,
        {
          for (final e in subscription!.entries)
            if (e.key != 'items') e.key: e.value,
        },
      );
    }
    if (match(r'/api/v1/subscriptions/(\d+)') != null && m == 'GET') {
      return (200, _subDetail());
    }
    if (match(r'/api/v1/subscriptions/(\d+)/items') != null) {
      subscription!['items'] = [
        for (final (i, it)
            in (c.body! as List).cast<Map<String, Object?>>().indexed)
          {...it, 'id': 500 + i, 'active': true},
      ];
      return (200, _subDetail());
    }
    if (match(r'/api/v1/subscriptions/(\d+)/overrides') != null) {
      final day = (b['for_date']! as String).substring(0, 10);
      overrides.add('${b['product_id']}@$day:${b['override_qty']}');
      return (
        200,
        {
          'detail': 'override saved',
          'product_id': b['product_id'],
          'for_date': day,
          'qty': b['override_qty'],
        },
      );
    }
    if (match(r'/api/v1/subscriptions/(\d+)/(pause|resume|cancel)')
        case final mm?) {
      subscription!['status'] = switch (mm[2]) {
        'pause' => 'paused',
        'resume' => 'active',
        _ => 'cancelled',
      };
      return (
        200,
        {
          for (final e in subscription!.entries)
            if (e.key != 'items') e.key: e.value,
        },
      );
    }
    if (match(r'/api/v1/subscriptions/(\d+)/plan') != null) {
      final items =
          (subscription?['items'] as List?)?.cast<Map<String, Object?>>() ??
          const [];
      return (
        200,
        {
          'for_date': '2026-11-01',
          'lines': [
            for (final i in items)
              {'product_id': i['product_id'], 'qty': i['default_qty']},
          ],
        },
      );
    }
    return (404, {'detail': 'Not Found: ${c.key}'});
  }

  double _r3(double v) => (v * 1000).round() / 1000;

  @override
  void close({bool force = false}) {}

  Iterable<Call> callsTo(String key) => calls.where((c) => c.key == key);
}
