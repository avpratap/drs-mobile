/// DPDP-friendly redaction helpers. Use these whenever personal data could
/// reach logs, crash reports or analytics.
abstract final class Pii {
  static final _digits = RegExp(r'\d');
  static final _phoneLike = RegExp(r'\+?\d[\d\s-]{8,}\d');
  static final _email = RegExp(r'[\w.+-]+@[\w-]+\.[\w.-]+');
  static final _jwt = RegExp(r'eyJ[\w-]+\.[\w-]+\.[\w-]+');

  /// `+919876543210` → `+91 98•••••210`.
  static String maskPhone(String phone) {
    final d = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (d.length < 6) return '•' * d.length;
    final local = d.length > 10 ? d.substring(d.length - 10) : d;
    final cc = d.length > 10 ? '+${d.substring(0, d.length - 10)} ' : '';
    return '$cc${local.substring(0, 2)}${'•' * (local.length - 5)}'
        '${local.substring(local.length - 3)}';
  }

  /// Scrubs phone numbers, e-mails and JWTs from free text (e.g. an error
  /// message about to be logged).
  static String redact(String text) => text
      .replaceAll(_jwt, '[jwt]')
      .replaceAll(_email, '[email]')
      .replaceAllMapped(
        _phoneLike,
        (m) => m[0]!.replaceAll(_digits, '•'),
      );
}
