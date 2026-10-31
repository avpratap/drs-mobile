import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/account/presentation/account_screen.dart';
import '../features/account/presentation/addresses_screen.dart';
import '../features/account/presentation/notification_prefs_screen.dart';
import '../features/account/presentation/profile_screen.dart';
import '../features/auth/application/auth_controller.dart';
import '../features/auth/presentation/sign_in_screen.dart';
import '../features/cart/presentation/cart_screen.dart';
import '../features/catalogue/presentation/home_screen.dart';
import '../features/catalogue/presentation/product_detail_screen.dart';
import '../features/catalogue/presentation/shop_screen.dart';
import '../features/checkout/presentation/address_form_screen.dart';
import '../features/checkout/presentation/checkout_screen.dart';
import '../features/orders/presentation/order_detail_screen.dart';
import '../features/orders/presentation/orders_screen.dart';
import '../features/reviews/presentation/review_editor_screen.dart';
import '../features/reviews/presentation/reviews_screen.dart';
import '../features/shell/home_shell.dart';
import '../features/shell/splash_screen.dart';
import '../features/subscriptions/presentation/subscribe_browse_screen.dart';
import '../features/subscriptions/presentation/subscribe_product_screen.dart';
import '../features/subscriptions/presentation/subscriptions_screen.dart';
import '../features/wallet/presentation/wallet_screen.dart';
import 'routes.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  // Bridge Riverpod auth state → go_router refresh.
  final auth = ValueNotifier<AuthState?>(null);
  ref.listen(
    authControllerProvider,
    (_, next) => auth.value = next.value,
    fireImmediately: true,
  );

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: auth,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onAuthRoute = loc.startsWith(Routes.signIn);
      return switch (auth.value) {
        null => loc == Routes.splash ? null : Routes.splash,
        SignedOut() => onAuthRoute ? null : Routes.signIn,
        SignedIn() =>
          (onAuthRoute || loc == Routes.splash) ? Routes.home : null,
      };
    },
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashScreen()),
      GoRoute(path: Routes.signIn, builder: (_, _) => const SignInScreen()),
      GoRoute(
        path: '/product/:id',
        builder: (_, s) =>
            ProductDetailScreen(productId: int.parse(s.pathParameters['id']!)),
        routes: [
          GoRoute(
            path: 'reviews',
            builder: (_, s) =>
                ReviewsScreen(productId: int.parse(s.pathParameters['id']!)),
          ),
          GoRoute(
            path: 'review',
            builder: (_, s) => ReviewEditorScreen(
              productId: int.parse(s.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.cart,
        builder: (_, _) => const CartScreen(),
        routes: [
          GoRoute(path: 'checkout', builder: (_, _) => const CheckoutScreen()),
        ],
      ),
      GoRoute(
        path: Routes.payOrder,
        redirect: (_, s) => s.extra is Order ? null : Routes.orders,
        builder: (_, s) => CheckoutScreen(payOrder: s.extra! as Order),
      ),
      GoRoute(
        path: Routes.newAddress,
        builder: (_, _) => const AddressFormScreen(),
      ),
      GoRoute(
        path: Routes.editAddress,
        redirect: (_, s) => s.extra is Address ? null : Routes.addresses,
        builder: (_, s) => AddressFormScreen(initial: s.extra! as Address),
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => HomeShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.home, builder: (_, _) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(path: Routes.shop, builder: (_, _) => const ShopScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.subscriptions,
                builder: (_, _) => const SubscriptionsScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (_, _) => const SubscribeBrowseScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => SubscribeProductScreen(
                          productId: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.account,
                builder: (_, _) => const AccountScreen(),
                routes: [
                  GoRoute(
                    path: 'orders',
                    builder: (_, _) => const OrdersScreen(),
                    routes: [
                      GoRoute(
                        path: ':id',
                        builder: (_, s) => OrderDetailScreen(
                          orderId: int.parse(s.pathParameters['id']!),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'wallet',
                    builder: (_, _) => const WalletScreen(),
                  ),
                  GoRoute(
                    path: 'addresses',
                    builder: (_, _) => const AddressesScreen(),
                  ),
                  GoRoute(
                    path: 'profile',
                    builder: (_, _) => const ProfileScreen(),
                  ),
                  GoRoute(
                    path: 'notifications',
                    builder: (_, _) => const NotificationPrefsScreen(),
                  ),
                ],
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
