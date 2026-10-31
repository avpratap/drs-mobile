import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/cart_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Your cart'),
      body: AsyncBody(
        value: cart,
        onRetry: () => ref.invalidate(cartControllerProvider),
        errorTitle: "Couldn't load your cart",
        builder: (c) => c.isEmpty
            ? DrsEmptyState(
                icon: Icons.shopping_bag_outlined,
                title: 'Your cart is empty',
                message: 'Fresh milk, ghee, curd and paneer are a tap away.',
                actionLabel: 'Browse the shop',
                onAction: () => context.go(Routes.shop),
              )
            : _CartBody(cart: c),
      ),
    );
  }
}

class _CartBody extends ConsumerWidget {
  const _CartBody({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(productIndexProvider);
    final quote = ref.watch(cartQuoteProvider());
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator.adaptive(
            onRefresh: () => ref.read(cartControllerProvider.notifier).reload(),
            child: ListView(
              padding: const EdgeInsets.all(DrsSpacing.md),
              children: [
                for (final line in cart.lines) ...[
                  _CartLineTile(line: line, product: index[line.productId]),
                  const SizedBox(height: DrsSpacing.sm),
                ],
                const SizedBox(height: DrsSpacing.xs),
                DrsSection(
                  title: 'Bill details',
                  child: DrsTotals(
                    subtotal: cart.subtotal,
                    discount: quote.value?.discount,
                    total: quote.value?.total ?? cart.subtotal,
                    gstIncluded: quote.value?.taxTotal,
                  ),
                ),
                const SizedBox(height: DrsSpacing.xs),
                Text(
                  'All prices include GST. The final amount is confirmed at '
                  'checkout.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        _CheckoutBar(total: quote.value?.total ?? cart.subtotal),
      ],
    );
  }
}

class _CartLineTile extends HookConsumerWidget {
  const _CartLineTile({required this.line, required this.product});

  final CartLine line;
  final Product? product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final busy = useState(false);
    final theme = Theme.of(context);
    final packSize = product?.packSize ?? 1;
    final uom = product?.uom ?? 'piece';
    final packs = packsIn(line.qty, packSize);
    final name = product?.name ?? 'Item #${line.productId}';

    Future<void> change(Future<void> Function() op) async {
      busy.value = true;
      await runWithSnack(context, op);
      if (context.mounted) busy.value = false;
    }

    final controller = ref.read(cartControllerProvider.notifier);
    return Dismissible(
      key: ValueKey('cart-line-${line.itemId}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: DrsSpacing.lg),
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(DrsRadius.lg),
        ),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      confirmDismiss: (_) async {
        await change(() => controller.remove(line));
        return false; // the list rebuilds from the server cart
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(DrsSpacing.sm),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: theme.textTheme.titleMedium),
                    Text(
                      '${formatQty(line.qty, uom)} · '
                      '${line.unitPrice.format(compact: false)} / $uom',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: DrsSpacing.xxs),
                    Text(
                      line.lineTotal.format(compact: false),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: DrsSpacing.xs),
              if (busy.value)
                const SizedBox.square(
                  dimension: DrsSpacing.minTapTarget,
                  child: Center(child: CircularProgressIndicator.adaptive()),
                )
              else
                DrsQuantityStepper(
                  value: packs,
                  max: 50,
                  itemLabel: name,
                  onChanged: (v) =>
                      change(() => controller.setPacks(line, v, packSize)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total});

  final Money total;

  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainerLow,
    child: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(DrsSpacing.md),
        child: DrsButton(
          label: 'Checkout · ${total.format(compact: false)}',
          expand: true,
          onPressed: () => context.push(Routes.checkout),
        ),
      ),
    ),
  );
}
