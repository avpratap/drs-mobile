import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

/// Cold-start milestones as Timeline events, so they show up in DevTools and
/// `flutter run --profile --trace-startup` next to Flutter's own
/// first-frame events. Nothing is sent anywhere; in debug/profile builds the
/// timings are also printed (no personal data — names and milliseconds).
abstract final class DrsStartupTrace {
  static final _clock = Stopwatch();
  static final _marked = <String>{};

  /// Call first thing in `main()` (after `ensureInitialized`).
  static void begin() {
    _clock
      ..reset()
      ..start();
    _marked.clear();
    SchedulerBinding.instance.addPostFrameCallback((_) => mark('first_frame'));
  }

  /// Records [name] once per launch (e.g. `content_shown`). No-op unless
  /// [begin] ran, so widget tests are unaffected.
  static void mark(String name) {
    if (!_clock.isRunning || !_marked.add(name)) return;
    final ms = _clock.elapsedMilliseconds;
    developer.Timeline.instantSync('drs.$name', arguments: {'ms': ms});
    if (!kReleaseMode) debugPrint('[startup] $name: $ms ms');
  }
}
