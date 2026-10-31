import 'package:drs_core/drs_core.dart';
import 'package:flutter/material.dart';

import '../theme/drs_colors.dart';
import '../theme/drs_spacing.dart';
import 'drs_price.dart';

/// Catalogue row. The left accent + image tint use `sky` for the milk /
/// buttermilk line and brand green for everything else.
class DrsProductCard extends StatelessWidget {
  const DrsProductCard({
    required this.product,
    super.key,
    this.onTap,
    this.trailing,
  });

  final Product product;
  final VoidCallback? onTap;

  /// Usually a [DrsQuantityStepper].
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = DrsColors.of(context);
    final accent = brand.accentFor(product.line, theme.colorScheme);
    final tint = product.line.usesSkyAccent
        ? brand.skyContainer
        : theme.colorScheme.primaryContainer;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Padding(
                padding: const EdgeInsets.all(DrsSpacing.sm),
                child: _Thumb(url: product.imageUrl, tint: tint, accent: accent),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: DrsSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.packLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: DrsSpacing.xxs),
                      if (product.fromPrice != null)
                        DrsPrice(amount: product.fromPrice!, isFrom: true)
                      else
                        Text(
                          'Price on request',
                          style: theme.textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.all(DrsSpacing.sm),
                  child: Center(child: trailing),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.url, required this.tint, required this.accent});

  final String? url;
  final Color tint;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final placeholder = Icon(Icons.local_drink_outlined, color: accent, size: 32);
    return ClipRRect(
      borderRadius: BorderRadius.circular(DrsRadius.md),
      child: Container(
        width: 64,
        height: 64,
        color: tint,
        alignment: Alignment.center,
        child: url == null || url!.isEmpty
            ? placeholder
            : Image.network(
                url!,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}
