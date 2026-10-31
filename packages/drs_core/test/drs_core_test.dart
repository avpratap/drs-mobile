import 'package:drs_core/drs_core.dart';
import 'package:test/test.dart';

void main() {
  group('Money', () {
    test('converts rupees to paise without float drift', () {
      expect(Money.fromRupees(0.1).paise + Money.fromRupees(0.2).paise, 30);
      expect(Money.fromRupees(42.5).paise, 4250);
    });

    test('formats with Indian digit grouping', () {
      expect(Money.fromRupees(123456.5).format(), '₹1,23,456.50');
      expect(Money.fromRupees(45).format(), '₹45');
      expect(Money.fromRupees(45).format(compact: false), '₹45.00');
    });

    test('times() handles fractional quantities', () {
      expect(Money.fromRupees(60).times(1.5), Money.fromRupees(90));
    });
  });

  group('IndianPhone', () {
    test('normalises common spellings', () {
      for (final v in [
        '9876543210',
        '98765 43210',
        '+91 98765-43210',
        '919876543210',
        '09876543210',
      ]) {
        expect(IndianPhone.normalize(v), '+919876543210', reason: v);
      }
    });

    test('rejects non-mobile numbers', () {
      expect(IndianPhone.normalize('1234567890'), isNull);
      expect(IndianPhone.normalize('98765'), isNull);
      expect(IndianPhone.normalize(''), isNull);
    });
  });

  group('Pii', () {
    test('masks phones', () {
      expect(Pii.maskPhone('+919876543210'), '+91 98•••••210');
    });

    test('redacts phones, emails and JWTs from text', () {
      final out = Pii.redact(
        'user +91 98765 43210 a@b.co token eyJhbGc.eyJzdWIi.sig-123',
      );
      expect(out, isNot(contains('98765')));
      expect(out, contains('[email]'));
      expect(out, contains('[jwt]'));
    });

    test('Account.toString never leaks the raw phone', () {
      const a = Account(
        userId: 1,
        phone: '+919876543210',
        role: AccountRole.customer,
        fullName: 'Asha Devi',
      );
      expect(a.toString(), isNot(contains('9876543210')));
      expect(a.toString(), isNot(contains('Asha')));
      expect(a.greetingName, 'Asha');
    });
  });

  group('Product', () {
    test('maps categories to lines; sky accent only for milk/buttermilk', () {
      expect(ProductLine.fromCategory('Milk'), ProductLine.milk);
      expect(ProductLine.fromCategory('Buttermilk'), ProductLine.buttermilk);
      expect(ProductLine.fromCategory('Ghee'), ProductLine.ghee);
      expect(ProductLine.milk.usesSkyAccent, isTrue);
      expect(ProductLine.buttermilk.usesSkyAccent, isTrue);
      expect(ProductLine.ghee.usesSkyAccent, isFalse);
      expect(ProductLine.paneer.usesSkyAccent, isFalse);
    });

    test('packLabel', () {
      Product p(String uom, double size) =>
          Product(id: 1, sku: 's', name: 'n', uom: uom, packSize: size);
      expect(p('litre', 0.5).packLabel, '500 ml');
      expect(p('litre', 1).packLabel, '1 L');
      expect(p('kg', 0.2).packLabel, '200 g');
      expect(p('piece', 1).packLabel, '1 piece');
    });
  });

  group('DrsEnv', () {
    test('defaults to dev with the emulator base URL and no keys', () {
      final env = DrsEnv.fromEnvironment();
      expect(env.flavor, DrsFlavor.dev);
      expect(env.apiBaseUrl, DrsEnv.defaultDevBaseUrl);
      expect(env.hasRazorpay, isFalse);
      expect(env.validate(), isEmpty);
    });

    test('prod requires https', () {
      const env = DrsEnv(flavor: DrsFlavor.prod, apiBaseUrl: 'http://x.in');
      expect(env.validate(), isNotEmpty);
      expect(env.allowDevOtpHint, isFalse);
    });
  });
}
