import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      // Retries are explicit (pull-to-refresh / "Try again") so an offline
      // device doesn't spin in the background.
      retry: (_, _) => null,
      child: const CustomerApp(),
    ),
  );
}
