import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'core/providers.dart';
import 'core/push.dart';
import 'features/cart/application/cart_providers.dart';
import 'features/catalogue/application/catalogue_providers.dart';
import 'routing/app_router.dart';

class CustomerApp extends ConsumerWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final env = ref.watch(envProvider);
    final problems = env.validate();
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
      title: 'DRS',
      debugShowCheckedModeBanner: false,
      theme: DrsTheme.light,
      darkTheme: DrsTheme.dark,
      // Light is the reference brand experience; dark is opt-in for now.
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(appRouterProvider),
      builder: (context, child) => DrsMedia(
        apiBaseUrl: env.apiBaseUrl,
        enabled: ref.watch(networkImagesProvider),
        child: DrsConnectionStrip(
          online: ref.watch(backendReachableProvider),
          onRetry: () async {
            // The smallest public call answers "reachable?" (the
            // connectivity interceptor updates the strip either way)…
            try {
              await ref
                  .read(drsApiProvider)
                  .getProductsApi()
                  .listProductCategories();
            } on Object {
              // still offline — the strip stays
            }
            // …then refresh what most screens show.
            ref
              ..invalidate(catalogueProvider)
              ..invalidate(cartControllerProvider);
          },
          child: PushBridge(child: child!),
        ),
      ),
    );
  }
}
