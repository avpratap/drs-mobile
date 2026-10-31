import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/auth_controller.dart';

class AccountScreen extends HookConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider).value;
    final account = auth is SignedIn ? auth.account : null;
    final signingOut = useState(false);
    final theme = Theme.of(context);

    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Account'),
      body: RefreshIndicator(
        onRefresh: () =>
            ref.read(authControllerProvider.notifier).reloadAccount(),
        child: ListView(
          padding: const EdgeInsets.all(DrsSpacing.md),
          children: [
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(DrsSpacing.md),
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.person),
                ),
                title: Text(
                  account?.fullName?.trim().isNotEmpty ?? false
                      ? account!.fullName!
                      : 'DRS customer',
                ),
                // Masked even on the user's own screen (shoulder-surfing).
                subtitle: Text(
                  account?.maskedPhone ?? 'Profile unavailable offline',
                ),
              ),
            ),
            const SizedBox(height: DrsSpacing.md),
            const _ComingSoonTile(icon: Icons.receipt_long, title: 'Orders'),
            const _ComingSoonTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Wallet & billing',
            ),
            const _ComingSoonTile(
              icon: Icons.location_on_outlined,
              title: 'Addresses',
            ),
            const _ComingSoonTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy & data',
              subtitle: 'Export or erase your data',
            ),
            const SizedBox(height: DrsSpacing.lg),
            DrsButton.secondary(
              label: 'Sign out',
              icon: Icons.logout,
              expand: true,
              isLoading: signingOut.value,
              onPressed: () async {
                final confirmed = await showDrsConfirmDialog(
                  context,
                  title: 'Sign out?',
                  message: 'You will need a new OTP to sign in again.',
                  confirmLabel: 'Sign out',
                  destructive: true,
                );
                if (!confirmed) return;
                signingOut.value = true;
                await ref.read(authControllerProvider.notifier).signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonTile extends StatelessWidget {
  const _ComingSoonTile({
    required this.icon,
    required this.title,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) => ListTile(
    leading: Icon(icon),
    title: Text(title),
    subtitle: Text(subtitle ?? 'Coming soon'),
    enabled: false,
  );
}
