import 'package:customer_app/src/app.dart';
import 'package:customer_app/src/core/providers.dart';
import 'package:customer_app/src/core/push.dart';
import 'package:customer_app/src/data/local/app_database.dart';
import 'package:customer_app/src/features/checkout/application/checkout_controller.dart';
import 'package:customer_app/src/features/checkout/application/payment_gateway.dart';
import 'package:drift/native.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/testing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'fake_drs_server.dart';

/// Device viewport with system insets (logical px).
void setDevice(
  WidgetTester t,
  Size size, {
  EdgeInsets insets = EdgeInsets.zero,
  double textScale = 1,
}) {
  final pad = FakeViewPadding(
    left: insets.left * 3,
    top: insets.top * 3,
    right: insets.right * 3,
    bottom: insets.bottom * 3,
  );
  t.view
    ..devicePixelRatio = 3
    ..physicalSize = size * 3
    ..padding = pad
    ..viewPadding = pad;
  t.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(t.view.reset);
  addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
}

/// Scripted Razorpay replacement.
class FakeGateway implements PaymentGateway {
  FakeGateway(this.result);

  GatewayResult result;
  final requests = <PaymentRequest>[];

  @override
  Future<GatewayResult> pay(PaymentRequest request) async {
    requests.add(request);
    return result;
  }
}

class Harness {
  Harness({
    FakeDrsServer? server,
    this.env,
    this.gateway,
    this.push,
    bool signedIn = true,
  }) : server = server ?? FakeDrsServer(),
       tokens = InMemoryTokenStore(
         signedIn
             ? const SessionTokens(accessToken: 'a', refreshToken: 'r')
             : null,
       );

  final FakeDrsServer server;
  final DrsEnv? env;
  final PaymentGateway? gateway;
  final db = AppDatabase(NativeDatabase.memory());
  final InMemoryTokenStore tokens;

  /// When set, the shared notifications service runs on this fake platform.
  final FakePushPlatform? push;
  final pushPrefs = InMemoryPushPrefs();

  Widget app() => ProviderScope(
    retry: (_, _) => null,
    overrides: [
      envProvider.overrideWithValue(
        env ?? const DrsEnv(flavor: DrsFlavor.dev, apiBaseUrl: 'http://test'),
      ),
      tokenStoreProvider.overrideWithValue(tokens),
      // Fixed 8 am so time-of-day UI (greeting) is deterministic in goldens.
      clockProvider.overrideWithValue(() => DateTime(2026, 11, 1, 8)),
      appDatabaseProvider.overrideWithValue(db),
      drsApiProvider.overrideWithValue(
        buildDrsApi(
          baseUrl: 'http://test',
          tokenStore: tokens,
          httpClientAdapter: server,
        ),
      ),
      if (gateway != null) paymentGatewayProvider.overrideWithValue(gateway!),
      if (push != null) ...pushOverrides(platform: push, prefs: pushPrefs),
    ],
    child: const CustomerApp(),
  );

  /// Pumps the app signed in and settled on Home.
  Future<void> start(WidgetTester t) async {
    addTearDown(db.close);
    await t.pumpWidget(app());
    await t.pumpAndSettle();
  }
}

/// Navigate with the app's router (from anywhere in the tree).
Future<void> goTo(WidgetTester t, String location) async {
  GoRouter.of(t.element(find.byType(Navigator).first)).go(location);
  await t.pumpAndSettle();
}

/// Loads the bundled brand fonts + Material icons so goldens show real text.
Future<void> loadFonts() async {
  Future<ByteData> f(String p) => rootBundle.load(p);
  final poppins = FontLoader('packages/drs_ui/Poppins');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    poppins.addFont(f('packages/drs_ui/assets/fonts/Poppins-$w.ttf'));
  }
  final montserrat = FontLoader('packages/drs_ui/Montserrat')
    ..addFont(f('packages/drs_ui/assets/fonts/Montserrat-ExtraBold.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(f('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([poppins.load(), montserrat.load(), icons.load()]);
}
