import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {double textScale = 1}) => MaterialApp(
  theme: DrsTheme.light,
  home: MediaQuery(
    data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  group('DrsTheme', () {
    test('uses the locked brand palette', () {
      final s = DrsTheme.light.colorScheme;
      expect(s.primary, const Color(0xFF0D4C3C));
      expect(s.secondary, const Color(0xFF3B0A1E));
      expect(s.tertiary, const Color(0xFFC5A253));
      expect(s.surface, const Color(0xFFF4EADE));
      expect(s.onSurface, const Color(0xFF1E1A1E));
      expect(s.onPrimary, const Color(0xFFF4EADE));
      expect(
        DrsTheme.light.extension<DrsColors>()!.sky,
        const Color(0xFF6FC5F4),
      );
    });

    test('Poppins is the default family; dark theme is available', () {
      expect(
        DrsTheme.light.textTheme.bodyMedium!.fontFamily,
        contains('Poppins'),
      );
      expect(DrsTheme.dark.brightness, Brightness.dark);
    });

    test('sky accent is reserved for the milk / buttermilk line', () {
      const brand = DrsColors.light;
      const scheme = DrsTheme.lightScheme;
      expect(brand.accentFor(ProductLine.milk, scheme), DrsPalette.sky);
      expect(brand.accentFor(ProductLine.buttermilk, scheme), DrsPalette.sky);
      for (final l in [
        ProductLine.ghee,
        ProductLine.curd,
        ProductLine.paneer,
      ]) {
        expect(brand.accentFor(l, scheme), scheme.primary);
      }
    });
  });

  testWidgets('DrsQuantityStepper adds, increments and removes', (t) async {
    var qty = 0;
    await t.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) => _wrap(
          DrsQuantityStepper(
            value: qty,
            onChanged: (v) => setState(() => qty = v),
          ),
        ),
      ),
    );
    await t.tap(find.text('Add'));
    await t.pump();
    expect(qty, 1);
    await t.tap(find.byTooltip('Increase'));
    await t.pump();
    expect(find.text('2'), findsOneWidget);
    await t.tap(find.byTooltip('Decrease'));
    await t.pump();
    await t.tap(find.byTooltip('Decrease'));
    await t.pump();
    expect(qty, 0);
    expect(find.text('Add'), findsOneWidget);
  });

  testWidgets('DrsButton shows a spinner and blocks taps while loading', (
    t,
  ) async {
    var taps = 0;
    await t.pumpWidget(
      _wrap(
        DrsButton(label: 'Send OTP', isLoading: true, onPressed: () => taps++),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await t.tap(find.byType(FilledButton));
    expect(taps, 0);
  });

  testWidgets('DrsProductCard renders at 2x text scale without overflow', (
    t,
  ) async {
    final product = Product(
      id: 1,
      sku: 'MILK-500',
      name: 'Farm fresh cow milk',
      category: 'Milk',
      uom: 'litre',
      packSize: 0.5,
      fromPrice: Money.fromRupees(32),
    );
    await t.pumpWidget(
      _wrap(
        SizedBox(
          width: 360,
          child: DrsProductCard(
            product: product,
            trailing: DrsQuantityStepper(value: 0, onChanged: (_) {}),
          ),
        ),
        textScale: 2,
      ),
    );
    expect(t.takeException(), isNull);
    expect(find.text('500 ml'), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp(r'from ₹32 per|from ₹32')),
      findsOneWidget,
    );
  });
}
