import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/milestracks_card.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _publicProfile = true;
  bool _leaderboards = true;
  bool _reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final language = ref.watch(languageControllerProvider);
    final profile = ref.watch(currentUserProvider);
    final tokens = context.milestracksTokens;
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F8F5),
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 76,
        leadingWidth: 70,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: IconButton(
            tooltip: strings.settingsBack,
            onPressed: () => context.go('/profile'),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(
              backgroundColor: tokens.surface,
              shape: const CircleBorder(
                side: BorderSide(color: Color(0xFFE2E6E0)),
              ),
              minimumSize: const Size(48, 48),
            ),
          ),
        ),
        titleSpacing: 8,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              strings.appBrand,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              strings.settingsTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 30),
              children: <Widget>[
                _GroupLabel(strings.settingsAccount.toUpperCase()),
                _SettingsGroup(
                  children: <Widget>[
                    _SettingsRow(
                      title: strings.settingsEmail,
                      subtitle:
                          '${profile.value?.email ?? strings.settingsAccountLoading} · ${strings.profileNotVerified}',
                      trailing: Text(
                        strings.settingsResend,
                        style: _actionStyle(context),
                      ),
                      onTap: () => _toast(strings.settingsResendUnavailable),
                    ),
                    _SettingsRow(
                      title: strings.settingsTimezone,
                      subtitle: 'Asia/Jakarta',
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                    _SettingsRow(
                      title: strings.settingsUnits,
                      subtitle: strings.settingsMetric,
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {},
                    ),
                  ],
                ),
                _GroupLabel(strings.settingsPrivacy.toUpperCase()),
                _SettingsGroup(
                  children: <Widget>[
                    _SettingsRow(
                      title: strings.settingsShareProfile,
                      trailing: Switch(
                        value: _publicProfile,
                        activeTrackColor: tokens.success,
                        onChanged: (value) =>
                            setState(() => _publicProfile = value),
                      ),
                      onTap: () =>
                          setState(() => _publicProfile = !_publicProfile),
                    ),
                    _SettingsRow(
                      title: strings.settingsShowLeague,
                      trailing: Switch(
                        value: _leaderboards,
                        activeTrackColor: tokens.success,
                        onChanged: (value) =>
                            setState(() => _leaderboards = value),
                      ),
                      onTap: () =>
                          setState(() => _leaderboards = !_leaderboards),
                    ),
                    _SettingsRow(
                      title: strings.settingsReduceMotion,
                      subtitle: strings.settingsDevicePreference,
                      trailing: Switch(
                        value: _reduceMotion,
                        activeTrackColor: tokens.success,
                        onChanged: (value) =>
                            setState(() => _reduceMotion = value),
                      ),
                      onTap: () =>
                          setState(() => _reduceMotion = !_reduceMotion),
                    ),
                  ],
                ),
                _GroupLabel(strings.settingsLanguage.toUpperCase()),
                _SettingsGroup(
                  children: <Widget>[
                    _SettingsRow(
                      title: strings.settingsDisplayLanguage,
                      subtitle: language.languageCode == 'id'
                          ? strings.languageIndonesian
                          : strings.languageEnglish,
                      trailing: Text(
                        strings.settingsCurrent,
                        style: _actionStyle(context),
                      ),
                      onTap: () =>
                          _chooseLanguage(context, ref, language.languageCode),
                    ),
                  ],
                ),
                _GroupLabel(strings.settingsPermissions.toUpperCase()),
                _SettingsGroup(
                  children: <Widget>[
                    _SettingsRow(
                      title: strings.settingsGps,
                      subtitle: strings.settingsPermissionUnknown,
                      trailing: Text(
                        strings.settingsOpen,
                        style: _actionStyle(context),
                      ),
                      onTap: () =>
                          _toast(strings.settingsPermissionUnavailable),
                    ),
                    _SettingsRow(
                      title: strings.settingsNotifications,
                      subtitle: strings.settingsPermissionUnknown,
                      trailing: Text(
                        strings.settingsOpen,
                        style: _actionStyle(context),
                      ),
                      onTap: () =>
                          _toast(strings.settingsPermissionUnavailable),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 12, 4, 16),
                  child: Text(
                    strings.settingsLocalNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: () => _confirmSignOut(context, ref),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF293B2F),
                    ),
                    child: Text(strings.settingsSignOut),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: FilledButton.icon(
                    onPressed: () => _toast(strings.settingsDeleteUnavailable),
                    icon: const Icon(Icons.delete_outline),
                    label: Text(strings.settingsDeleteAccount),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFC94D49),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle? _actionStyle(BuildContext context) => Theme.of(context)
      .textTheme
      .labelSmall
      ?.copyWith(
        color: context.milestracksTokens.success,
        fontWeight: FontWeight.w700,
      );

  void _toast(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  Future<void> _chooseLanguage(
    BuildContext context,
    WidgetRef ref,
    String current,
  ) async {
    final strings = AppLocalizations.of(context)!;
    final selected = await showDialog<String>(
      context: context,
      builder: (dialogContext) => SimpleDialog(
        title: Text(strings.settingsDisplayLanguage),
        children: <Widget>[
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'en'),
            child: Text(strings.languageEnglish),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(dialogContext, 'id'),
            child: Text(strings.languageIndonesian),
          ),
        ],
      ),
    );
    if (selected == null || selected == current) return;
    try {
      await ref.read(languageControllerProvider.notifier).setLanguage(selected);
    } on Object {
      if (context.mounted) {
        _toast(AppLocalizations.of(context)!.settingsSaveFailed);
      }
    }
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final strings = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(strings.settingsSignOut),
        content: Text(strings.settingsSignOutConfirm),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(strings.runCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(strings.settingsSignOut),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(sessionControllerProvider.notifier).signOut();
    if (context.mounted) context.go('/welcome');
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(10, 19, 10, 8),
    child: Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        letterSpacing: 1,
        color: context.milestracksTokens.textMuted,
        fontWeight: FontWeight.w800,
      ),
    ),
  );
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => MilestracksCard(
    padding: EdgeInsets.zero,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: <Widget>[
          for (var index = 0; index < children.length; index++) ...<Widget>[
            children[index],
            if (index < children.length - 1)
              Divider(
                height: 1,
                indent: 13,
                endIndent: 0,
                color: context.milestracksTokens.hairline,
              ),
          ],
        ],
      ),
    ),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Semantics(
    button: onTap != null,
    child: InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.labelLarge),
                    if (subtitle case final subtitleText?)
                      Text(
                        subtitleText,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                  ],
                ),
              ),
              ?trailing,
            ],
          ),
        ),
      ),
    ),
  );
}
