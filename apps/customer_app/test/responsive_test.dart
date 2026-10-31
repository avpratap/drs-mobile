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

/// Representative devices (logical size + system insets for notches,
/// Dynamic Island, home indicator and landscape cut-outs).
class Device {
  const Device(this.name, this.size, this.padding, {this.textScale = 1});

  final String name;
  final Size size;
  final EdgeInsets padding;
  final double textScale;

  bool get wide => size.width >= DrsWindowSize.mediumMin;
}

const devices = [
  Device('iPhone SE (1st gen)', Size(320, 568), EdgeInsets.only(top: 20)),
  Device(
    'small Android @ 1.5x text',
    Size(360, 640),
    EdgeInsets.only(top: 24),
    textScale: 1.5,
  ),
  Device(
    'iPhone 15 (Dynamic Island)',
    Size(393, 852),
    EdgeInsets.only(top: 59, bottom: 34),
  ),
  Device('Pixel 7', Size(412, 915), EdgeInsets.only(top: 24, bottom: 24)),
  Device(
    'iPhone 15 landscape',
    Size(852, 393),
    EdgeInsets.only(left: 59, right: 59, bottom: 21),
  ),
  Device(
    'iPad 11" landscape',
    Size(1194, 834),
    EdgeInsets.only(top: 24, bottom: 20),
  ),
];

void main() {
  {
    for (final d in devices) {
      testWidgets(
        '${d.name}: lays out without overflow',
        variant: const TargetPlatformVariant({
          TargetPlatform.android,
          TargetPlatform.iOS,
        }),
        (t) async {
          t.view
            ..devicePixelRatio = 3
            ..physicalSize = d.size * 3
            ..padding = FakeViewPadding(
              left: d.padding.left * 3,
              top: d.padding.top * 3,
              right: d.padding.right * 3,
              bottom: d.padding.bottom * 3,
            )
            ..viewPadding = FakeViewPadding(
              left: d.padding.left * 3,
              top: d.padding.top * 3,
              right: d.padding.right * 3,
              bottom: d.padding.bottom * 3,
            );
          t.platformDispatcher.textScaleFactorTestValue = d.textScale;
          addTearDown(t.view.reset);
          addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);

          final db = AppDatabase(NativeDatabase.memory());
          addTearDown(db.close);
          final tokens = InMemoryTokenStore();
          final backend = FakeBackend({
            'POST /api/v1/auth/otp/request': (_) =>
                FakeBackend.json(200, {'detail': 'OTP sent'}),
            'GET /api/v1/auth/me': (_) => FakeBackend.json(200, {
              'id': 1,
              'phone': '+919876543210',
              'role': 'customer',
              'full_name': 'Asha Devi',
              'status': 'active',
            }),
            'GET /api/v1/products': (_) =>
                FakeBackend.json(200, sampleProducts),
          });

          await t.pumpWidget(
            ProviderScope(
              retry: (_, _) => null,
              overrides: [
                envProvider.overrideWithValue(
                  const DrsEnv(
                    flavor: DrsFlavor.dev,
                    apiBaseUrl: 'http://test',
                  ),
                ),
                tokenStoreProvider.overrideWithValue(tokens),
                appDatabaseProvider.overrideWithValue(db),
                drsApiProvider.overrideWithValue(
                  buildDrsApi(
                    baseUrl: 'http://test',
                    tokenStore: tokens,
                    httpClientAdapter: backend,
                  ),
                ),
              ],
              child: const CustomerApp(),
            ),
          );
          await t.pumpAndSettle();

          // Sign-in screen fits, including the keyboard-free state.
          expect(find.text('Sign in'), findsOneWidget);
          expect(t.takeException(), isNull);

          // Signed-in shell.
          await tokens.write(
            const SessionTokens(accessToken: 'a', refreshToken: 'r'),
          );
          await t.pumpWidget(const SizedBox());
          await t.pumpWidget(
            ProviderScope(
              retry: (_, _) => null,
              overrides: [
                envProvider.overrideWithValue(
                  const DrsEnv(
                    flavor: DrsFlavor.dev,
                    apiBaseUrl: 'http://test',
                  ),
                ),
                tokenStoreProvider.overrideWithValue(tokens),
                appDatabaseProvider.overrideWithValue(db),
                drsApiProvider.overrideWithValue(
                  buildDrsApi(
                    baseUrl: 'http://test',
                    tokenStore: tokens,
                    httpClientAdapter: backend,
                  ),
                ),
              ],
              child: const CustomerApp(),
            ),
          );
          await t.pumpAndSettle();
          expect(t.takeException(), isNull);
          await t.scrollUntilVisible(
            find.text("Today's essentials"),
            100,
            scrollable: find.byType(Scrollable).hitTestable().first,
          );
          expect(t.takeException(), isNull);

          // Adaptive navigation: bottom bar on phones, rail when wide.
          expect(
            find.byType(NavigationBar),
            d.wide ? findsNothing : findsOneWidget,
          );
          expect(
            find.byType(NavigationRail),
            d.wide ? findsOneWidget : findsNothing,
          );

          // Content never sits under the status bar / notch / Dynamic Island.
          final logoTop = t.getTopLeft(find.byType(DrsLogo).first);
          expect(logoTop.dy, greaterThanOrEqualTo(d.padding.top));
          if (d.wide) {
            // Landscape cut-out: rail starts after the left inset.
            expect(
              t.getTopLeft(find.byType(NavigationRail)).dx,
              greaterThanOrEqualTo(d.padding.left),
            );
          }

          for (final tab in ['Shop', 'Subscriptions', 'Account']) {
            await t.tap(find.text(tab).last);
            await t.pumpAndSettle();
            expect(t.takeException(), isNull, reason: tab);
          }

          // Bottom-most interactive content clears the home indicator.
          await t.scrollUntilVisible(
            find.text('Sign out'),
            100,
            scrollable: find.byType(Scrollable).hitTestable().first,
          );
          await t.pumpAndSettle(); // let iOS bounce physics come to rest
          final signOut = t.getBottomLeft(find.text('Sign out'));
          expect(
            signOut.dy,
            lessThanOrEqualTo(d.size.height - d.padding.bottom),
          );
        },
      );
    }
  }
}
