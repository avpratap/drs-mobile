import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';
import 'package:drs_ui/drs_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/application/auth_controller.dart';
import '../../common/async_views.dart';
import '../application/account_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    return DrsScaffold(
      appBar: const DrsAppBar(title: 'Your profile'),
      body: AsyncBody(
        value: profile,
        onRetry: () => ref.invalidate(profileProvider),
        errorTitle: "Couldn't load your profile",
        builder: (p) => _ProfileForm(profile: p),
      ),
    );
  }
}

class _ProfileForm extends HookConsumerWidget {
  const _ProfileForm({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useMemoized(GlobalKey<FormState>.new);
    final fullName = useTextEditingController(text: profile.fullName ?? '');
    final display = useTextEditingController(text: profile.displayName ?? '');
    final email = useTextEditingController(text: profile.email ?? '');
    final emailText = useValueListenable(email).text.trim();
    final busy = useState(false);
    final error = useState<String?>(null);
    final theme = Theme.of(context);
    final emailChanged = emailText != (profile.email ?? '');

    Future<void> save() async {
      if (!form.currentState!.validate()) return;
      String? changed(TextEditingController c, String? was) =>
          c.text.trim() == (was ?? '') ? null : c.text.trim();
      busy.value = true;
      error.value = null;
      try {
        await ref
            .read(accountRepositoryProvider)
            .updateProfile(
              fullName: changed(fullName, profile.fullName),
              displayName: changed(display, profile.displayName),
              email: changed(email, profile.email),
            );
        ref.invalidate(profileProvider);
        // Greeting / account card use the auth account.
        await ref.read(authControllerProvider.notifier).reloadAccount();
        if (context.mounted) showSnack(context, 'Profile saved');
      } on DrsApiError catch (e) {
        error.value = e.message;
      } finally {
        if (context.mounted) busy.value = false;
      }
    }

    const gap = SizedBox(height: DrsSpacing.sm);
    return Form(
      key: form,
      child: ListView(
        padding: const EdgeInsets.all(DrsSpacing.md),
        children: [
          DrsSection(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.onPrimaryContainer,
                  child: const Icon(Icons.person, size: 28),
                ),
                const SizedBox(width: DrsSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Mobile number', style: theme.textTheme.labelMedium),
                      Text(
                        profile.maskedPhone,
                        style: theme.textTheme.titleMedium,
                      ),
                      Text(
                        'Your sign-in number can’t be changed here.',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: DrsSpacing.md),
          TextFormField(
            controller: fullName,
            decoration: const InputDecoration(labelText: 'Full name'),
            autofillHints: const [AutofillHints.name],
            textInputAction: TextInputAction.next,
            maxLength: 255,
          ),
          gap,
          TextFormField(
            controller: display,
            decoration: const InputDecoration(
              labelText: 'What should we call you? (optional)',
              hintText: 'e.g. Asha',
            ),
            textInputAction: TextInputAction.next,
            maxLength: 120,
          ),
          gap,
          TextFormField(
            controller: email,
            decoration: InputDecoration(
              labelText: 'Email (optional)',
              suffixIcon: emailText.isEmpty || emailChanged
                  ? null
                  : Padding(
                      padding: const EdgeInsets.all(DrsSpacing.xs),
                      child: DrsStatusChip(
                        label: profile.emailVerified
                            ? 'Verified'
                            : 'Not verified',
                        tone: profile.emailVerified
                            ? DrsTone.positive
                            : DrsTone.warning,
                      ),
                    ),
              helperText: emailChanged && emailText.isNotEmpty
                  ? 'You’ll need to verify the new address.'
                  : 'Used for invoices and receipts.',
            ),
            keyboardType: TextInputType.emailAddress,
            autofillHints: const [AutofillHints.email],
            validator: (v) =>
                (v == null || v.trim().isEmpty || isPlausibleEmail(v))
                ? null
                : 'Enter a valid email address',
          ),
          if (error.value != null) ...[
            gap,
            Text(
              error.value!,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ],
          const SizedBox(height: DrsSpacing.lg),
          DrsButton(
            label: 'Save',
            expand: true,
            isLoading: busy.value,
            onPressed: save,
          ),
        ],
      ),
    );
  }
}
