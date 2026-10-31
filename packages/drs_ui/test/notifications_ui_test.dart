import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _fonts() async {
  final poppins = FontLoader('packages/drs_ui/Poppins');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    poppins.addFont(
      rootBundle.load('packages/drs_ui/assets/fonts/Poppins-$w.ttf'),
    );
  }
  final icons = FontLoader('MaterialIcons')
    ..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'));
  await Future.wait([poppins.load(), icons.load()]);
}

Widget _host(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: DrsTheme.light,
  home: Scaffold(
    body: Padding(padding: const EdgeInsets.all(16), child: child),
  ),
);

void main() {
  setUpAll(_fonts);

  void phone(WidgetTester t) {
    t.view
      ..devicePixelRatio = 3
      ..physicalSize = const Size(393, 520) * 3;
    addTearDown(t.view.reset);
  }

  testWidgets('opt-in card: allow / not now', (t) async {
    phone(t);
    var allowed = 0, dismissed = 0;
    await t.pumpWidget(
      _host(
        DrsNotificationOptIn(
          reasons: const [
            'Order confirmed and out for delivery',
            'Low wallet balance',
          ],
          onAllow: () => allowed++,
          onNotNow: () => dismissed++,
        ),
      ),
    );
    await t.tap(find.text('Allow notifications'));
    await t.tap(find.text('Not now'));
    expect((allowed, dismissed), (1, 1));
  });

  testWidgets('settings tile explains each state', (t) async {
    phone(t);
    Future<void> show(bool available, bool? consent, PushPermission p) =>
        t.pumpWidget(
          _host(
            DrsNotificationSettingsTile(
              available: available,
              consent: consent,
              permission: p,
              onChanged: (_) {},
            ),
          ),
        );
    await show(false, null, PushPermission.unsupported);
    expect(find.text('Not available in this build'), findsOneWidget);
    await show(true, true, PushPermission.denied);
    expect(find.textContaining('Blocked in system settings'), findsOneWidget);
    await show(true, true, PushPermission.granted);
    expect(find.text('On for this device'), findsOneWidget);
    await show(true, false, PushPermission.granted);
    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('golden: notification opt-in + settings', (t) async {
    phone(t);
    await t.pumpWidget(
      _host(
        Column(
          children: [
            DrsNotificationOptIn(
              reasons: const [
                'Order confirmed, out for delivery and delivered',
                'Subscription reminders and low wallet balance',
              ],
              onAllow: () {},
              onNotNow: () {},
            ),
            const SizedBox(height: 12),
            Card(
              child: DrsNotificationSettingsTile(
                available: true,
                consent: true,
                permission: PushPermission.denied,
                onChanged: (_) {},
              ),
            ),
          ],
        ),
      ),
    );
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/notifications.png'),
    );
  }, tags: ['golden']);
}
