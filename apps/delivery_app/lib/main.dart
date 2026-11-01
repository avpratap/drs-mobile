import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';
import 'src/core/push.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DrsStartupTrace.begin();
  registerDrsLicenses();
  runApp(
    ProviderScope(
      retry: (_, _) => null,
      overrides: pushOverrides(),
      child: const DeliveryApp(),
    ),
  );
}
