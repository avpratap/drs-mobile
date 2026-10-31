import 'package:delivery_app/src/app.dart';
import 'package:delivery_app/src/core/providers.dart';
import 'package:delivery_app/src/data/delivery_database.dart';
import 'package:delivery_app/src/data/pod_files.dart';
import 'package:delivery_app/src/features/route/route_providers.dart';
import 'package:delivery_app/src/features/stop/external_actions.dart';
import 'package:delivery_app/src/features/stop/pod_camera.dart';
import 'package:delivery_app/src/features/sync/sync_controller.dart';
import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'fake_delivery_server.dart';

/// In-memory POD file store (dart:io async IO doesn't run under the widget
/// test clock).
class FakePodFiles extends PodFiles {
  final kept = <String>{};
  int wiped = 0;

  @override
  Future<String> keep(String sourcePath, String id) async {
    kept.add(id);
    return '/pod/$id.jpg';
  }

  @override
  Future<void> discard(String? path) async {
    if (path != null) kept.removeWhere((id) => path.contains(id));
  }

  @override
  Future<void> discardAll() async {
    kept.clear();
    wiped++;
  }
}

class FakeCamera implements PodCamera {
  int shots = 0;

  @override
  Future<String?> capture() async {
    shots++;
    return '/tmp/capture_$shots.jpg';
  }
}

class Harness {
  Harness({FakeDeliveryServer? server, this.signedIn = true, this.env})
    : server = server ?? FakeDeliveryServer();

  final FakeDeliveryServer server;
  final bool signedIn;
  final DrsEnv? env;
  final db = DeliveryDatabase(NativeDatabase.memory());
  final files = FakePodFiles();
  final camera = FakeCamera();
  final opened = <Uri>[];
  late final tokens = InMemoryTokenStore(
    signedIn ? const SessionTokens(accessToken: 'a', refreshToken: 'r') : null,
  );

  Widget app() => ProviderScope(
    retry: (_, _) => null,
    overrides: [
      envProvider.overrideWithValue(
        env ?? const DrsEnv(flavor: DrsFlavor.dev, apiBaseUrl: 'http://test'),
      ),
      tokenStoreProvider.overrideWithValue(tokens),
      drsApiProvider.overrideWithValue(
        buildDrsApi(
          baseUrl: 'http://test',
          tokenStore: tokens,
          httpClientAdapter: server,
        ),
      ),
      deliveryDatabaseProvider.overrideWithValue(db),
      podFilesProvider.overrideWithValue(files),
      podCameraProvider.overrideWithValue(camera),
      podPhotoReaderProvider.overrideWithValue(
        (path) async =>
            MultipartFile.fromBytes([0xFF, 0xD8, 0xFF], filename: 'pod.jpg'),
      ),
      urlOpenerProvider.overrideWithValue((uri) async {
        opened.add(uri);
        return true;
      }),
      autoSyncProvider.overrideWithValue(false),
      routeDayProvider.overrideWithValue(DateTime.utc(2026, 11, 1)),
    ],
    child: const DeliveryApp(),
  );

  Future<void> start(WidgetTester t) async {
    await t.pumpWidget(app());
    await t.pumpAndSettle();
  }
}

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

Future<void> goTo(WidgetTester t, String location) async {
  GoRouter.of(t.element(find.byType(Navigator).first)).go(location);
  await t.pumpAndSettle();
}

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

/// testWidgets wrapper that always unmounts the app and flushes Drift's
/// stream-cleanup timer inside the test body (it otherwise trips the
/// "Timer is still pending" invariant and wedges the runner).
void deliveryTest(
  String description,
  Future<void> Function(WidgetTester t, Harness h) body, {
  Harness Function()? harness,
  TestVariant<Object?> variant = const DefaultTestVariant(),
}) {
  testWidgets(description, variant: variant, (t) async {
    final h = harness?.call() ?? Harness();
    try {
      await body(t, h);
    } finally {
      await t.pumpWidget(const SizedBox());
      await t.pump(const Duration(milliseconds: 10));
      await h.db.close();
    }
  });
}

/// Signed-in tokens for tests that start at the login screen.
class SessionTokensForTest extends SessionTokens {
  const SessionTokensForTest() : super(accessToken: 'a', refreshToken: 'r');
}
