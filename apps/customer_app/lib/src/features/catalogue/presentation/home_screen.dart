import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/push.dart';
import '../../../routing/routes.dart';
import '../../auth/application/auth_controller.dart';
import '../../cart/presentation/cart_button.dart';
import 'catalogue_view.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  static String _greeting(DateTime now) => switch (now.hour) {
    < 12 => 'Good morning',
    < 17 => 'Good afternoon',
    _ => 'Good evening',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider).value;
    final account = auth is SignedIn ? auth.account : null;
    final theme = Theme.of(context);

    return DrsScaffold(
      appBar: const DrsAppBar(actions: [CartAction()]),
      maxContentWidth: DrsSpacing.maxWideContentWidth,
      body: CatalogueView(
        builder: (context, snapshot) {
          // Milk & buttermilk first: the daily-essentials line.
          final featured = [
            ...snapshot.products.where((p) => p.line.usesSkyAccent),
            ...snapshot.products.where((p) => !p.line.usesSkyAccent),
          ].take(6).toList();
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  DrsSpacing.md,
                  DrsSpacing.md,
                  DrsSpacing.md,
                  DrsSpacing.xs,
                ),
                sliver: SliverList.list(
                  children: [
                    Text(
                      '${_greeting(DateTime.now())}, '
                      "${account?.greetingName ?? 'there'}",
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: DrsSpacing.md),
                    const NotificationsOptInCard(),
                    const _HeroCard(),
                    const SizedBox(height: DrsSpacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Today's essentials",
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.go(Routes.shop),
                          child: const Text('See all'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: DrsSpacing.md),
                sliver: DrsAdaptiveSliverList(
                  itemCount: featured.length,
                  itemBuilder: (_, i) => ProductTile(product: featured[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onPrimary;
    return Card(
      color: theme.colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DrsRadius.lg),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DrsSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fresh from the farm,\nevery morning.',
              style: theme.textTheme.headlineSmall?.copyWith(color: on),
            ),
            const SizedBox(height: DrsSpacing.xs),
            Text(
              'Milk, ghee, curd, paneer and buttermilk — delivered before '
              'your day begins.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: on.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: DrsSpacing.md),
            // Gold, used sparingly: the single hero accent.
            Container(height: 3, width: 48, color: theme.colorScheme.tertiary),
          ],
        ),
      ),
    );
  }
}
