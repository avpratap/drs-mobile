/// Indian mobile number helpers, mirroring the backend's `normalize_phone` +
/// `is_indian_mobile` so the client rejects bad input before a round-trip.
abstract final class IndianPhone {
  static final _nonDigits = RegExp(r'[^\d]');
  static final _mobile = RegExp(r'^[6-9]\d{9}$');

  /// Returns `+91XXXXXXXXXX` or null when [input] is not a valid Indian mobile.
  /// Accepts `98765 43210`, `098765-43210`, `+91 98765 43210`, `919876543210`.
  static String? normalize(String input) {
    var digits = input.replaceAll(_nonDigits, '');
    if (digits.length == 12 && digits.startsWith('91')) {
      digits = digits.substring(2);
    } else if (digits.length == 11 && digits.startsWith('0')) {
      digits = digits.substring(1);
    }
    if (!_mobile.hasMatch(digits)) return null;
    return '+91$digits';
  }

  static bool isValid(String input) => normalize(input) != null;
}
