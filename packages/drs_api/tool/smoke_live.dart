// End-to-end smoke test of the typed client against a running backend.
//
//   cd packages/drs_api
//   dart run tool/smoke_live.dart                       # live backend, public
//   SMOKE_CUSTOMER_PHONE=9xxxxxxxxx SMOKE_RIDER_PHONE=9999900003 \
//     dart run tool/smoke_live.dart [base-url]
//
// Read-only: it browses, signs in (only when a phone is given and the backend
// returns a dev OTP, i.e. a non-prod backend), reads account/cart/route data
// and logs out. It places no orders and changes no settings. Output never
// contains phone numbers, OTPs, tokens or personal data — only step names,
// status and counts. Every response is decoded with the generated models, so
// a contract mismatch fails the step.
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:json_annotation/json_annotation.dart'
    show CheckedFromJsonException;

const liveBaseUrl = 'https://drs-backend-zvb1.onrender.com';

var _failures = 0;

Future<T?> step<T>(
  String name,
  Future<T> Function() run, {
  String Function(T)? info,
}) async {
  final sw = Stopwatch()..start();
  try {
    final r = await run();
    final extra = info == null ? '' : ' — ${info(r)}';
    stdout.writeln('  ok    $name (${sw.elapsedMilliseconds} ms)$extra');
    return r;
  } on Object catch (e) {
    _failures++;
    final why = switch (e) {
      // The generated client wraps decoding errors in a DioException.
      DioException(error: CheckedFromJsonException(:final key)) =>
        'contract mismatch at "$key"',
      DioException(:final response?) => 'HTTP ${response.statusCode}',
      DioException(:final type, :final error) =>
        '${type.name}${error == null ? '' : ' (${error.runtimeType})'}',
      CheckedFromJsonException(:final key) => 'contract mismatch at "$key"',
      _ => e.runtimeType.toString(),
    };
    stdout.writeln('  FAIL  $name (${sw.elapsedMilliseconds} ms) — $why');
    return null;
  }
}

/// Signs in with the dev OTP the backend returns outside prod.
Future<bool> signIn(
  DrsApi api,
  TokenStore tokens,
  String phone,
  String who,
) async {
  final auth = api.getAuthApi();
  final otp = await step(
    '$who: request OTP',
    () async =>
        (await auth.requestOtp(oTPRequest: OTPRequest(phone: phone))).data!,
  );
  final code = otp?.devOtp;
  if (code == null) {
    stdout.writeln(
      '  skip  $who: sign-in (no dev OTP — prod backend, needs a real SMS)',
    );
    return false;
  }
  final pair = await step(
    '$who: verify OTP',
    () async => (await auth.verifyOtp(
      oTPVerify: OTPVerify(phone: phone, otp: code),
    )).data!,
  );
  if (pair == null) return false;
  await tokens.write(
    SessionTokens(
      accessToken: pair.accessToken,
      refreshToken: pair.refreshToken,
    ),
  );
  await step(
    '$who: who am I',
    () async => (await auth.getMe()).data!,
    info: (u) => 'role ${u.role}',
  );
  return true;
}

Future<void> signOut(DrsApi api, TokenStore tokens, String who) async {
  final t = await tokens.read();
  if (t == null) return;
  await step(
    '$who: log out',
    () => api.getAuthApi().logout(
      refreshRequest: RefreshRequest(refreshToken: t.refreshToken),
    ),
  );
  await tokens.clear();
}

Future<void> main(List<String> args) async {
  final base = args.isNotEmpty ? args.first : liveBaseUrl;
  stdout.writeln('DRS smoke test against ${Uri.parse(base).host}');

  DrsApi client(TokenStore tokens) => buildDrsApi(
    baseUrl: base,
    tokenStore: tokens,
    // Free-tier hosts cold-start; give the first request time.
    connectTimeout: const Duration(seconds: 60),
    receiveTimeout: const Duration(seconds: 90),
  );

  // Public catalogue.
  final public = client(InMemoryTokenStore());
  final products = await step(
    'catalogue: list products',
    () async => (await public.getProductsApi().listProducts()).data!,
    info: (p) => '${p.length} products',
  );
  if (products != null && products.isNotEmpty) {
    final id = products.first.id;
    await step(
      'catalogue: product detail',
      () async =>
          (await public.getProductsApi().getProductFull(productId: id)).data!,
    );
    await step(
      'reviews: list ratings',
      () async =>
          (await public.getReviewsApi().listProductRatings(productId: id))
              .data!,
      info: (r) => '${r.count} approved',
    );
  }

  // Customer (optional).
  final customerPhone = Platform.environment['SMOKE_CUSTOMER_PHONE'] ?? '';
  if (customerPhone.isNotEmpty) {
    final tokens = InMemoryTokenStore();
    final api = client(tokens);
    if (await signIn(api, tokens, customerPhone, 'customer')) {
      final account = api.getAccountApi();
      await step(
        'customer: profile',
        () async => (await account.getProfile()).data!,
      );
      await step(
        'customer: consents',
        () async => (await account.getConsents()).data!,
      );
      await step(
        'customer: addresses',
        () async => (await account.listAddresses()).data!,
        info: (a) => '${a.length} saved',
      );
      await step(
        'customer: cart',
        () async => (await api.getCartApi().getCart()).data!,
      );
      await step(
        'customer: orders',
        () async => (await api.getOrdersApi().listOrders()).data!,
        info: (o) => '${o.length} orders',
      );
      await step(
        'customer: subscriptions',
        () async => (await api.getSubscriptionsApi().listSubscriptions()).data!,
      );
      await step(
        'customer: wallet',
        () async => (await api.getBillingApi().myBilling()).data!,
      );
      await signOut(api, tokens, 'customer');
    }
  } else {
    stdout.writeln('  skip  customer flow (set SMOKE_CUSTOMER_PHONE)');
  }

  // Rider (optional; the seeded agent is 9999900003).
  final riderPhone = Platform.environment['SMOKE_RIDER_PHONE'] ?? '';
  if (riderPhone.isNotEmpty) {
    final tokens = InMemoryTokenStore();
    final api = client(tokens);
    if (await signIn(api, tokens, riderPhone, 'rider')) {
      await step(
        'rider: today\'s route',
        () async => (await api.getDeliveryApi().deliveryRoute()).data!,
        info: (r) => '${r.length} stops',
      );
      await signOut(api, tokens, 'rider');
    }
  } else {
    stdout.writeln('  skip  rider flow (set SMOKE_RIDER_PHONE)');
  }

  stdout.writeln(_failures == 0 ? 'PASS' : 'FAIL ($_failures step(s))');
  exit(_failures == 0 ? 0 : 1);
}
