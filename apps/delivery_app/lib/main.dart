import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'src/app.dart';
import 'src/core/push.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      retry: (_, _) => null,
      overrides: pushOverrides(),
      child: const DeliveryApp(),
    ),
  );
}
