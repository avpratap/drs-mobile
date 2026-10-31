import 'dart:convert';
import 'dart:typed_data';

import 'package:delivery_app/src/app.dart';
import 'package:delivery_app/src/core/providers.dart';
import 'package:delivery_app/src/deliveries/todays_deliveries.dart';
import 'package:dio/dio.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _Backend implements HttpClientAdapter {
  _Backend({required this.role});

  final String role;
  final requests = <Uri>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions o,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(o.uri);
    final body = switch ('${o.method} ${o.path}') {
      'POST /api/v1/auth/otp/request' => {
        'detail': 'OTP sent',
        'dev_otp': '654321',
      },
      'POST /api/v1/auth/otp/verify' => {
        'access_token': 'a',
        'refresh_token': 'r',
      },
      'GET /api/v1/auth/me' => {
        'id': 5,
        'phone': '+919812345678',
        'role': role,
        'status': 'active',
      },
      'GET /api/v1/delivery/orders' => <Object>[],
      _ => {'detail': 'ok'},
    };
    return ResponseBody.fromString(
      jsonEncode(body),
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
  Future<_Backend> login(WidgetTester t, {required String role}) async {
    final backend = _Backend(role: role);
    final tokens = InMemoryTokenStore();
    await t.pumpWidget(
      ProviderScope(
        retry: (_, _) => null,
        overrides: [
          envProvider.overrideWithValue(
            const DrsEnv(flavor: DrsFlavor.dev, apiBaseUrl: 'http://test'),
          ),
          tokenStoreProvider.overrideWithValue(tokens),
          drsApiProvider.overrideWithValue(
            buildDrsApi(
              baseUrl: 'http://test',
              tokenStore: tokens,
              httpClientAdapter: backend,
            ),
          ),
        ],
        child: const DeliveryApp(),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('Rider login'), findsOneWidget);
    await t.enterText(find.byType(TextField), '9812345678');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    await t.tap(find.text('Use dev code 654321'));
    await t.pump();
    await t.tap(find.text('Log in'));
    await t.pumpAndSettle();
    return backend;
  }

  testWidgets('a rider logs in and sees the empty Today list', (t) async {
    final backend = await login(t, role: 'delivery');
    expect(find.text("Today's deliveries"), findsOneWidget);
    expect(find.text('No deliveries yet'), findsOneWidget);
    final listCall = backend.requests.lastWhere(
      (u) => u.path == '/api/v1/delivery/orders',
    );
    expect(listCall.queryParameters['date'], isNotNull);

    await t.tap(find.byTooltip('Log out'));
    await t.pumpAndSettle();
    expect(find.text('Rider login'), findsOneWidget);
  });

  testWidgets('customers are turned away', (t) async {
    await login(t, role: 'customer');
    expect(find.text('Rider login'), findsOneWidget);
    expect(find.textContaining('delivery partners'), findsOneWidget);
    expect(find.byType(DrsEmptyState), findsNothing);
  });

  test('todayIst rolls over at IST midnight, not UTC', () {
    // 2026-10-31 19:00 UTC == 2026-11-01 00:30 IST.
    expect(todayIst(DateTime.utc(2026, 10, 31, 19)), DateTime.utc(2026, 11, 1));
    expect(
      todayIst(DateTime.utc(2026, 10, 31, 18)),
      DateTime.utc(2026, 10, 31),
    );
  });
}
