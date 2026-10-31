import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('window size classes follow Material 3 breakpoints', () {
    expect(DrsWindowSize.forWidth(320), DrsWindowSize.compact);
    expect(DrsWindowSize.forWidth(599), DrsWindowSize.compact);
    expect(DrsWindowSize.forWidth(600), DrsWindowSize.medium);
    expect(DrsWindowSize.forWidth(852), DrsWindowSize.expanded);
  });

  test('adaptive list adds columns only when each stays wide enough', () {
    expect(DrsAdaptiveSliverList.columnsFor(320, 340, 3), 1);
    expect(DrsAdaptiveSliverList.columnsFor(700, 340, 3), 2);
    expect(DrsAdaptiveSliverList.columnsFor(1200, 340, 3), 3);
  });

  testWidgets(
    'confirm dialog is Cupertino on iOS and Material on Android',
    (t) async {
      late bool result;
      await t.pumpWidget(
        MaterialApp(
          theme: DrsTheme.light,
          home: Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showDrsConfirmDialog(
                context,
                title: 'Sign out?',
                confirmLabel: 'Sign out',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      );
      await t.tap(find.text('open'));
      await t.pumpAndSettle();
      final isIos = defaultTargetPlatform == TargetPlatform.iOS;
      expect(
        find.byType(CupertinoAlertDialog),
        isIos ? findsOneWidget : findsNothing,
      );
      await t.tap(find.text('Sign out').last);
      await t.pumpAndSettle();
      expect(result, isTrue);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );
}
