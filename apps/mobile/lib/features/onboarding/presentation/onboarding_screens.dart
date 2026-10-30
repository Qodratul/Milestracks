import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/auth/session_controller.dart';
import 'package:milestracks/core/config/device_timezone.dart';
import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/onboarding/presentation/permission_controller.dart';
import 'package:milestracks/features/onboarding/presentation/readiness_controller.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_button.dart';

class ReadinessScreen extends ConsumerWidget {
  const ReadinessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final answers = ref.watch(readinessAnswersProvider);
    final consent = ref.watch(readinessConsentProvider);
    final questions = <String>[
      strings.readinessQuestionHeart,
      strings.readinessQuestionChest,
      strings.readinessQuestionDizziness,
      strings.readinessQuestionJoint,
      strings.readinessQuestionMedication,
    ];
    final ready = answers.length == questions.length && consent;

    return _OnboardingScaffold(
      step: 1,
      backLabel: strings.authBack,
      onBack: () => context.go('/welcome'),
      trailing: _LanguageMenu(label: strings.languageLabel),
      footer: MilestracksButton(
        onPressed: ready ? () => context.go('/onboarding/permissions') : null,
        primaryBackground: tokens.primary,
        primaryForeground: tokens.surface,
        primaryRadius: tokens.radiusMedium,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(strings.readinessReadyButton),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            strings.readinessEyebrow,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: tokens.primary, letterSpacing: 1.2),
          ),
          SizedBox(height: tokens.space8),
          Text(
            strings.readinessTitle,
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.w800, height: 1.05),
          ),
          SizedBox(height: tokens.space10),
          Text(
            strings.readinessDescription,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: tokens.textSecondary, height: 1.5),
          ),
          SizedBox(height: tokens.space18),
          _ReadinessOverview(
            answered: answers.length,
            title: strings.readinessOverviewTitle,
            detail: strings.readinessOverviewBody,
          ),
          SizedBox(height: tokens.space18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      strings.readinessQuestionHeading,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: tokens.space4),
                    Text(
                      strings.readinessQuestionSubheading,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: tokens.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                strings.readinessCheckCount,
                style: Theme.of(context).textTheme.labelMedium
                    ?.copyWith(color: tokens.textSecondary),
              ),
            ],
          ),
          SizedBox(height: tokens.space8),
          for (var index = 0; index < questions.length; index++)
            _ReadinessQuestion(
              label: questions[index],
              value: answers[index],
              yesLabel: strings.readinessYes,
              noLabel: strings.readinessNo,
              onChanged: (value) => ref
                  .read(readinessAnswersProvider.notifier)
                  .setAnswer(index, value),
            ),
          SizedBox(height: tokens.space14),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: consent,
            onChanged: (value) => ref
                .read(readinessConsentProvider.notifier)
                .setAccepted(value ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              strings.readinessConsent,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            visualDensity: VisualDensity.compact,
          ),
          _HealthNotice(
            title: strings.readinessNoticeTitle,
            body: strings.readinessNoticeBody,
          ),
          SizedBox(height: tokens.space24),
        ],
      ),
    );
  }
}

class PermissionsScreen extends ConsumerStatefulWidget {
  const PermissionsScreen({super.key});

  @override
  ConsumerState<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends ConsumerState<PermissionsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(
        ref.read(permissionControllerProvider.notifier).refreshStatus(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final permission = ref.watch(permissionControllerProvider);
    final values = permission.asData?.value;
    final hasLocation = values?.location ?? false;
    final hasNotifications = values?.notifications ?? false;
    final permissionError = permission.hasError
        ? strings.permissionError
        : null;
    return _OnboardingScaffold(
      step: 2,
      backLabel: strings.authBack,
      onBack: () => context.go('/onboarding/readiness'),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _MascotPermissionNote(
            title: strings.permissionMascotTitle,
            body: strings.permissionMascotBody,
          ),
          MilestracksButton(
            onPressed: hasLocation
                ? () => context.go('/onboarding/finish')
                : null,
            primaryBackground: tokens.primary,
            primaryForeground: tokens.surface,
            primaryRadius: tokens.radiusMedium,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(strings.continueLabel),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 18),
              ],
            ),
          ),
          MilestracksButton(
            variant: MilestracksButtonVariant.text,
            onPressed: hasLocation
                ? () => context.go('/onboarding/finish')
                : null,
            child: Text(strings.permissionSkipNotifications),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            strings.permissionEyebrow,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: tokens.primary, letterSpacing: 1.2),
          ),
          SizedBox(height: tokens.space10),
          Text(
            strings.permissionTitle,
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.w800, height: 1.05),
          ),
          SizedBox(height: tokens.space10),
          Text(
            strings.permissionDescription,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: tokens.textSecondary, height: 1.5),
          ),
          SizedBox(height: tokens.space18),
          _PermissionCard(
            icon: Icons.location_on_outlined,
            title: strings.permissionLocationTitle,
            detail: strings.permissionLocationBody,
            allowed: hasLocation,
            allowLabel: strings.permissionAllow,
            activeLabel: strings.permissionActive,
            semanticLabel: strings.locationPermissionReason,
            onRequest: () => ref
                .read(permissionControllerProvider.notifier)
                .requestLocation(),
            dark: true,
          ),
          _PermissionCard(
            icon: Icons.notifications_active_outlined,
            title: strings.permissionNotificationsTitle,
            detail: strings.permissionNotificationsBody,
            allowed: hasNotifications,
            allowLabel: strings.permissionAllow,
            activeLabel: strings.permissionActive,
            semanticLabel: strings.notificationPermissionReason,
            onRequest: () => ref
                .read(permissionControllerProvider.notifier)
                .requestNotifications(),
          ),
          if (permission.isLoading) ...<Widget>[
            SizedBox(height: tokens.space12),
            const Center(child: CircularProgressIndicator()),
          ],
          if (permissionError != null) ...<Widget>[
            SizedBox(height: tokens.space12),
            Text(
              permissionError,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: tokens.error),
            ),
          ],
        ],
      ),
    );
  }
}

class OnboardingFinishScreen extends ConsumerStatefulWidget {
  const OnboardingFinishScreen({super.key});

  @override
  ConsumerState<OnboardingFinishScreen> createState() =>
      _OnboardingFinishScreenState();
}

class _OnboardingFinishScreenState
    extends ConsumerState<OnboardingFinishScreen> {
  bool _saving = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    return _OnboardingScaffold(
      step: 3,
      backLabel: strings.authBack,
      onBack: () => context.go('/onboarding/permissions'),
      footer: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MilestracksButton(
            onPressed: _saving ? null : _completeOnboarding,
            primaryBackground: tokens.primary,
            primaryForeground: tokens.surface,
            primaryRadius: tokens.radiusMedium,
            child: _saving
                ? const CircularProgressIndicator()
                : Text(strings.continueLabel),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            strings.permissionEyebrow,
            style: Theme.of(context).textTheme.labelMedium
                ?.copyWith(color: tokens.primary, letterSpacing: 1.2),
          ),
          SizedBox(height: tokens.space10),
          Text(
            strings.onboardingFinishTitle,
            style: Theme.of(context).textTheme.headlineLarge
                ?.copyWith(fontWeight: FontWeight.w800, height: 1.05),
          ),
          SizedBox(height: tokens.space10),
          Text(
            strings.onboardingFinishBody,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: tokens.textSecondary, height: 1.5),
          ),
          if (_error != null) ...<Widget>[
            SizedBox(height: tokens.space14),
            Semantics(
              liveRegion: true,
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: tokens.error),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _completeOnboarding() async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final strings = AppLocalizations.of(context)!;
    try {
      final language = ref.read(languageControllerProvider).languageCode;
      final timezone = await DeviceTimezone.getIanaName();
      final response = await ref
          .read(onboardingRepositoryProvider)
          .saveOnboarding(
            OnboardingRequestDto(
              healthDisclaimerAccepted: ref.read(readinessConsentProvider),
              timezone: timezone,
              locale: language,
            ),
          );
      // ASSUMPTION UNCONFIRMED: PRD has no fields/end point for the five answers.
      await ref
          .read(languageControllerProvider.notifier)
          .setLanguage(response.locale, syncServer: false);
      await ref.read(onboardingControllerProvider.notifier).markComplete();
      ref.read(readinessAnswersProvider.notifier).clear();
      ref.read(readinessConsentProvider.notifier).clear();
    } catch (error) {
      if (mounted) setState(() => _error = _errorMessage(error, strings));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _errorMessage(
    Object error,
    AppLocalizations strings,
  ) => switch (error) {
    AppException(kind: AppExceptionKind.validation) => strings.validationError,
    AppException(kind: AppExceptionKind.network) => strings.networkError,
    AppException(kind: AppExceptionKind.timeout) => strings.requestTimedOut,
    AppException(kind: AppExceptionKind.server) => strings.serverError,
    AppException(kind: AppExceptionKind.unauthorized) => strings.sessionExpired,
    AppException(kind: AppExceptionKind.conflict) => strings.conflictError,
    AppException(kind: AppExceptionKind.rateLimit) => strings.rateLimitError,
    _ => strings.unknownError,
  };
}

class _OnboardingScaffold extends StatelessWidget {
  const _OnboardingScaffold({
    required this.step,
    required this.backLabel,
    required this.onBack,
    required this.child,
    required this.footer,
    this.trailing,
  });
  final int step;
  final String backLabel;
  final VoidCallback onBack;
  final Widget child;
  final Widget footer;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned(
              top: 70,
              right: -100,
              child: _OnboardingRouteArt(),
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: tokens.pagePadding),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          tooltip: backLabel,
                          onPressed: onBack,
                          icon: const Icon(Icons.arrow_back),
                          constraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                        ),
                        SizedBox(width: tokens.space8),
                        Expanded(
                          child: Text(
                            strings.onboardingStep(step),
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(color: tokens.textSecondary),
                          ),
                        ),
                        ?trailing,
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: tokens.pagePadding),
                  child: _ProgressBars(step: step),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      tokens.pagePadding,
                      tokens.space24,
                      tokens.pagePadding,
                      tokens.space24,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 430),
                        child: child,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(
                    tokens.pagePadding,
                    tokens.space12,
                    tokens.pagePadding,
                    tokens.space8,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.background.withValues(alpha: .96),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: tokens.shadow.withValues(alpha: .35),
                        blurRadius: tokens.space16,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 430),
                      child: footer,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Row(
      children: List<Widget>.generate(
        3,
        (index) => Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == 2 ? 0 : tokens.space6),
            decoration: BoxDecoration(
              color: index < step ? tokens.primary : tokens.border,
              borderRadius: BorderRadius.circular(tokens.radiusPill),
            ),
          ),
        ),
      ),
    );
  }
}

class _LanguageMenu extends ConsumerWidget {
  const _LanguageMenu({required this.label});
  final String label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final code = ref.watch(languageControllerProvider).languageCode;
    return Semantics(
      label: label,
      button: true,
      child: PopupMenuButton<String>(
        tooltip: label,
        onSelected: (value) =>
            ref.read(languageControllerProvider.notifier).setLanguage(value),
        itemBuilder: (context) => <PopupMenuEntry<String>>[
          PopupMenuItem(value: 'en', child: Text(strings.languageEnglish)),
          PopupMenuItem(value: 'id', child: Text(strings.languageIndonesian)),
        ],
        child: Container(
          constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.language, size: 18, color: tokens.primary),
              SizedBox(width: tokens.space4),
              Text(
                code.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReadinessOverview extends StatelessWidget {
  const _ReadinessOverview({
    required this.answered,
    required this.title,
    required this.detail,
  });
  final int answered;
  final String title;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      padding: EdgeInsets.all(tokens.space14),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusCard),
        border: Border.all(color: tokens.hairline),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.shadow,
            blurRadius: tokens.space16,
            offset: Offset(0, tokens.space4),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: tokens.card,
                  borderRadius: BorderRadius.circular(tokens.radiusMedium),
                ),
                child: Icon(Icons.favorite_border, color: tokens.primary),
              ),
              SizedBox(width: tokens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.titleSmall),
                    Text(
                      detail,
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: tokens.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '$answered/5',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          SizedBox(height: tokens.space12),
          ClipRRect(
            borderRadius: BorderRadius.circular(tokens.radiusPill),
            child: LinearProgressIndicator(
              value: answered / 5,
              minHeight: 5,
              color: tokens.primary,
              backgroundColor: tokens.border,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReadinessQuestion extends StatelessWidget {
  const _ReadinessQuestion({
    required this.label,
    required this.value,
    required this.yesLabel,
    required this.noLabel,
    required this.onChanged,
  });
  final String label;
  final bool? value;
  final String yesLabel;
  final String noLabel;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      constraints: const BoxConstraints(minHeight: 58),
      margin: EdgeInsets.only(top: tokens.space8),
      padding: EdgeInsets.symmetric(
        horizontal: tokens.space12,
        vertical: tokens.space6,
      ),
      decoration: BoxDecoration(
        color: tokens.surface,
        borderRadius: BorderRadius.circular(tokens.radiusMedium),
        border: Border.all(color: tokens.hairline),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 130,
            child: SegmentedButton<bool>(
              emptySelectionAllowed: true,
              showSelectedIcon: false,
              style: ButtonStyle(
                minimumSize: WidgetStatePropertyAll(
                  Size.fromHeight(tokens.minimumTapTarget),
                ),
              ),
              segments: <ButtonSegment<bool>>[
                ButtonSegment(value: true, label: Text(yesLabel)),
                ButtonSegment(value: false, label: Text(noLabel)),
              ],
              selected: value == null ? const <bool>{} : <bool>{value!},
              onSelectionChanged: (selection) => onChanged(selection.first),
            ),
          ),
        ],
      ),
    );
  }
}

class _HealthNotice extends StatelessWidget {
  const _HealthNotice({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      margin: EdgeInsets.only(top: tokens.space12),
      padding: EdgeInsets.all(tokens.space12),
      decoration: BoxDecoration(
        color: tokens.card,
        borderRadius: BorderRadius.circular(tokens.radiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: tokens.surface.withValues(alpha: .7),
              borderRadius: BorderRadius.circular(tokens.radiusMedium),
            ),
            child: const Center(child: KilaMascot(width: 42, height: 40)),
          ),
          SizedBox(width: tokens.space10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(height: 1.4),
                children: <InlineSpan>[
                  TextSpan(
                    text: '$title\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: tokens.textPrimary,
                    ),
                  ),
                  TextSpan(
                    text: body,
                    style: TextStyle(color: tokens.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionCard extends StatelessWidget {
  const _PermissionCard({
    required this.icon,
    required this.title,
    required this.detail,
    required this.allowed,
    required this.allowLabel,
    required this.activeLabel,
    required this.semanticLabel,
    required this.onRequest,
    this.dark = false,
  });
  final IconData icon;
  final String title;
  final String detail;
  final bool allowed;
  final String allowLabel;
  final String activeLabel;
  final String semanticLabel;
  final VoidCallback onRequest;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final darkCard = dark;
    final background = darkCard ? tokens.primary : tokens.card;
    final foreground = darkCard ? tokens.surface : tokens.textPrimary;
    return Container(
      margin: EdgeInsets.only(top: tokens.space12),
      padding: EdgeInsets.all(tokens.space14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(tokens.radiusLarge),
        border: Border.all(
          color: darkCard
              ? tokens.surface.withValues(alpha: .12)
              : tokens.secondary.withValues(alpha: .28),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: tokens.shadow,
            blurRadius: tokens.space16,
            offset: Offset(0, tokens.space6),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: foreground.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(tokens.radiusMedium),
            ),
            child: Icon(icon, color: foreground),
          ),
          SizedBox(width: tokens.space10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: foreground),
                ),
                SizedBox(height: tokens.space4),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: foreground.withValues(alpha: .78),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: tokens.space6),
          Semantics(
            label: semanticLabel,
            button: true,
            child: TextButton(
              onPressed: allowed ? null : onRequest,
              style: TextButton.styleFrom(
                minimumSize: const Size(48, 48),
                foregroundColor: darkCard ? tokens.primary : tokens.surface,
                backgroundColor: darkCard ? tokens.surface : tokens.primary,
                disabledForegroundColor: tokens.success,
              ),
              child: Text(allowed ? activeLabel : allowLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _MascotPermissionNote extends StatelessWidget {
  const _MascotPermissionNote({required this.title, required this.body});
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.space8),
      child: Row(
        children: <Widget>[
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: tokens.card,
              borderRadius: BorderRadius.circular(tokens.radiusMedium),
            ),
            child: const Center(child: KilaMascot(width: 34, height: 32)),
          ),
          SizedBox(width: tokens.space10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.bodySmall
                    ?.copyWith(color: tokens.textSecondary, height: 1.35),
                children: <InlineSpan>[
                  TextSpan(
                    text: '$title\n',
                    style: TextStyle(
                      color: tokens.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: body),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingRouteArt extends StatelessWidget {
  const _OnboardingRouteArt();

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return IgnorePointer(
      child: Opacity(
        opacity: .2,
        child: CustomPaint(
          size: const Size(330, 260),
          painter: _RouteArtPainter(tokens.primary),
        ),
      ),
    );
  }
}

class _RouteArtPainter extends CustomPainter {
  const _RouteArtPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var offset = 0; offset < 2; offset++) {
      final path = Path()
        ..moveTo(size.width + 20, 20 + offset * 36)
        ..cubicTo(
          size.width * .76,
          22 + offset * 36,
          size.width * .8,
          105 + offset * 36,
          size.width * .56,
          105 + offset * 36,
        )
        ..cubicTo(
          size.width * .3,
          106 + offset * 36,
          size.width * .34,
          45 + offset * 36,
          size.width * .15,
          65 + offset * 36,
        )
        ..cubicTo(
          10,
          82 + offset * 36,
          18,
          154 + offset * 36,
          -18,
          178 + offset * 36,
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_RouteArtPainter oldDelegate) =>
      color != oldDelegate.color;
}
