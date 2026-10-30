import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';
import 'package:milestracks/features/auth/presentation/auth_controller.dart';
import 'package:milestracks/features/settings/presentation/language_controller.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_button.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    return Scaffold(
      backgroundColor: MilestracksTokens.authBackgroundBottom,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40,
                    child: Row(
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
                        SizedBox(width: tokens.space10),
                        Text(
                          'Milestracks',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontSize: 17, letterSpacing: -.6),
                        ),
                        const Spacer(),
                        Semantics(
                          label: strings.languageLabel,
                          button: true,
                          child: PopupMenuButton<String>(
                            tooltip: strings.languageLabel,
                            onSelected: (code) => ref
                                .read(languageControllerProvider.notifier)
                                .setLanguage(code),
                            itemBuilder: (context) => <PopupMenuEntry<String>>[
                              PopupMenuItem(
                                value: 'en',
                                child: Text(strings.languageEnglish),
                              ),
                              PopupMenuItem(
                                value: 'id',
                                child: Text(strings.languageIndonesian),
                              ),
                            ],
                            child: Padding(
                              padding: EdgeInsets.all(tokens.space10),
                              child: Text(
                                ref
                                    .watch(languageControllerProvider)
                                    .languageCode
                                    .toUpperCase(),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: tokens.space14),
                          Container(
                            height: 220,
                            width: double.infinity,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: <Color>[
                                  MilestracksTokens.authArtTop,
                                  MilestracksTokens.authArtBottom,
                                ],
                              ),
                              border: Border.all(
                                color: tokens.primary.withValues(alpha: .07),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned.fill(
                                  child: CustomPaint(
                                    painter: _WelcomeRoutePainter(
                                      tokens.primary,
                                      tokens.accent,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 12,
                                  left: 12,
                                  child: _RouteLabel(
                                    label: strings.welcomeRouteLabel,
                                    distance: strings.welcomeRouteDistance,
                                  ),
                                ),
                                const KilaMascot(width: 88, height: 84),
                              ],
                            ),
                          ),
                          SizedBox(height: tokens.space18),
                          Text(
                            strings.welcomeEyebrow,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: tokens.primary,
                                  letterSpacing: 1.6,
                                  fontSize: 10,
                                ),
                          ),
                          SizedBox(height: tokens.space8),
                          Text(
                            strings.welcomeHeroTitle,
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontSize: 42,
                                  letterSpacing: -2.7,
                                  fontWeight: FontWeight.w700,
                                  height: 1.02,
                                ),
                          ),
                          SizedBox(height: tokens.space12),
                          Text(
                            strings.welcomeHeroBody,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: tokens.textSecondary,
                                  fontSize: 15,
                                  height: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: tokens.space12,
                      bottom: tokens.space8,
                    ),
                    child: Column(
                      children: <Widget>[
                        MilestracksButton(
                          variant: MilestracksButtonVariant.secondary,
                          secondaryBackground: tokens.surface,
                          secondaryForeground: tokens.textPrimary,
                          secondaryBorder: Colors.transparent,
                          secondaryRadius: 15,
                          minimumHeight: 50,
                          onPressed: () async {
                            await ref
                                .read(authControllerProvider.notifier)
                                .signInWithGoogle();
                            if (!context.mounted) return;
                            final auth = ref.read(authControllerProvider);
                            if (auth.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    auth.error is UnsupportedError
                                        ? strings.authGoogleNotConfigured
                                        : strings.unknownError,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'assets/images/google-g.png',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(strings.authContinueGoogle),
                            ],
                          ),
                        ),
                        SizedBox(height: tokens.space8),
                        MilestracksButton(
                          variant: MilestracksButtonVariant.secondary,
                          secondaryBackground: Colors.transparent,
                          secondaryForeground: tokens.textPrimary,
                          secondaryBorder: tokens.primary.withValues(
                            alpha: .14,
                          ),
                          secondaryRadius: 15,
                          minimumHeight: 50,
                          onPressed: () => context.push('/auth?mode=signup'),
                          child: Text(strings.authSignUpEmail),
                        ),
                        SizedBox(height: tokens.space2),
                        MilestracksButton(
                          variant: MilestracksButtonVariant.text,
                          onPressed: () => context.push('/auth?mode=signin'),
                          child: Text(strings.authAlreadyAccount),
                        ),
                        SizedBox(height: tokens.space8),
                        Text(
                          strings.welcomeLegal,
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
          ),
        ),
      ),
    );
  }
}

class _RouteLabel extends StatelessWidget {
  const _RouteLabel({required this.label, required this.distance});
  final String label;
  final String distance;

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: tokens.surface.withValues(alpha: .88),
        border: Border.all(color: tokens.primary.withValues(alpha: .06)),
        borderRadius: BorderRadius.circular(11),
        boxShadow: <BoxShadow>[
          BoxShadow(color: tokens.shadow, blurRadius: tokens.space12),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: tokens.textSecondary,
              fontSize: 8,
              letterSpacing: .5,
            ),
          ),
          Text(
            distance,
            style: Theme.of(context).textTheme.labelLarge
                ?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _WelcomeRoutePainter extends CustomPainter {
  const _WelcomeRoutePainter(this.primary, this.accent);
  final Color primary;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * .056, size.height * .733)
      ..cubicTo(
        size.width * .228,
        size.height * .733,
        size.width * .203,
        size.height * .367,
        size.width * .403,
        size.height * .39,
      )
      ..cubicTo(
        size.width * .567,
        size.height * .41,
        size.width * .578,
        size.height * .705,
        size.width * .722,
        size.height * .562,
      )
      ..cubicTo(
        size.width * .817,
        size.height * .467,
        size.width * .828,
        size.height * .271,
        size.width * .95,
        size.height * .238,
      );
    final routePaint = Paint()
      ..color = primary.withValues(alpha: .43)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + 5).clamp(0, metric.length).toDouble();
        canvas.drawPath(metric.extractPath(distance, end), routePaint);
        distance += 13;
      }
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .042, size.height * .71, 10, 10),
        const Radius.circular(3),
      ),
      Paint()..color = primary,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * .935, size.height * .215, 10, 10),
        const Radius.circular(3),
      ),
      Paint()..color = accent,
    );
  }

  @override
  bool shouldRepaint(_WelcomeRoutePainter oldDelegate) =>
      primary != oldDelegate.primary || accent != oldDelegate.accent;
}
