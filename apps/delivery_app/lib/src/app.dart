import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers.dart';
import 'router.dart';

class DeliveryApp extends ConsumerWidget {
  const DeliveryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final problems = ref.watch(envProvider).validate();
    if (problems.isNotEmpty) {
      return MaterialApp(
        theme: DrsTheme.light,
        home: Scaffold(
          body: DrsEmptyState.error(
            title: 'App misconfigured',
            message: problems.join('\n'),
          ),
        ),
      );
    }
    return MaterialApp.router(
      title: 'DRS Delivery',
      debugShowCheckedModeBanner: false,
      // Same shared brand theme as the customer app.
      theme: DrsTheme.light,
      darkTheme: DrsTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
