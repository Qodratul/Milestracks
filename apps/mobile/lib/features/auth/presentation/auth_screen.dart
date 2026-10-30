import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/features/auth/presentation/auth_controller.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_button.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({required this.initialSignUp, super.key});
  final bool initialSignUp;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _displayName = TextEditingController();
  late bool _signUp;
  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _signUp = widget.initialSignUp;
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _displayName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final fieldScale = (MediaQuery.sizeOf(context).width / 390)
        .clamp(.9, 1.0)
        .toDouble();
    final auth = ref.watch(authControllerProvider);
    final loading = auth.isLoading;
    final error = auth.hasError ? _authErrorCopy(auth.error, strings) : null;

    return Scaffold(
      backgroundColor: MilestracksTokens.authBackgroundBottom,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    tooltip: strings.authBack,
                    onPressed: () => context.go('/welcome'),
                    icon: const MilestracksIcon('arrow-left'),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                  ),
                ),
                SizedBox(height: tokens.space16),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _signUp
                                ? strings.authIntroSignUpTitle
                                : strings.authIntroSignInTitle,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  height: 1.05,
                                ),
                          ),
                          SizedBox(height: tokens.space8),
                          Text(
                            _signUp
                                ? strings.authIntroSignUpBody
                                : strings.authIntroSignInBody,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: tokens.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    const KilaMascot(width: 62, height: 59),
                  ],
                ),
                SizedBox(height: tokens.space24),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[
                        MilestracksTokens.authCardTop,
                        MilestracksTokens.authCardBottom,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: MilestracksTokens.authCardAccent.withValues(
                        alpha: .28,
                      ),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: tokens.shadow,
                        blurRadius: tokens.shadowBlur,
                        offset: Offset(0, tokens.shadowOffsetY),
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: tokens.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: IconTheme(
                                data: IconThemeData(color: Colors.white),
                                child: MilestracksIcon('brand', size: 19),
                              ),
                            ),
                          ),
                          const SizedBox(width: 9),
                          Text(
                            'Milestracks',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      SizedBox(height: tokens.space18),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: MilestracksTokens.authCardBottom,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          children: <Widget>[
                            _AuthTab(
                              label: strings.authSignIn,
                              icon: 'login',
                              selected: !_signUp,
                              onTap: loading
                                  ? null
                                  : () => setState(() => _signUp = false),
                            ),
                            _AuthTab(
                              label: strings.authSignUp,
                              icon: 'userPlus',
                              selected: _signUp,
                              onTap: loading
                                  ? null
                                  : () => setState(() => _signUp = true),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: tokens.space16),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(strings.authEmail),
                                const SizedBox(height: 7),
                                TextFormField(
                                  controller: _email,
                                  style: _authFieldTextStyle(
                                    context,
                                    fieldScale,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const <String>[
                                    AutofillHints.email,
                                  ],
                                  decoration: _authInputDecoration(
                                    context: context,
                                    hintText: strings.authEmailHint,
                                    fieldScale: fieldScale,
                                    icon: MilestracksIcon(
                                      'mail',
                                      size: 18 * fieldScale,
                                    ),
                                  ),
                                  validator: (value) => _validEmail(value ?? '')
                                      ? null
                                      : strings.authEmailInvalid,
                                ),
                              ],
                            ),
                            SizedBox(height: tokens.space14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(strings.authPassword),
                                const SizedBox(height: 7),
                                TextFormField(
                                  controller: _password,
                                  style: _authFieldTextStyle(
                                    context,
                                    fieldScale,
                                  ),
                                  obscureText: !_showPassword,
                                  textInputAction: _signUp
                                      ? TextInputAction.next
                                      : TextInputAction.done,
                                  autofillHints: <String>[
                                    _signUp
                                        ? AutofillHints.newPassword
                                        : AutofillHints.password,
                                  ],
                                  decoration: _authInputDecoration(
                                    context: context,
                                    hintText: strings.authPasswordHint,
                                    fieldScale: fieldScale,
                                    icon: MilestracksIcon(
                                      'lock',
                                      size: 18 * fieldScale,
                                    ),
                                    suffixIcon: IconButton(
                                      tooltip: _showPassword
                                          ? strings.authHidePassword
                                          : strings.authShowPassword,
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                      icon: MilestracksIcon(
                                        _showPassword ? 'eyeOff' : 'eye',
                                        size: 17,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 48,
                                        minHeight: 48,
                                      ),
                                    ),
                                  ),
                                  validator: (value) =>
                                      (value?.length ?? 0) >= 8 &&
                                          (value?.length ?? 0) <= 72
                                      ? null
                                      : strings.authPasswordInvalid,
                                ),
                              ],
                            ),
                            if (_signUp) ...<Widget>[
                              SizedBox(height: tokens.space14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(strings.authDisplayName),
                                  const SizedBox(height: 7),
                                  TextFormField(
                                    controller: _displayName,
                                    style: _authFieldTextStyle(
                                      context,
                                      fieldScale,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                    textInputAction: TextInputAction.done,
                                    autofillHints: const <String>[
                                      AutofillHints.nickname,
                                    ],
                                    decoration: _authInputDecoration(
                                      context: context,
                                      hintText: strings.authDisplayNameHint,
                                      fieldScale: fieldScale,
                                      icon: MilestracksIcon(
                                        'profile',
                                        size: 18 * fieldScale,
                                      ),
                                    ),
                                    validator: (value) =>
                                        (value?.trim().length ?? 0) >= 2 &&
                                            (value?.trim().length ?? 0) <= 30
                                        ? null
                                        : strings.authDisplayNameInvalid,
                                  ),
                                ],
                              ),
                            ],
                            if (error != null) ...<Widget>[
                              SizedBox(height: tokens.space12),
                              Semantics(
                                liveRegion: true,
                                child: Text(
                                  error,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: tokens.error),
                                ),
                              ),
                            ],
                            SizedBox(height: tokens.space16),
                            MilestracksButton(
                              onPressed: loading ? null : _submit,
                              primaryBackground: tokens.primary,
                              primaryForeground: tokens.surface,
                              primaryRadius: tokens.radiusMedium,
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(
                                      _signUp
                                          ? strings.authCreateAccount
                                          : strings.authSignIn,
                                    ),
                            ),
                            SizedBox(height: tokens.space12),
                            Text(
                              strings.authTerms,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: tokens.textMuted),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: tokens.space24),
                Center(
                  child: Text(
                    strings.authCopyright,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(color: tokens.textMuted),
                  ),
                ),
                SizedBox(height: tokens.space24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final controller = ref.read(authControllerProvider.notifier);
    if (_signUp) {
      await controller.signUp(
        _email.text.trim(),
        _password.text,
        _displayName.text.trim(),
      );
    } else {
      await controller.signIn(_email.text.trim(), _password.text);
    }
  }

  bool _validEmail(String value) =>
      RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value.trim());

  String _authErrorCopy(Object? error, AppLocalizations strings) {
    if (error is AppException) {
      if (error.message == 'googleSignInCanceled') {
        return strings.authGoogleCanceled;
      }
      if (error.message == 'googleSignInNotConfigured') {
        return strings.authGoogleNotConfigured;
      }
      if (error.message == 'googleSignInFailed') {
        return strings.authGoogleFailed;
      }
      if (error.message == 'authInvalidCredentials') {
        return strings.authInvalidCredentials;
      }
      if (error.message == 'authEmailTaken') return strings.authEmailTaken;
      return switch (error.kind) {
        AppExceptionKind.validation => strings.validationError,
        AppExceptionKind.unauthorized => strings.sessionExpired,
        AppExceptionKind.conflict => strings.conflictError,
        AppExceptionKind.rateLimit => strings.rateLimitError,
        AppExceptionKind.server => strings.serverError,
        AppExceptionKind.timeout => strings.requestTimedOut,
        AppExceptionKind.network => strings.networkError,
        AppExceptionKind.unknown => strings.unknownError,
      };
    }
    if (error is UnsupportedError &&
        error.message == 'googleSignInNotConfigured') {
      return strings.authGoogleNotConfigured;
    }
    return strings.unknownError;
  }
}

InputDecoration _authInputDecoration({
  required BuildContext context,
  required String hintText,
  required Widget icon,
  required double fieldScale,
  Widget? suffixIcon,
}) {
  const borderColor = Color(0xFFDDDCD4);
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(13),
    borderSide: const BorderSide(color: borderColor),
  );
  return InputDecoration(
    hintText: hintText,
    hintStyle: _authFieldTextStyle(
      context,
      fieldScale,
    ).copyWith(color: context.milestracksTokens.textMuted),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: EdgeInsets.symmetric(
      vertical: 13 * fieldScale,
      horizontal: 11 * fieldScale,
    ),
    prefixIcon: SizedBox(
      width: 46,
      height: 48,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: 12 * fieldScale,
            right: 9 * fieldScale,
          ),
          child: icon,
        ),
      ),
    ),
    prefixIconConstraints: const BoxConstraints.tightFor(width: 46, height: 48),
    suffixIcon: suffixIcon,
    border: border,
    enabledBorder: border,
    focusedBorder: border.copyWith(
      borderSide: const BorderSide(
        color: MilestracksTokens.authFocus,
        width: 1.3,
      ),
    ),
    errorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFC73932)),
    ),
    focusedErrorBorder: border.copyWith(
      borderSide: const BorderSide(color: Color(0xFFC73932), width: 1.3),
    ),
  );
}

TextStyle _authFieldTextStyle(BuildContext context, double fieldScale) =>
    Theme.of(context).textTheme.bodyMedium!
        .copyWith(fontSize: 13 * fieldScale, height: 1.2);

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            constraints: const BoxConstraints(minHeight: 40),
            decoration: BoxDecoration(
              color: selected ? tokens.surface : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              boxShadow: selected
                  ? <BoxShadow>[
                      BoxShadow(
                        color: tokens.primary.withValues(alpha: .09),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MilestracksIcon(icon, size: 15),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? tokens.textPrimary : tokens.textSecondary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
