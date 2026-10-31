import 'package:customer_app/src/routing/routes.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fake_drs_server.dart';
import 'support/harness.dart';
import 'support/seed.dart';

FakeDrsServer _reviewed() => seededServer()
  ..seedReview(2, 5, comment: 'Fresh every morning.', helpful: 4)
  ..seedReview(2, 4, comment: 'Good, a little thin.')
  ..seedReview(2, 5, reply: 'Thank you!')
  ..seedReview(2, 3, comment: 'Late once.', helpful: 1);

Future<void> _scrollTo(WidgetTester t, Finder f) => t.scrollUntilVisible(
  f,
  200,
  scrollable: find.byType(Scrollable).hitTestable().first,
);

void main() {
  testWidgets('product page shows the summary and the latest reviews', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: _reviewed());
    await h.start(t);
    await goTo(t, Routes.product(2));

    await _scrollTo(t, find.text('Ratings & reviews'));
    final summary = t.widget<DrsRatingSummary>(find.byType(DrsRatingSummary));
    expect(summary.count, 4);
    expect(summary.average, closeTo(4.25, 1e-9));
    expect(summary.shareOf(5), 0.5);
    expect(find.text('4.3'), findsOneWidget);
    // 3 of 4 shown, newest first; reviewers are anonymous.
    expect(find.text('Late once.'), findsOneWidget);
    expect(find.text('Fresh every morning.'), findsNothing);
    expect(find.textContaining('Asha'), findsNothing);
    await _scrollTo(t, find.text('See all reviews'));
    expect(find.text('Write a review'), findsOneWidget);
  });

  testWidgets('all reviews: sort by helpful, vote helpful (toggle)', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: _reviewed());
    await h.start(t);
    await goTo(t, Routes.productReviews(2));

    expect(find.text('Most recent'), findsOneWidget);
    expect(find.text('DRS replied: '), findsNothing); // RichText span
    expect(find.textContaining('Thank you!', findRichText: true), findsOne);

    await t.tap(find.text('Most helpful'));
    await t.pumpAndSettle();
    expect(h.server.calls.last.query, containsPair('sort', 'helpful'));
    final first = t.getTopLeft(find.text('Fresh every morning.'));
    final second = t.getTopLeft(find.text('Late once.'));
    expect(first.dy, lessThan(second.dy));

    final vote = find.text('Helpful · 4');
    await t.tap(vote);
    await t.pumpAndSettle();
    expect(find.text('Helpful · 5'), findsOneWidget);
    await t.tap(find.text('Helpful · 5'));
    await t.pumpAndSettle();
    expect(find.text('Helpful · 4'), findsOneWidget);
  });

  testWidgets('write → edit → delete my review (verified purchase)', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: _reviewed()..purchased.add(2));
    await h.start(t);
    await goTo(t, Routes.product(2));
    await _scrollTo(t, find.text('Write a review'));
    await t.tap(find.text('Write a review'));
    await t.pumpAndSettle();

    // Stars are required.
    await t.tap(find.text('Post review'));
    await t.pumpAndSettle();
    expect(find.text('Choose a star rating.'), findsOneWidget);
    expect(h.server.callsTo('POST /api/v1/products/2/ratings'), isEmpty);

    await t.tap(find.byKey(const ValueKey('star-4')));
    await t.enterText(
      find.byKey(const ValueKey('review-comment')),
      '  Creamy and fresh.  ',
    );
    await t.tap(find.text('Post review'));
    await t.pumpAndSettle();
    expect(h.server.callsTo('POST /api/v1/products/2/ratings').single.body, {
      'stars': 4,
      'comment': 'Creamy and fresh.',
    });
    expect(find.text('Thanks for your review'), findsOneWidget);

    // Back on the product page: mine first, editable.
    await _scrollTo(t, find.text('Your review'));
    expect(find.text('Verified purchase'), findsWidgets);
    await _scrollTo(t, find.text('Edit your review'));
    await t.tap(find.text('Edit your review'));
    await t.pumpAndSettle();
    expect(find.text('Creamy and fresh.'), findsOneWidget);
    await t.tap(find.byKey(const ValueKey('star-5')));
    await t.tap(find.text('Update review'));
    await t.pumpAndSettle();
    expect(h.server.ratings[2]!.where((r) => r['user_id'] == 7), hasLength(1));
    expect(
      h.server.ratings[2]!.firstWhere((r) => r['user_id'] == 7)['stars'],
      5,
    );

    await _scrollTo(t, find.text('Edit your review'));
    await t.tap(find.text('Edit your review'));
    await t.pumpAndSettle();
    await t.tap(find.text('Delete review'));
    await t.pumpAndSettle();
    await t.tap(find.text('Delete').last);
    await t.pumpAndSettle();
    expect(h.server.callsTo('DELETE /api/v1/products/2/ratings'), hasLength(1));
    expect(find.text('Review deleted'), findsOneWidget);
    expect(find.text('Your review'), findsNothing);
  });

  testWidgets('non-buyer review is held for moderation and says so', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: seededServer());
    await h.start(t);
    await goTo(t, Routes.writeReview(3));
    await t.tap(find.byKey(const ValueKey('star-2')));
    await t.tap(find.text('Post review'));
    await t.pumpAndSettle();
    expect(find.textContaining('once it’s approved'), findsOneWidget);

    await goTo(t, Routes.productReviews(3));
    expect(find.text('Awaiting approval'), findsOneWidget);
    // Pending reviews don't count towards the public summary.
    expect(t.widget<DrsRatingSummary>(find.byType(DrsRatingSummary)).count, 0);
  });

  testWidgets('delivered order items can be rated from order detail', (
    t,
  ) async {
    setDevice(t, const Size(412, 915));
    final s = seededServer();
    s.orders.first['status'] = 'delivered';
    final h = Harness(server: s);
    await h.start(t);
    await goTo(t, Routes.order(2));
    await _scrollTo(t, find.byKey(const ValueKey('rate-3')));
    await t.tap(find.byKey(const ValueKey('rate-3')));
    await t.pumpAndSettle();
    expect(find.text('Write a review'), findsOneWidget);
    expect(find.text('Masala Buttermilk'), findsOneWidget);
  });

  testWidgets('not-yet-delivered orders have no rate action', (t) async {
    setDevice(t, const Size(412, 915));
    final h = Harness(server: seededServer());
    await h.start(t);
    await goTo(t, Routes.order(1));
    expect(find.text('Rate this item'), findsNothing);
  });
}
