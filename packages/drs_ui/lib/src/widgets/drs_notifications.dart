import 'package:flutter/material.dart';

import '../notifications/push_platform.dart';
import '../theme/drs_spacing.dart';
import 'drs_button.dart';
import 'drs_toggles.dart';

/// In-app opt-in shown before the OS prompt, with plain-language consent
/// (DPDP): what is sent, why, and how to turn it off.
class DrsNotificationOptIn extends StatelessWidget {
  const DrsNotificationOptIn({
    required this.reasons,
    required this.onAllow,
    required this.onNotNow,
    super.key,
    this.title = 'Get updates on this phone',
    this.busy = false,
  });

  final String title;

  /// What the user will be notified about.
  final List<String> reasons;
  final VoidCallback onAllow;
  final VoidCallback onNotNow;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(DrsSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.notifications_active_outlined,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: DrsSpacing.xs),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: DrsSpacing.xs),
            for (final r in reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text('• $r', style: theme.textTheme.bodyMedium),
              ),
            const SizedBox(height: DrsSpacing.xs),
            Text(
              'We store a notification token for this device only to send '
              'these updates. You can turn it off any time.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: DrsSpacing.sm),
            Wrap(
              spacing: DrsSpacing.xs,
              runSpacing: DrsSpacing.xs,
              alignment: WrapAlignment.end,
              children: [
                DrsButton(
                  label: 'Not now',
                  variant: DrsButtonVariant.text,
                  onPressed: busy ? null : onNotNow,
                ),
                DrsButton(
                  label: 'Allow notifications',
                  isLoading: busy,
                  onPressed: onAllow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Notification on/off switch that explains every state honestly.
class DrsNotificationSettingsTile extends StatelessWidget {
  const DrsNotificationSettingsTile({
    required this.available,
    required this.consent,
    required this.permission,
    required this.onChanged,
    super.key,
  });

  final bool available;
  final bool? consent;
  final PushPermission permission;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final on = consent == true && permission.canReceive;
    final subtitle = !available
        ? 'Not available in this build'
        : consent == true && permission == PushPermission.denied
        ? 'Blocked in system settings — allow notifications for this app '
              'in your phone’s Settings'
        : on
        ? 'On for this device'
        : 'Off';
    return DrsSwitchTile(
      secondary: Icon(
        on
            ? Icons.notifications_active_outlined
            : Icons.notifications_off_outlined,
      ),
      title: const Text('Notifications'),
      subtitle: Text(subtitle),
      value: on,
      onChanged: available ? onChanged : null,
    );
  }
}
