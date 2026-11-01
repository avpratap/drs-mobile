import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _loadFonts() async {
  Future<ByteData> f(String p) => rootBundle.load(p);
  final poppins = FontLoader('packages/drs_ui/Poppins');
  for (final w in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
    poppins.addFont(f('packages/drs_ui/assets/fonts/Poppins-$w.ttf'));
  }
  final montserrat = FontLoader('packages/drs_ui/Montserrat')
    ..addFont(f('packages/drs_ui/assets/fonts/Montserrat-ExtraBold.ttf'));
  await Future.wait([poppins.load(), montserrat.load()]);
}

/// The lockup at the sizes the apps use, on cream (light) and on green
/// (onDark), plus the mark alone and the small-size plain mark.
Widget _sheet() => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: DrsTheme.light,
  home: Scaffold(
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(padding: EdgeInsets.all(16), child: DrsLogo()),
        const Padding(padding: EdgeInsets.all(16), child: DrsLogo(size: 88)),
        Container(
          color: DrsBrandColors.green,
          padding: const EdgeInsets.all(16),
          child: const DrsLogo(onDark: true),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            spacing: 16,
            children: [
              DrsLogoMark(size: 96),
              DrsLogoMark(),
              DrsLogoMark(size: 20), // small-size rule: no keyline
            ],
          ),
        ),
      ],
    ),
  ),
);

void main() {
  setUpAll(_loadFonts);

  testWidgets('golden: brand lockup (matches the web StoreLogo)', (t) async {
    t.view
      ..physicalSize = const Size(360, 480) * 2
      ..devicePixelRatio = 2;
    addTearDown(t.view.reset);
    await t.pumpWidget(_sheet());
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/logo.png'),
    );
  });

  testWidgets('one screen-reader label, ignores system text scale', (t) async {
    final semantics = t.ensureSemantics();
    t.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(t.platformDispatcher.clearTextScaleFactorTestValue);
    await t.pumpWidget(_sheet());
    expect(find.bySemanticsLabel('DRS Dairy'), findsWidgets);
    expect(find.bySemanticsLabel('DAIRY'), findsNothing);
    // 44px tile + wordmark keeps its size at 2x system text.
    expect(t.getSize(find.byType(DrsLogo).first).height, 44);
    semantics.dispose();
  });
}
