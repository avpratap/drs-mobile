import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../routes.dart';
import '../common.dart';
import '../route/route_providers.dart';
import 'stops_map.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(routeViewProvider);
    return DrsScaffold(
      maxContentWidth: double.infinity,
      appBar: const DrsAppBar(title: "Today's route"),
      body: switch (view) {
        AsyncValue(:final value?) => StopsMap(
          stops: value.effectiveStops,
          onSelect: (s) => context.push(Routes.stop(s.orderId)),
        ),
        AsyncValue(:final error?) => DrsEmptyState.error(
          title: "Couldn't load the route",
          message: errorMessage(error),
          onAction: () => ref.invalidate(routeProvider),
        ),
        _ => const DrsLoading(),
      },
    );
  }
}
