import 'package:cached_network_image/cached_network_image.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const placeholder = Icon(Icons.local_drink_outlined, key: Key('ph'));

  Widget host(Widget child, {bool enabled = true}) => MaterialApp(
    home: DrsMedia(
      apiBaseUrl: 'https://drs-backend-zvb1.onrender.com',
      enabled: enabled,
      child: Center(child: child),
    ),
  );

  testWidgets('relative backend paths resolve against the API origin and '
      'decode at display size', (t) async {
    await t.pumpWidget(
      host(
        const DrsNetworkImage(
          url: '/files/storefront-demo/products/milk-photo.jpg',
          width: 64,
          height: 64,
          placeholder: placeholder,
        ),
      ),
    );
    final img = t.widget<CachedNetworkImage>(find.byType(CachedNetworkImage));
    expect(
      img.imageUrl,
      'https://drs-backend-zvb1.onrender.com/files/storefront-demo/products/milk-photo.jpg',
    );
    final dpr = t.view.devicePixelRatio;
    expect(img.memCacheWidth, (64 * dpr).round());
    // Swap the tree out before the cache manager does any I/O.
    await t.pumpWidget(const SizedBox());
  });

  testWidgets('no URL, no media scope or images disabled -> placeholder', (
    t,
  ) async {
    await t.pumpWidget(
      host(const DrsNetworkImage(url: null, placeholder: placeholder)),
    );
    expect(find.byKey(const Key('ph')), findsOneWidget);

    await t.pumpWidget(
      host(
        const DrsNetworkImage(url: '/files/a.jpg', placeholder: placeholder),
        enabled: false,
      ),
    );
    expect(find.byKey(const Key('ph')), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);

    await t.pumpWidget(
      const MaterialApp(
        home: DrsNetworkImage(url: '/files/a.jpg', placeholder: placeholder),
      ),
    );
    expect(find.byKey(const Key('ph')), findsOneWidget);
  });
}
