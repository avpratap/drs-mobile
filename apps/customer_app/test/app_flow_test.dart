import 'package:customer_app/src/app.dart';
import 'package:customer_app/src/core/providers.dart';
import 'package:customer_app/src/data/local/app_database.dart';
import 'package:drift/native.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'support/fake_backend.dart';

void main() {
  late AppDatabase db;
  late FakeBackend backend;
  late InMemoryTokenStore tokens;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tokens = InMemoryTokenStore();
    backend = FakeBackend({
      'POST /api/v1/auth/otp/request': (_) =>
          FakeBackend.json(200, {'detail': 'OTP sent', 'dev_otp': '123456'}),
      'POST /api/v1/auth/otp/verify': (_) => FakeBackend.json(200, {
        'access_token': 'access-1',
        'refresh_token': 'refresh-1',
      }),
      'GET /api/v1/auth/me': (r) =>
          r.headers['Authorization'] == 'Bearer access-1'
          ? FakeBackend.json(200, {
              'id': 42,
              'phone': '+919876543210',
              'role': 'customer',
              'full_name': 'Asha Devi',
              'status': 'active',
            })
          : FakeBackend.json(401, {'detail': 'Not authenticated'}),
      'GET /api/v1/products': (_) => FakeBackend.json(200, sampleProducts),
      'POST /api/v1/auth/logout': (_) =>
          FakeBackend.json(200, {'detail': 'logged out'}),
    });
  });

  tearDown(() => db.close());

  /// A tall phone viewport (412×915 dp) so the whole catalogue is laid out.
  void phoneViewport(WidgetTester t) {
    t.view.devicePixelRatio = 2.625;
    t.view.physicalSize = const Size(1081.5, 2402);
    addTearDown(t.view.reset);
  }

  Widget app() => ProviderScope(
    retry: (_, _) => null,
    overrides: [
      envProvider.overrideWithValue(
        const DrsEnv(flavor: DrsFlavor.dev, apiBaseUrl: 'http://test'),
      ),
      tokenStoreProvider.overrideWithValue(tokens),
      appDatabaseProvider.overrideWithValue(db),
      // The app's real client (session + connectivity interceptors).
      httpClientAdapterProvider.overrideWithValue(backend),
      networkImagesProvider.overrideWithValue(false),
    ],
    child: const CustomerApp(),
  );

  testWidgets('phone OTP sign-in lands on Home with the catalogue', (t) async {
    phoneViewport(t);
    await t.pumpWidget(app());
    await t.pumpAndSettle();

    // Signed out → sign-in screen.
    expect(find.text('Sign in'), findsOneWidget);
    await t.enterText(find.byType(TextField), '9876543210');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();

    // OTP screen: phone is masked, dev code offered (non-prod).
    expect(find.text('Code sent to +91 98•••••210'), findsOneWidget);
    await t.tap(find.text('Use dev code 123456'));
    await t.pump();
    await t.tap(find.text('Verify & continue'));
    await t.pumpAndSettle();

    // Signed in → Home tab with greeting and milk line first.
    expect(await tokens.read(), isNotNull);
    expect(find.textContaining('Asha'), findsOneWidget);
    expect(find.text("Today's essentials"), findsOneWidget);
    expect(find.byType(DrsProductCard), findsNWidgets(3));
    expect(
      t.getTopLeft(find.text('Cow Milk')).dy,
      lessThan(t.getTopLeft(find.text('A2 Desi Ghee')).dy),
    );
    expect(find.byType(NavigationBar), findsOneWidget);

    // Shop tab lists and filters.
    await t.tap(find.text('Shop'));
    await t.pumpAndSettle();
    await t.tap(find.widgetWithText(ChoiceChip, 'Ghee'));
    await t.pumpAndSettle();
    expect(find.byType(DrsProductCard), findsOneWidget);

    // Sign out returns to sign-in and wipes tokens.
    await t.tap(find.text('Account'));
    await t.pumpAndSettle();
    expect(find.text('+91 98•••••210'), findsOneWidget);
    await t.tap(find.text('Sign out'));
    await t.pumpAndSettle();
    expect(find.text('Sign out?'), findsOneWidget); // adaptive confirm dialog
    await t.tap(find.text('Sign out').last);
    await t.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    expect(await tokens.read(), isNull);
  });

  testWidgets('restored session starts offline on the cached catalogue', (
    t,
  ) async {
    phoneViewport(t);
    // Warm the cache, then start a new app session with no network.
    await tokens.write(
      const SessionTokens(accessToken: 'access-1', refreshToken: 'refresh-1'),
    );
    await t.pumpWidget(app());
    await t.pumpAndSettle();
    expect(find.byType(DrsProductCard), findsNWidgets(3));

    await t.pumpWidget(const SizedBox());
    backend.offline = true;
    await t.pumpWidget(app());
    await t.pumpAndSettle();

    // One app-wide strip (not a second per-screen banner).
    expect(find.byType(DrsOfflineBanner), findsOneWidget);
    expect(
      find.text("You're offline — saved information is shown where available."),
      findsOneWidget,
    );
    expect(find.byType(DrsProductCard), findsNWidgets(3));
  });

  testWidgets('rejects an invalid phone number without calling the API', (
    t,
  ) async {
    phoneViewport(t);
    await t.pumpWidget(app());
    await t.pumpAndSettle();
    await t.enterText(find.byType(TextField), '1234567890');
    await t.pump();
    await t.tap(find.text('Send OTP'));
    await t.pumpAndSettle();
    expect(find.textContaining('valid 10-digit'), findsOneWidget);
    expect(backend.requests, isNot(contains('POST /api/v1/auth/otp/request')));
  });
}
