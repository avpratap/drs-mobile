import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

void main() {
  test('profile redacts PII', () {
    const p = Profile(
      userId: 1,
      phone: '+919876543210',
      email: 'asha@example.in',
      fullName: 'Asha Devi',
    );
    expect(p.toString(), isNot(contains('asha')));
    expect(p.toString(), isNot(contains('9876543210')));
    expect(p.maskedPhone, '+91 98•••••210');
  });

  test('email shape', () {
    expect(isPlausibleEmail('a@b.in'), isTrue);
    expect(isPlausibleEmail('a@b'), isFalse);
    expect(isPlausibleEmail('a b@c.in'), isFalse);
  });

  test('review summary share and own review', () {
    const s = ReviewSummary(
      productId: 2,
      count: 4,
      average: 4.25,
      distribution: {5: 2, 4: 1, 3: 1},
      reviews: [
        Review(id: 1, productId: 2, stars: 5, status: ReviewStatus.approved),
        Review(
          id: 2,
          productId: 2,
          stars: 3,
          status: ReviewStatus.pending,
          mine: true,
        ),
      ],
    );
    expect(s.share(5), 0.5);
    expect(s.share(1), 0);
    expect(s.mine?.id, 2);
    expect(ReviewStatus.parse('rejected'), ReviewStatus.rejected);
  });
}
