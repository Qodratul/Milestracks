import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_button.dart';

class GeneratingScreen extends ConsumerWidget {
  const GeneratingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final generated = ref.watch(generateTrackProvider);
    final activeRunConflict = generated.error is TrackActiveRunExists ||
        (generated.error is AppException &&
            (generated.error! as AppException).backendCode ==
                'ACTIVE_RUN_EXISTS');
    ref.listen(generateTrackProvider, (previous, next) {
      next.whenData((track) {
        if (track.status == TrackStatus.ready && context.mounted) {
          context.go('/prepare/${track.id}');
        }
      });
    });
    final failureText = generated.hasError
        ? activeRunConflict
              ? strings.runRecoveryBody
              : generated.error is TrackLocationUnavailable
              ? strings.trackLocationUnavailable
              : strings.unknownError
        : generated.value?.status == TrackStatus.failed
        ? strings.trackGenerationFailed
        : null;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            const Positioned.fill(child: _TerrainLines()),
            Align(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  tokens.pagePadding + 4,
                  40,
                  tokens.pagePadding + 4,
                  48,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const KilaMascot(
                        mood: KilaMood.think,
                        width: 76,
                        height: 72,
                      ),
                      const SizedBox(height: 26),
                      Text(
                        strings.trackGeneratingEyebrow,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: tokens.primary,
                          letterSpacing: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        strings.trackGeneratingTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        failureText ?? strings.trackGeneratingDescription,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: tokens.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      if (generated.isLoading)
                        Semantics(
                          label: strings.trackGeneratingTitle,
                          child: SizedBox(
                            width: 34,
                            height: 34,
                            child: CircularProgressIndicator(
                              color: tokens.secondary,
                              strokeWidth: 3,
                            ),
                          ),
                        )
                      else if (failureText != null)
                        Column(
                          children: <Widget>[
                            MilestracksButton(
                              onPressed: activeRunConflict
                                  ? () => context.go('/run-recovery')
                                  : () =>
                                        ref.invalidate(generateTrackProvider),
                              primaryBackground: tokens.primary,
                              primaryForeground: tokens.surface,
                              primaryRadius: tokens.radiusMedium,
                              child: Text(
                                activeRunConflict
                                    ? strings.runRecoveryTitle
                                    : strings.trackTryAgain,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 18),
                      TextButton(
                        onPressed: () => context.go('/home'),
                        child: Text(strings.authBack),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: tokens.pagePadding,
              right: tokens.pagePadding,
              bottom: 12,
              child: Text(
                strings.trackCopyright,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TerrainLines extends StatelessWidget {
  const _TerrainLines();
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _TerrainPainter(
      context.milestracksTokens.primary.withValues(alpha: .08),
    ),
    child: const SizedBox.expand(),
  );
}

class _TerrainPainter extends CustomPainter {
  const _TerrainPainter(this.color);
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var index = 0; index < 5; index++) {
      final path = Path()
        ..moveTo(-size.width * .15, size.height * (.18 + index * .035))
        ..cubicTo(
          size.width * .08,
          size.height * (.02 + index * .035),
          size.width * .44,
          size.height * (.11 + index * .04),
          size.width * .42,
          size.height * (.3 + index * .04),
        )
        ..cubicTo(
          size.width * .4,
          size.height * (.49 + index * .03),
          size.width * .08,
          size.height * (.43 + index * .03),
          -size.width * .1,
          size.height * (.61 + index * .03),
        );
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_TerrainPainter oldDelegate) => oldDelegate.color != color;
}
