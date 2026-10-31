import 'dart:io';

import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../common.dart';
import '../route/route_providers.dart';
import '../sync/sync_controller.dart';
import 'pod_camera.dart';

/// Proof of delivery: confirm items, take a doorstep photo, optional note.
/// Saved on the device first and synced (works offline).
class DeliverScreen extends HookConsumerWidget {
  const DeliverScreen({required this.orderId, super.key});

  final int orderId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final view = ref.watch(routeViewProvider).value?.byOrder(orderId);
    final products = ref.watch(productsProvider).value ?? const {};
    final unchecked = useState<Set<int>>({});
    final photo = useState<String?>(null);
    final note = useTextEditingController();
    final busy = useState(false);
    final theme = Theme.of(context);

    if (view == null || !view.canAct) {
      return const DrsScaffold(
        appBar: DrsAppBar(title: 'Proof of delivery'),
        body: DrsEmptyState(title: 'This stop is already closed'),
      );
    }
    final s = view.stop;
    final anyDelivered = s.lines.any(
      (l) => !unchecked.value.contains(l.productId),
    );
    final canSubmit = anyDelivered && photo.value != null && !busy.value;

    Future<void> capture() async {
      try {
        final path = await ref.read(podCameraProvider).capture();
        if (path != null) photo.value = path;
      } on Object {
        if (context.mounted) {
          showSnack(
            context,
            'Camera unavailable. Check the camera permission.',
          );
        }
      }
    }

    Future<void> submit() async {
      busy.value = true;
      await ref
          .read(syncControllerProvider.notifier)
          .deliver(
            s,
            delivered: {
              for (final l in s.lines)
                l.productId: unchecked.value.contains(l.productId)
                    ? 0
                    : l.qtyPlanned,
            },
            photoPath: photo.value,
            note: note.text,
          );
      if (!context.mounted) return;
      showSnack(context, 'Delivery saved — it will sync automatically.');
      context.go('/today');
    }

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Proof of delivery'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(DrsSpacing.md),
              children: [
                Text(
                  '${s.title} · stop ${s.sequence}',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: DrsSpacing.sm),
                DrsSection(
                  title: 'Delivered items',
                  child: Column(
                    children: [
                      for (final l in s.lines)
                        CheckboxListTile.adaptive(
                          contentPadding: EdgeInsets.zero,
                          value: !unchecked.value.contains(l.productId),
                          onChanged: (v) => unchecked.value = v ?? false
                              ? ({...unchecked.value}..remove(l.productId))
                              : {...unchecked.value, l.productId},
                          title: Text(
                            products[l.productId]?.name ??
                                'Item #${l.productId}',
                          ),
                          subtitle: Text(
                            formatQty(
                              l.qtyPlanned,
                              products[l.productId]?.uom ?? 'piece',
                            ),
                          ),
                        ),
                      if (!anyDelivered)
                        Text(
                          "Nothing delivered? Go back and use \"Couldn't deliver\".",
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: DrsSpacing.sm),
                DrsSection(
                  title: 'Doorstep photo',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (photo.value != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(DrsRadius.md),
                          child: AspectRatio(
                            aspectRatio: 4 / 3,
                            child: Image.file(
                              File(photo.value!),
                              fit: BoxFit.cover,
                              semanticLabel: 'Proof of delivery photo',
                              errorBuilder: (_, _, _) => const Center(
                                child: Icon(Icons.image_outlined, size: 48),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: DrsSpacing.xs),
                      ],
                      DrsButton.secondary(
                        label: photo.value == null
                            ? 'Take photo'
                            : 'Retake photo',
                        icon: Icons.photo_camera_outlined,
                        onPressed: busy.value ? null : capture,
                      ),
                      const SizedBox(height: DrsSpacing.xs),
                      Text(
                        'Required. Photograph the items at the door — avoid faces '
                        'and house numbers where possible.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: DrsSpacing.sm),
                TextField(
                  controller: note,
                  maxLength: 255,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Note (optional)',
                    hintText: 'e.g. Left with security',
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
                  label: 'Confirm delivery',
                  expand: true,
                  isLoading: busy.value,
                  onPressed: canSubmit ? submit : null,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
