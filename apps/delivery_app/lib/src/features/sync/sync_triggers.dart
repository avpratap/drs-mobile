import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/providers.dart';
import 'sync_controller.dart';

/// Syncs queued actions when connectivity returns, when the app resumes,
/// and every minute while open. Disabled via [autoSyncProvider] in tests.
class SyncTriggers extends ConsumerStatefulWidget {
  const SyncTriggers({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<SyncTriggers> createState() => _SyncTriggersState();
}

class _SyncTriggersState extends ConsumerState<SyncTriggers> {
  StreamSubscription<List<ConnectivityResult>>? _conn;
  Timer? _timer;
  AppLifecycleListener? _lifecycle;

  void _sync() =>
      unawaited(ref.read(syncControllerProvider.notifier).syncNow());

  @override
  void initState() {
    super.initState();
    if (!ref.read(autoSyncProvider)) return;
    _lifecycle = AppLifecycleListener(onResume: _sync);
    _timer = Timer.periodic(const Duration(minutes: 1), (_) => _sync());
    try {
      _conn = Connectivity().onConnectivityChanged.listen((r) {
        if (!r.contains(ConnectivityResult.none)) _sync();
      });
    } on Object {
      // No connectivity plugin (e.g. tests): timer + resume still apply.
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _sync());
  }

  @override
  void dispose() {
    _conn?.cancel();
    _timer?.cancel();
    _lifecycle?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
