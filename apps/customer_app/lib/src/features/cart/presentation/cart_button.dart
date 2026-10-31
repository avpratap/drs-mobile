import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../application/cart_providers.dart';

/// Header cart action with the live line-count badge.
class CartAction extends ConsumerWidget {
  const CartAction({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => DrsCartButton(
    count: ref.watch(cartCountProvider),
    onPressed: () => context.push(Routes.cart),
  );
}
