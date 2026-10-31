import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget c) => MaterialApp(
  theme: DrsTheme.light,
  home: Scaffold(body: Center(child: c)),
);

void main() {
  testWidgets('star input taps and labels', (t) async {
    var v = 0;
    await t.pumpWidget(
      StatefulBuilder(
        builder: (context, set) =>
            _host(DrsStarInput(value: v, onChanged: (x) => set(() => v = x))),
      ),
    );
    expect(find.text('Tap to rate'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('star-4')));
    await t.pump();
    expect(v, 4);
    expect(find.text('Very good'), findsOneWidget);
  });

  testWidgets('stars expose an accessible value', (t) async {
    await t.pumpWidget(_host(const DrsStars(value: 4.3)));
    expect(find.bySemanticsLabel('4.3 out of 5 stars'), findsOneWidget);
    expect(find.byIcon(Icons.star_half_rounded), findsNothing); // 4.3 < 4.5
    await t.pumpWidget(_host(const DrsStars(value: 4.5)));
    expect(find.byIcon(Icons.star_half_rounded), findsOneWidget);
  });

  testWidgets('summary renders without reviews', (t) async {
    await t.pumpWidget(
      _host(DrsRatingSummary(average: 0, count: 0, shareOf: (_) => 0)),
    );
    expect(find.text('–'), findsOneWidget);
    expect(find.text('0 reviews'), findsOneWidget);
  });
}
