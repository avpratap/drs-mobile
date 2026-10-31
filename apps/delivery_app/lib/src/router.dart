import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth/rider_auth.dart';
import 'features/about/about_screens.dart';
import 'features/login_screen.dart';
import 'features/map/map_screen.dart';
import 'features/route/today_screen.dart';
import 'features/stop/deliver_screen.dart';
import 'features/stop/stop_detail_screen.dart';
import 'routes.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // `loaded` distinguishes "still restoring" from "signed out".
  final auth = ValueNotifier<({bool loaded, Account? rider})>((
    loaded: false,
    rider: null,
  ));
  ref.listen(riderAuthProvider, (_, next) {
    if (!next.isLoading || next.hasValue) {
      auth.value = (loaded: true, rider: next.value);
    }
  }, fireImmediately: true);

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (_, state) {
      final loc = state.matchedLocation;
      final a = auth.value;
      if (!a.loaded) return loc == Routes.splash ? null : Routes.splash;
      if (a.rider == null) return loc == Routes.login ? null : Routes.login;
      return loc.startsWith(Routes.today) ? null : Routes.today;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (_, _) =>
            const Scaffold(body: Center(child: DrsLogo(size: 56))),
      ),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: Routes.today,
        builder: (_, _) => const TodayScreen(),
        routes: [
          GoRoute(path: 'map', builder: (_, _) => const MapScreen()),
          GoRoute(
            path: 'about',
            builder: (_, _) => const AboutScreen(),
            routes: [
              GoRoute(
                path: 'privacy',
                builder: (_, _) => const PrivacyNoticeScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'stop/:id',
            builder: (_, s) =>
                StopDetailScreen(orderId: int.parse(s.pathParameters['id']!)),
            routes: [
              GoRoute(
                path: 'deliver',
                builder: (_, s) =>
                    DeliverScreen(orderId: int.parse(s.pathParameters['id']!)),
              ),
            ],
          ),
        ],
      ),
    ],
  );
  ref.onDispose(() {
    router.dispose();
    auth.dispose();
  });
  return router;
}
