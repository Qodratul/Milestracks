import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/feedback/feedback_controller.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/run_engine/gps_point_source.dart';
import 'package:milestracks/run_engine/run_engine_controller.dart';
import 'package:milestracks/run_engine/run_engine_state.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/kila_mascot.dart';
import 'package:milestracks/shared/widgets/milestracks_map.dart';

class RunModeScreen extends ConsumerStatefulWidget {
  const RunModeScreen({required this.trackId, super.key});
  final String trackId;

  @override
  ConsumerState<RunModeScreen> createState() => _RunModeScreenState();
}

class _RunModeScreenState extends ConsumerState<RunModeScreen> {
  String? _requestedStartFor;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final track = ref.watch(trackByIdProvider(widget.trackId));
    final state = ref.watch(runEngineControllerProvider);
    ref.listen(runEngineControllerProvider, (previous, next) {
      if (next is RunCompleted ||
          next is RunSafeStopped ||
          next is RunRejected) {
        if (next is RunCompleted && previous is! RunCompleted) {
          unawaited(
            ref.read(feedbackControllerProvider.notifier).runCompleted(),
          );
        }
        if (context.mounted) context.go('/run-result');
      }
      final previousReached = _reachedMilestoneCount(previous);
      final reached = _reachedMilestoneCount(next);
      if (reached > previousReached) {
        unawaited(ref.read(feedbackControllerProvider.notifier).milestone());
        final event = _milestoneEvent(next);
        if (event != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              unawaited(_showMilestoneDialog(context, ref, event, strings));
            }
          });
        } else {
          final total = _totalMilestoneCount(next);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(strings.runMilestonesProgress(reached, total)),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
        }
      }
    });

    return Theme(
      data: MilestracksTheme.light,
      child: Scaffold(
        backgroundColor: const Color(0xfff4f7f3),
        body: SafeArea(
          child: track.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => _RunError(message: strings.unknownError),
            data: (value) {
              final controller = ref.read(runEngineControllerProvider.notifier);
              if (state is RunIdle) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted &&
                      ref.read(runEngineControllerProvider) is RunIdle) {
                    controller.prepare(value);
                  }
                });
              } else if (state is RunReady && _requestedStartFor != value.id) {
                _requestedStartFor = value.id;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted &&
                      ref.read(runEngineControllerProvider) is RunReady) {
                    unawaited(
                      controller.start(
                        value,
                        RunNotificationCopy(
                          title: strings.runNotificationTitle,
                          body: strings.runNotificationBody,
                          channelName: strings.runNotificationChannelName,
                        ),
                      ),
                    );
                  }
                });
              }
              final activeTrack = switch (state) {
                RunReady(:final track) ||
                RunRunning(:final track) ||
                RunPaused(:final track) => track,
                _ => value,
              };
              return _RunContent(track: activeTrack, state: state);
            },
          ),
        ),
      ),
    );
  }
}

class _RunContent extends ConsumerWidget {
  const _RunContent({required this.track, required this.state});
  final TrackDto track;
  final RunEngineState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final tokens = context.milestracksTokens;
    final active = state is RunRunning || state is RunPaused;
    final paused = state is RunPaused;
    final elapsed = switch (state) {
      RunRunning(:final elapsedSeconds) => elapsedSeconds,
      RunPaused(:final elapsedSeconds) => elapsedSeconds,
      _ => 0,
    };
    final meters = switch (state) {
      RunRunning(:final distanceMeters) => distanceMeters,
      RunPaused(:final distanceMeters) => distanceMeters,
      _ => 0.0,
    };
    final reached = switch (state) {
      RunRunning(:final reachedMilestones) => reachedMilestones,
      RunPaused(:final reachedMilestones) => reachedMilestones,
      _ => 0,
    };
    final totalMilestones = _totalMilestoneCount(state);
    final currentPoint = switch (state) {
      RunRunning(:final points) when points.isNotEmpty => points.last,
      RunPaused(:final points) when points.isNotEmpty => points.last,
      _ => null,
    };
    final totalDistance = track.distanceMeters;
    final progress = totalDistance == null || totalDistance <= 0
        ? 0.0
        : (meters / totalDistance).clamp(0.0, 1.0);
    final user = ref.watch(currentUserProvider).value;
    final controller = ref.read(runEngineControllerProvider.notifier);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final distanceText = NumberFormat('0.00', locale).format(meters / 1000);
    final pace = _paceLabel(context, meters, elapsed);
    final calories = track.estimatedCalories == null || totalDistance == null
        ? '—'
        : NumberFormat.decimalPattern(locale)
              .format((track.estimatedCalories! * progress).round());

    return Column(
      children: <Widget>[
        _RunSafetyBar(
          active: active,
          onSafeStop: () =>
              unawaited(_confirmSafeStop(context, strings, controller)),
        ),
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: tokens.pageMaxWidth),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
                children: <Widget>[
                  _RunDistance(
                    distance: distanceText,
                    total: totalDistance == null
                        ? '—'
                        : NumberFormat(
                            '0.0',
                            locale,
                          ).format(totalDistance / 1000),
                    progress: progress,
                  ),
                  const SizedBox(height: 13),
                  _RunMetrics(
                    pace: pace,
                    duration: _durationLabel(context, elapsed),
                    calories: calories,
                  ),
                  const SizedBox(height: 12),
                  _LiveRouteMap(
                    track: track,
                    active: active,
                    currentPosition: currentPoint == null
                        ? null
                        : GeoPointDto(
                            latitude: currentPoint.latitude,
                            longitude: currentPoint.longitude,
                          ),
                    routeProgressMeters: meters,
                    finishDistance: totalDistance == null
                        ? '—'
                        : NumberFormat.decimalPattern(locale).format(
                            (totalDistance - meters)
                                .clamp(0, totalDistance)
                                .round(),
                          ),
                  ),
                  const SizedBox(height: 11),
                  _MilestoneProgress(reached: reached, total: totalMilestones),
                  const SizedBox(height: 7),
                  _KilaRunNote(
                    name: user?.displayName ?? strings.runRunnerLabel,
                  ),
                  if (!active)
                    switch (state) {
                      RunFailed(:final messageKey) => _RunFailure(
                        message: _localizedRunError(strings, messageKey),
                        onRetry: () => unawaited(
                          controller.start(
                            track,
                            RunNotificationCopy(
                              title: strings.runNotificationTitle,
                              body: strings.runNotificationBody,
                              channelName: strings.runNotificationChannelName,
                            ),
                          ),
                        ),
                        strings: strings,
                      ),
                      _ => const SizedBox.shrink(),
                    },
                ],
              ),
            ),
          ),
        ),
        _RunControls(
          paused: paused,
          active: active,
          onPause: () =>
              unawaited(paused ? controller.resume() : controller.pause()),
          onFinish: () => unawaited(controller.finish()),
        ),
      ],
    );
  }
}

class _RunSafetyBar extends StatelessWidget {
  const _RunSafetyBar({required this.active, required this.onSafeStop});
  final bool active;
  final VoidCallback onSafeStop;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 5, 17, 0),
      child: Row(
        children: <Widget>[
          if (active)
            Semantics(
              button: true,
              label: strings.runSafeStop,
              child: FilledButton.icon(
                onPressed: onSafeStop,
                icon: const Icon(Icons.stop_circle_outlined, size: 17),
                label: Text(
                  strings.runSafeStop,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xffb9413a),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 40),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(13),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 12),
          const Spacer(),
          const _GpsStatusIcon(),
          const _RunSoundButton(),
        ],
      ),
    );
  }
}

class _GpsStatusIcon extends StatelessWidget {
  const _GpsStatusIcon();

  @override
  Widget build(BuildContext context) => Semantics(
    label: AppLocalizations.of(context)!.runGpsSignal,
    child: const SizedBox(
      width: 44,
      height: 44,
      child: Center(
        child: Icon(
          Icons.signal_cellular_alt,
          color: Color(0xff39834b),
          size: 21,
        ),
      ),
    ),
  );
}

class _RunSoundButton extends StatefulWidget {
  const _RunSoundButton();
  @override
  State<_RunSoundButton> createState() => _RunSoundButtonState();
}

class _RunSoundButtonState extends State<_RunSoundButton> {
  bool _soundOn = false;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Semantics(
      button: true,
      label: _soundOn ? strings.runSoundOn : strings.runSoundOff,
      child: IconButton(
        onPressed: () => setState(() => _soundOn = !_soundOn),
        tooltip: _soundOn ? strings.runSoundOn : strings.runSoundOff,
        icon: Icon(
          _soundOn ? Icons.volume_up_outlined : Icons.volume_off_outlined,
          color: _soundOn ? const Color(0xff315e40) : const Color(0xff768178),
          size: 20,
        ),
      ),
    );
  }
}

class _RunDistance extends StatelessWidget {
  const _RunDistance({
    required this.distance,
    required this.total,
    required this.progress,
  });
  final String distance;
  final String total;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      children: <Widget>[
        const SizedBox(height: 3),
        Text(
          strings.runDistance,
          style: const TextStyle(
            fontSize: 8,
            letterSpacing: 1.3,
            fontWeight: FontWeight.w700,
            color: Color(0xff78847a),
          ),
        ),
        const SizedBox(height: 1),
        RichText(
          text: TextSpan(
            text: distance,
            style: const TextStyle(
              fontSize: 68,
              height: 1,
              letterSpacing: -4.5,
              fontWeight: FontWeight.w700,
              color: Color(0xff203c2b),
            ),
            children: const <InlineSpan>[
              TextSpan(
                text: ' km',
                style: TextStyle(
                  fontSize: 17,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff758177),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          strings.runDistanceOf(total),
          style: const TextStyle(fontSize: 9, color: Color(0xff748177)),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 4,
            backgroundColor: const Color(0xffdfe7dd),
            color: const Color(0xff47754e),
          ),
        ),
      ],
    );
  }
}

class _RunMetrics extends StatelessWidget {
  const _RunMetrics({
    required this.pace,
    required this.duration,
    required this.calories,
  });
  final String pace;
  final String duration;
  final String calories;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: const Color(0xeaffffff),
      border: Border.all(color: const Color(0xffe2e9e0)),
      borderRadius: BorderRadius.circular(16),
    ),
    clipBehavior: Clip.antiAlias,
    child: Row(
      children: <Widget>[
        _MetricCell(
          label: AppLocalizations.of(context)!.runPace,
          value: pace,
          suffix: '/km',
        ),
        _MetricCell(
          label: AppLocalizations.of(context)!.runDuration,
          value: duration,
        ),
        _MetricCell(
          label: AppLocalizations.of(context)!.runEstimatedCalories,
          value: calories,
          suffix: 'kcal',
        ),
      ],
    ),
  );
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({
    required this.label,
    required this.value,
    this.suffix = '',
  });
  final String label;
  final String value;
  final String suffix;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      constraints: const BoxConstraints(minHeight: 69),
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 7),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: Color(0xffe8ede6))),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 7,
              letterSpacing: .7,
              color: Color(0xff7b867d),
            ),
          ),
          const SizedBox(height: 3),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              text: TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff293e30),
                ),
                children: <InlineSpan>[
                  if (suffix.isNotEmpty)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff78857b),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _LiveRouteMap extends StatelessWidget {
  const _LiveRouteMap({
    required this.track,
    required this.active,
    required this.currentPosition,
    required this.routeProgressMeters,
    required this.finishDistance,
  });
  final TrackDto track;
  final bool active;
  final GeoPointDto? currentPosition;
  final double routeProgressMeters;
  final String finishDistance;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(20),
    child: SizedBox(
      height: 230,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          MilestracksMap(
            key: ValueKey<String>(
              '${track.revealedPolyline.length}:'
              '${track.milestones.map((item) => '${item.id}-${item.reached}').join(',')}',
            ),
            track: track,
            currentPosition: currentPosition,
            routeProgressMeters: routeProgressMeters,
            height: 230,
            showCurrentLocation: active,
            darkMode: false,
            showSafePreview: false,
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xeeffffff),
                border: Border.all(color: const Color(0xbfffffff)),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const <BoxShadow>[
                  BoxShadow(color: Color(0x14183026), blurRadius: 7),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      stringsRunMapLabel(context),
                      style: const TextStyle(
                        fontSize: 8,
                        letterSpacing: .4,
                        fontWeight: FontWeight.w800,
                        color: Color(0xff465b49),
                      ),
                    ),
                    if (active)
                      Text(
                        AppLocalizations.of(context)!
                            .runFinishDistance(finishDistance),
                        style: const TextStyle(
                          fontSize: 8,
                          color: Color(0xff527655),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String stringsRunMapLabel(BuildContext context) =>
    AppLocalizations.of(context)!.runLiveRoute;

class _MilestoneProgress extends StatelessWidget {
  const _MilestoneProgress({required this.reached, required this.total});
  final int reached;
  final int total;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                strings.trackMilestones,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff425347),
                ),
              ),
            ),
            Text(
              strings.runMilestonesProgress(reached, total),
              style: const TextStyle(fontSize: 8, color: Color(0xff7b867d)),
            ),
          ],
        ),
        const SizedBox(height: 7),
        Row(
          children: List<Widget>.generate(total, (index) {
            final done = index < reached;
            return Expanded(
              child: Row(
                children: <Widget>[
                  _MilestoneDot(index: index + 1, complete: done),
                  if (index < total - 1)
                    Expanded(
                      child: Container(
                        height: 2,
                        color: index < reached
                            ? const Color(0xff8eaa8e)
                            : const Color(0xffdbe4d9),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({required this.index, required this.complete});
  final int index;
  final bool complete;

  @override
  Widget build(BuildContext context) => Container(
    width: 25,
    height: 25,
    decoration: BoxDecoration(
      color: complete ? const Color(0xff3f7149) : Colors.white,
      shape: BoxShape.circle,
      border: complete ? null : Border.all(color: const Color(0xffd5e0d3)),
    ),
    child: Center(
      child: complete
          ? const Icon(Icons.check, color: Colors.white, size: 16)
          : Text(
              '$index',
              style: const TextStyle(fontSize: 9, color: Color(0xff607364)),
            ),
    ),
  );
}

class _KilaRunNote extends ConsumerWidget {
  const _KilaRunNote({required this.name});
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    return Row(
      children: <Widget>[
        const KilaMascot(mood: KilaMood.scout, width: 37, height: 37),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                strings.runNiceWork(name),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff405246),
                ),
              ),
              Text(
                strings.runComfortablePace,
                style: const TextStyle(fontSize: 8, color: Color(0xff748177)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _RunControls extends StatelessWidget {
  const _RunControls({
    required this.paused,
    required this.active,
    required this.onPause,
    required this.onFinish,
  });
  final bool paused;
  final bool active;
  final VoidCallback onPause;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(17, 8, 17, 10),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Color(0x00f0f4ef), Color(0xf7f0f4ef)],
        ),
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 56,
            height: 52,
            child: FilledButton(
              onPressed: active ? onPause : null,
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: const Color(0xff315e40),
                disabledBackgroundColor: const Color(0xffdce5da),
                foregroundColor: Colors.white,
                shape: const CircleBorder(),
              ),
              child: Icon(paused ? Icons.play_arrow : Icons.pause, size: 20),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: _FinishSlider(
              enabled: active,
              label: strings.runFinishSlider,
              onFinished: onFinish,
            ),
          ),
        ],
      ),
    );
  }
}

class _FinishSlider extends StatefulWidget {
  const _FinishSlider({
    required this.enabled,
    required this.label,
    required this.onFinished,
  });
  final bool enabled;
  final String label;
  final VoidCallback onFinished;

  @override
  State<_FinishSlider> createState() => _FinishSliderState();
}

class _FinishSliderState extends State<_FinishSlider> {
  double _progress = 0;

  void _update(DragUpdateDetails details, double width) {
    setState(
      () => _progress = (_progress + details.delta.dx / width).clamp(0.0, 1.0),
    );
  }

  void _end(DragEndDetails details) {
    if (_progress > .92) {
      widget.onFinished();
    }
    setState(() => _progress = 0);
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, box) {
      final thumbLeft = (box.maxWidth - 46) * _progress;
      return Semantics(
        slider: true,
        label: widget.label,
        value: '${(_progress * 100).round()}%',
        onIncrease: widget.enabled
            ? () {
                if (_progress >= .7) widget.onFinished();
                setState(() => _progress = 0);
              }
            : null,
        onDecrease: widget.enabled ? () => setState(() => _progress = 0) : null,
        child: GestureDetector(
          onHorizontalDragUpdate: widget.enabled
              ? (details) => _update(details, box.maxWidth)
              : null,
          onHorizontalDragEnd: widget.enabled ? _end : null,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xffe7eee6),
              border: Border.all(color: const Color(0xffcfddce)),
              borderRadius: BorderRadius.circular(14),
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: _progress,
                    heightFactor: 1,
                    child: const ColoredBox(color: Color(0x223f7149)),
                  ),
                ),
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff46644a),
                  ),
                ),
                Positioned(
                  left: thumbLeft,
                  top: 2,
                  bottom: 2,
                  child: Container(
                    width: 46,
                    decoration: BoxDecoration(
                      color: const Color(0xff315e40),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x3823422a),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _RunError extends StatelessWidget {
  const _RunError({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class _RunFailure extends StatelessWidget {
  const _RunFailure({
    required this.message,
    required this.onRetry,
    required this.strings,
  });
  final String message;
  final VoidCallback onRetry;
  final AppLocalizations strings;
  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: 10),
      TextButton(onPressed: onRetry, child: Text(strings.trackTryAgain)),
    ],
  );
}

MilestoneDialogueDto? _milestoneEvent(RunEngineState? state) => switch (state) {
  RunRunning(:final milestoneEvent) => milestoneEvent,
  RunPaused(:final milestoneEvent) => milestoneEvent,
  _ => null,
};

int _reachedMilestoneCount(RunEngineState? state) => switch (state) {
  RunRunning(:final reachedMilestones) ||
  RunPaused(:final reachedMilestones) => reachedMilestones,
  _ => 0,
};

int _totalMilestoneCount(RunEngineState state) => switch (state) {
  RunRunning(:final run, :final track) || RunPaused(:final run, :final track) =>
    run.milestones.isNotEmpty ? run.milestones.length : track.milestones.length,
  RunReady(:final track) => track.milestones.length,
  _ => 0,
};

Future<void> _showMilestoneDialog(
  BuildContext context,
  WidgetRef ref,
  MilestoneDialogueDto dialogue,
  AppLocalizations strings,
) async {
  final controller = ref.read(runEngineControllerProvider.notifier);
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => AlertDialog(
      title: Text(strings.runMilestoneTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const KilaMascot(mood: KilaMood.cheer),
          const SizedBox(height: 12),
          Text(dialogue.cheerLine),
          const SizedBox(height: 8),
          Text(dialogue.continuePrompt),
          Text(dialogue.restPrompt),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            unawaited(controller.restAfterMilestone());
          },
          child: Text(strings.runRest),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(dialogContext).pop();
            unawaited(controller.continueAfterMilestone());
          },
          child: Text(strings.runContinue),
        ),
      ],
    ),
  );
}

Future<void> _confirmSafeStop(
  BuildContext context,
  AppLocalizations strings,
  RunEngineController controller,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(strings.runSafeStopTitle),
      content: Text(strings.runSafeStopBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(strings.runCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(strings.runConfirm),
        ),
      ],
    ),
  );
  if (confirmed == true) await controller.safeStop();
}

String _durationLabel(BuildContext context, int seconds) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final duration = Duration(seconds: seconds);
  final two = NumberFormat('00', locale);
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final secs = duration.inSeconds.remainder(60);
  return hours > 0
      ? '${two.format(hours)}:${two.format(minutes)}:${two.format(secs)}'
      : '${two.format(minutes)}:${two.format(secs)}';
}

String _paceLabel(BuildContext context, double meters, int seconds) {
  // Early GPS fixes are noisy; hide the average until there's enough movement
  // to make the pace meaningful.
  if (meters < 100 || seconds <= 0) return '—';
  return _durationLabel(context, (seconds / (meters / 1000)).round());
}

String _localizedRunError(AppLocalizations strings, String key) =>
    switch (key) {
      'backgroundLocationRequired' => strings.runBackgroundLocationRequired,
      'validationError' => strings.validationError,
      'conflictError' => strings.conflictError,
      'rateLimitError' => strings.rateLimitError,
      'networkError' => strings.networkError,
      'requestTimedOut' => strings.requestTimedOut,
      'serverError' => strings.serverError,
      'sessionExpired' => strings.sessionExpired,
      _ => strings.unknownError,
    };
