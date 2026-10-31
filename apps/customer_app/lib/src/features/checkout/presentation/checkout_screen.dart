import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routing/routes.dart';
import '../../cart/application/cart_providers.dart';
import '../../catalogue/application/product_detail_provider.dart';
import '../../common/async_views.dart';
import '../application/checkout_controller.dart';
import 'address_picker.dart';

/// Address → review → place order → pay, and the payment outcome.
class CheckoutScreen extends HookConsumerWidget {
  const CheckoutScreen({super.key, this.payOrder});

  /// When set, skip placing a new order and pay this existing unpaid order
  /// (e.g. "Pay now" from order detail).
  final Order? payOrder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkoutControllerProvider);
    final controller = ref.read(checkoutControllerProvider.notifier);

    useEffect(() {
      if (payOrder != null) {
        Future.microtask(() => controller.pay(payOrder!));
      }
      return null;
    }, const []);

    // Leaving mid-payment is safe (the order stays in Orders) but warn on
    // the busy step so a back-swipe doesn't look like a cancel.
    final busy = state is CheckoutBusy;
    return PopScope(
      canPop: !busy,
      child: DrsScaffold(
        appBar: DrsAppBar(title: payOrder == null ? 'Checkout' : 'Payment'),
        body: switch (state) {
          CheckoutBusy(:final message) => DrsLoading(message: message),
          CheckoutTestPayment(:final order) => _TestPayment(order: order),
          CheckoutPaid(:final order) => _Outcome.paid(order),
          CheckoutPaymentFailed(:final order, :final message) =>
            _Outcome.failed(order, message),
          CheckoutPaymentPending(:final order, :final message) =>
            _Outcome.pending(order, message),
          CheckoutIdle() || CheckoutError() =>
            payOrder != null && state is CheckoutIdle
                ? const DrsLoading()
                : _Review(error: state is CheckoutError ? state.message : null),
        },
      ),
    );
  }
}

class _Review extends HookConsumerWidget {
  const _Review({this.error});

  final String? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    final addresses = ref.watch(addressesProvider);
    final chosen = useState<Address?>(null);
    final address =
        chosen.value ??
        addresses.value?.where((a) => a.isDefault).firstOrNull ??
        addresses.value?.firstOrNull;
    final quote = ref.watch(cartQuoteProvider(pincode: address?.pincode));
    final index = ref.watch(productIndexProvider);
    final theme = Theme.of(context);

    return AsyncBody(
      value: cart,
      onRetry: () => ref.invalidate(cartControllerProvider),
      builder: (c) {
        if (c.isEmpty) {
          return DrsEmptyState(
            icon: Icons.shopping_bag_outlined,
            title: 'Your cart is empty',
            actionLabel: 'Browse the shop',
            onAction: () => context.go(Routes.shop),
          );
        }
        final q = quote.value;
        final notServiceable = q?.serviceable == false;
        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(DrsSpacing.md),
                children: [
                  if (error != null) ...[
                    MaterialBanner(
                      backgroundColor: theme.colorScheme.errorContainer,
                      content: Text(error!),
                      actions: const [SizedBox.shrink()],
                    ),
                    const SizedBox(height: DrsSpacing.sm),
                  ],
                  DrsSection(
                    title: 'Deliver to',
                    child: AddressPicker(
                      selected: address,
                      onSelected: (a) => chosen.value = a,
                    ),
                  ),
                  const SizedBox(height: DrsSpacing.sm),
                  DrsSection(
                    title: 'Order summary',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final l in c.lines)
                          DrsSummaryRow(
                            label:
                                '${index[l.productId]?.name ?? 'Item #${l.productId}'}'
                                ' · ${formatQty(l.qty, index[l.productId]?.uom ?? 'piece')}',
                            value: l.lineTotal.format(compact: false),
                          ),
                        const Divider(height: DrsSpacing.lg),
                        DrsTotals(
                          subtotal: q?.subtotal ?? c.subtotal,
                          discount: q?.discount,
                          shipping: q?.shipping,
                          total: q?.total ?? c.subtotal,
                          gstIncluded: q?.taxTotal,
                        ),
                        if (q?.etaDays != null)
                          Text(
                            'Estimated delivery in ${q!.etaDays} day(s)',
                            style: theme.textTheme.bodySmall,
                          ),
                        if (notServiceable)
                          Padding(
                            padding: const EdgeInsets.only(top: DrsSpacing.xs),
                            child: Text(
                              "We don't deliver to this PIN code yet.",
                              style: TextStyle(color: theme.colorScheme.error),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Material(
              color: theme.colorScheme.surfaceContainerLow,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.all(DrsSpacing.md),
                  child: DrsButton(
                    label:
                        'Place order & pay · '
                        '${(q?.total ?? c.subtotal).format(compact: false)}',
                    expand: true,
                    onPressed: address == null || notServiceable
                        ? null
                        : () => ref
                              .read(checkoutControllerProvider.notifier)
                              .placeOrderAndPay(address, c),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Shown only on non-prod builds talking to a backend without Razorpay keys.
class _TestPayment extends ConsumerWidget {
  const _TestPayment({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(checkoutControllerProvider.notifier);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DrsSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Icon(Icons.science_outlined, size: 48),
          const SizedBox(height: DrsSpacing.sm),
          Text(
            'Test payment',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: DrsSpacing.xs),
          Text(
            'No Razorpay key is configured, so this dev build simulates the '
            'gateway against the backend stub. Order ${order.orderNo} · '
            '${order.total.format(compact: false)}',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DrsSpacing.lg),
          DrsButton(
            label: 'Simulate success',
            onPressed: () => c.completeTestPayment(TestPaymentOutcome.success),
          ),
          const SizedBox(height: DrsSpacing.xs),
          DrsButton.secondary(
            label: 'Simulate failure',
            onPressed: () => c.completeTestPayment(TestPaymentOutcome.failure),
          ),
          const SizedBox(height: DrsSpacing.xs),
          DrsButton(
            label: 'Simulate pending (UPI app)',
            variant: DrsButtonVariant.text,
            onPressed: () => c.completeTestPayment(TestPaymentOutcome.pending),
          ),
        ],
      ),
    );
  }
}

enum _Kind { paid, failed, pending }

class _Outcome extends ConsumerWidget {
  const _Outcome.paid(this.order) : kind = _Kind.paid, message = null;
  const _Outcome.failed(this.order, String this.message) : kind = _Kind.failed;
  const _Outcome.pending(this.order, String this.message)
    : kind = _Kind.pending;

  final Order order;
  final _Kind kind;
  final String? message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.read(checkoutControllerProvider.notifier);
    final theme = Theme.of(context);
    final (icon, color, title) = switch (kind) {
      _Kind.paid => (
        Icons.check_circle,
        theme.colorScheme.primary,
        'Order placed',
      ),
      _Kind.failed => (
        Icons.error_outline,
        theme.colorScheme.error,
        'Payment not completed',
      ),
      _Kind.pending => (
        Icons.hourglass_top,
        DrsColors.of(context).warning,
        'Payment pending',
      ),
    };
    void viewOrder() {
      c.reset();
      context.go(Routes.order(order.id));
    }

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(DrsSpacing.lg),
        child: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(icon, size: 72, color: color),
              const SizedBox(height: DrsSpacing.md),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: DrsSpacing.xs),
              Text(
                message ??
                    'Thank you! ${order.orderNo} is confirmed. '
                        "We'll deliver it fresh.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: DrsSpacing.md),
              DrsSection(
                child: Column(
                  children: [
                    DrsSummaryRow(label: 'Order', value: order.orderNo),
                    DrsSummaryRow(
                      label: 'Amount',
                      value: order.total.format(compact: false),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: DrsSpacing.lg),
              switch (kind) {
                _Kind.paid => DrsButton(
                  label: 'View order',
                  onPressed: viewOrder,
                ),
                _Kind.failed => DrsButton(
                  label: 'Try payment again',
                  onPressed: () => c.pay(order),
                ),
                _Kind.pending => DrsButton(
                  label: 'Check status',
                  onPressed: () => c.refreshStatus(order),
                ),
              },
              if (kind != _Kind.paid) ...[
                const SizedBox(height: DrsSpacing.xs),
                DrsButton.secondary(label: 'View order', onPressed: viewOrder),
              ],
              DrsButton(
                label: 'Continue shopping',
                variant: DrsButtonVariant.text,
                onPressed: () {
                  c.reset();
                  context.go(Routes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
