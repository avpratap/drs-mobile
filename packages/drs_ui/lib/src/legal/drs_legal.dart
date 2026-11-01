import 'package:drs_core/drs_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/drs_spacing.dart';
import '../widgets/drs_app_bar.dart';
import '../widgets/drs_logo.dart';
import '../widgets/drs_scaffold.dart';

/// What the About screen shows about this build. Nothing secret: version,
/// flavor and which backend the app talks to.
@immutable
class DrsAppInfo {
  const DrsAppInfo({
    required this.appName,
    required this.version,
    required this.buildNumber,
    required this.env,
  });

  /// Reads the version from the platform (pubspec `version:`).
  static Future<DrsAppInfo> load({
    required String appName,
    required DrsEnv env,
  }) async {
    final info = await PackageInfo.fromPlatform();
    return DrsAppInfo(
      appName: appName,
      version: info.version,
      buildNumber: info.buildNumber,
      env: env,
    );
  }

  final String appName;
  final String version;
  final String buildNumber;
  final DrsEnv env;

  String get versionLabel =>
      buildNumber.isEmpty ? version : '$version ($buildNumber)';

  /// e.g. "Live server", "Local server (dev)", "staging.example.in".
  String get serverLabel => switch (env.backend) {
    DrsBackend.live => 'Live server',
    DrsBackend.dev => 'Local development server',
    DrsBackend.custom => Uri.tryParse(env.apiBaseUrl)?.host ?? env.apiBaseUrl,
  };
}

/// Adds the bundled fonts' SIL Open Font Licences to the licences page.
/// Call once from `main()`.
void registerDrsLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (pkg, file) in [
      ('Poppins font', 'OFL-Poppins.txt'),
      ('Montserrat font', 'OFL-Montserrat.txt'),
    ]) {
      final text = await rootBundle.loadString(
        'packages/drs_ui/assets/fonts/$file',
      );
      yield LicenseEntryWithLineBreaks([pkg], text);
    }
  });
}

/// Opens [url] outside the app; returns false if nothing could handle it.
Future<bool> drsOpenExternal(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  try {
    return await launchUrl(uri, mode: LaunchMode.externalApplication);
  } on PlatformException {
    return false;
  }
}

/// About: app identity, version, build details, and links to the privacy
/// notice and open-source licences.
class DrsAboutView extends StatelessWidget {
  const DrsAboutView({
    required this.info,
    required this.onPrivacyNotice,
    super.key,
    this.tagline,
  });

  final DrsAppInfo info;
  final VoidCallback onPrivacyNotice;
  final String? tagline;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return ListView(
      padding: const EdgeInsets.all(DrsSpacing.md),
      children: [
        const SizedBox(height: DrsSpacing.lg),
        const Center(child: DrsLogo(size: 52)),
        if (tagline case final t?) ...[
          const SizedBox(height: DrsSpacing.xs),
          Center(
            child: Text(
              t,
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.primary,
              ),
            ),
          ),
        ],
        const SizedBox(height: DrsSpacing.md),
        Center(child: Text(info.appName, style: theme.textTheme.titleLarge)),
        const SizedBox(height: DrsSpacing.xxs),
        Center(
          child: Text(
            'Version ${info.versionLabel}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(height: DrsSpacing.lg),
        Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.privacy_tip_outlined),
                title: const Text('Privacy notice'),
                subtitle: const Text('What we collect, why, and your rights'),
                trailing: const Icon(Icons.chevron_right),
                onTap: onPrivacyNotice,
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.description_outlined),
                title: const Text('Open-source licences'),
                subtitle: const Text('Software and fonts this app uses'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: info.appName,
                  applicationVersion: info.versionLabel,
                  applicationIcon: const Padding(
                    padding: EdgeInsets.all(DrsSpacing.sm),
                    child: DrsLogoMark(size: 48),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: DrsSpacing.md),
        // Support details: lets a tester / support agent see which build
        // this is. Not shown as a "debug panel" — just facts.
        Semantics(
          container: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: DrsSpacing.sm),
            child: Text(
              'Build: ${info.env.flavor.name} · ${info.serverLabel}',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(height: DrsSpacing.xs),
        Text(
          '© DRS Dairy. Made in India.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// One part of a privacy notice.
@immutable
class DrsPrivacySection {
  const DrsPrivacySection(this.title, this.points);
  final String title;
  final List<String> points;
}

/// A plain-language privacy notice (Digital Personal Data Protection Act,
/// 2023 — notice under s.5): what is collected and why, who it is shared
/// with, the user's rights and how to exercise them, plus the full policy
/// and grievance contact when configured.
class DrsPrivacyNoticeView extends StatelessWidget {
  const DrsPrivacyNoticeView({
    required this.sections,
    super.key,
    this.policyUrl = '',
    this.grievanceEmail = '',
    this.open = drsOpenExternal,
  });

  final List<DrsPrivacySection> sections;
  final String policyUrl;
  final String grievanceEmail;

  /// Opens a URL; injectable for tests.
  final Future<bool> Function(String url) open;

  static const rights = DrsPrivacySection('Your rights', [
    'Get a summary of the personal data we hold about you and how it is used.',
    'Ask us to correct, complete, update or erase your data (some records, '
        'such as invoices, must be kept as long as the law requires).',
    'Withdraw any consent at any time — as easily as you gave it — for '
        'example by turning notifications or offers off in the app.',
    'Nominate someone to exercise these rights for you.',
    'Raise a grievance with us; if it isn’t resolved, you can complain to '
        'the Data Protection Board of India.',
  ]);

  Future<void> _open(BuildContext context, String url) async {
    final ok = await open(url);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Couldn’t open $url')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final all = [...sections, rights];
    return ListView(
      padding: const EdgeInsets.all(DrsSpacing.md),
      children: [
        Text(
          'We collect only what we need to run your deliveries, and we never '
          'sell your personal data.',
          style: theme.textTheme.bodyLarge,
        ),
        for (final s in all) ...[
          const SizedBox(height: DrsSpacing.lg),
          Semantics(
            header: true,
            child: Text(s.title, style: theme.textTheme.titleMedium),
          ),
          const SizedBox(height: DrsSpacing.xs),
          for (final p in s.points)
            Padding(
              padding: const EdgeInsets.only(bottom: DrsSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ExcludeSemantics(
                    child: Text('•  ', style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Text(p, style: theme.textTheme.bodyMedium)),
                ],
              ),
            ),
        ],
        const SizedBox(height: DrsSpacing.lg),
        Semantics(
          header: true,
          child: Text('Contact', style: theme.textTheme.titleMedium),
        ),
        const SizedBox(height: DrsSpacing.xs),
        if (grievanceEmail.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.mail_outline),
            title: const Text('Grievance officer'),
            subtitle: Text(grievanceEmail),
            onTap: () => _open(context, 'mailto:$grievanceEmail'),
          )
        else
          Text(
            'To exercise these rights or raise a grievance, contact DRS '
            'customer support.',
            style: theme.textTheme.bodyMedium,
          ),
        if (policyUrl.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.open_in_new),
            title: const Text('Read the full privacy policy'),
            onTap: () => _open(context, policyUrl),
          ),
      ],
    );
  }
}

/// Full-screen privacy notice, shared by both apps.
class DrsPrivacyNoticeScreen extends StatelessWidget {
  const DrsPrivacyNoticeScreen({
    required this.sections,
    super.key,
    this.policyUrl = '',
    this.grievanceEmail = '',
  });

  final List<DrsPrivacySection> sections;
  final String policyUrl;
  final String grievanceEmail;

  @override
  Widget build(BuildContext context) => DrsScaffold(
    appBar: const DrsAppBar(title: 'Privacy notice'),
    body: DrsPrivacyNoticeView(
      sections: sections,
      policyUrl: policyUrl,
      grievanceEmail: grievanceEmail,
    ),
  );
}
