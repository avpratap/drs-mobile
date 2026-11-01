import 'dart:math';

/// How long to wait before retrying a queued action after the server was
/// busy or erroring (not for "no connection" — that waits for the network).
///
/// Exponential from [base], capped at [max], with "equal jitter" (50–100% of
/// the step) so a fleet of riders coming back online doesn't retry in
/// lock-step. A server `Retry-After` wins when it is longer.
Duration retryDelay(
  int attempt, {
  Random? random,
  Duration? retryAfter,
  Duration base = const Duration(seconds: 30),
  Duration max = const Duration(minutes: 15),
}) {
  final step = base * pow(2, attempt.clamp(0, 16)).toInt();
  final capped = step > max ? max : step;
  final r = (random ?? Random()).nextDouble(); // 0..1
  final jittered = capped * (0.5 + r / 2);
  if (retryAfter != null && retryAfter > jittered) return retryAfter;
  return jittered;
}

/// Parses an HTTP `Retry-After` (seconds or HTTP-date). Null if absent/bad.
Duration? parseRetryAfter(String? header, {DateTime? now}) {
  if (header == null || header.trim().isEmpty) return null;
  final secs = int.tryParse(header.trim());
  if (secs != null) return secs < 0 ? null : Duration(seconds: secs);
  try {
    final at = HttpDateParser.parse(header.trim());
    final d = at.difference((now ?? DateTime.now()).toUtc());
    return d.isNegative ? Duration.zero : d;
  } on FormatException {
    return null;
  }
}

/// Minimal RFC 7231 IMF-fixdate parser ("Sun, 06 Nov 1994 08:49:37 GMT"),
/// avoiding a dart:io dependency here.
abstract final class HttpDateParser {
  static const _months = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  static DateTime parse(String s) {
    final m = RegExp(
      r'^\w{3}, (\d{2}) (\w{3}) (\d{4}) (\d{2}):(\d{2}):(\d{2}) GMT$',
    ).firstMatch(s);
    final month = m == null ? null : _months[m[2]];
    if (m == null || month == null) throw FormatException('bad date', s);
    return DateTime.utc(
      int.parse(m[3]!),
      month,
      int.parse(m[1]!),
      int.parse(m[4]!),
      int.parse(m[5]!),
      int.parse(m[6]!),
    );
  }
}

/// A saved route older than this is refreshed by the periodic sync tick and
/// called out as possibly out of date.
const routeStaleAfter = Duration(minutes: 15);

bool isStale(DateTime? fetchedAt, DateTime now) =>
    fetchedAt == null || now.difference(fetchedAt) > routeStaleAfter;
