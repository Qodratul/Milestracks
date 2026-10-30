import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_controller.g.dart';

enum FeedbackCue { milestone, runCompleted }

@Riverpod(keepAlive: true)
class FeedbackController extends _$FeedbackController {
  late final AudioPlayer _player;
  Future<void>? _sessionConfiguration;

  @override
  void build() {
    _player = AudioPlayer();
    ref.onDispose(() => unawaited(_player.dispose()));
  }

  Future<void> milestone() async {
    await _haptic(HapticFeedback.mediumImpact);
    await _play(FeedbackCue.milestone);
  }

  Future<void> runCompleted() async {
    await _haptic(HapticFeedback.heavyImpact);
    await _play(FeedbackCue.runCompleted);
  }

  Future<void> _play(FeedbackCue cue) async {
    try {
      _sessionConfiguration ??= _configureAudioSession();
      await _sessionConfiguration;
      await _player.stop();
      await _player.setAsset(switch (cue) {
        FeedbackCue.milestone => 'assets/audio/milestone_chime.wav',
        FeedbackCue.runCompleted => 'assets/audio/run_celebration.wav',
      });
      await _player.play();
    } on Object {
      // Audio is supplementary feedback; missing audio hardware must not
      // interrupt a run or hide its result.
    }
  }

  Future<void> _configureAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        avAudioSessionCategoryOptions: AVAudioSessionCategoryOptions.duckOthers,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        androidAudioAttributes: AndroidAudioAttributes(
          contentType: AndroidAudioContentType.sonification,
          usage: AndroidAudioUsage.assistanceSonification,
        ),
        androidAudioFocusGainType:
            AndroidAudioFocusGainType.gainTransientMayDuck,
        androidWillPauseWhenDucked: false,
      ),
    );
  }

  Future<void> _haptic(Future<void> Function() impact) async {
    try {
      await impact();
    } on Object {
      // Some simulators do not provide a haptic channel.
    }
  }
}
