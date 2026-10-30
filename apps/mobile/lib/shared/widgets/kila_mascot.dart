import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:rive/rive.dart'
    show Artboard, RiveAnimation, SMINumber, StateMachineController;

/// Kila rendering contract. The fallback painter mirrors
/// `assets/mascot/kila.svg` so its approved silhouette stays consistent.
enum KilaMood {
  idle,
  cheer,
  warn,
  think,
  levelUp,
  rest,
  celebrateStreak,
  sadSoft,
  happy,
  scout,
}

class KilaMascot extends StatefulWidget {
  const KilaMascot({
    this.mood = KilaMood.idle,
    this.semanticLabel,
    this.width,
    this.height,
    super.key,
  });

  final KilaMood mood;
  final String? semanticLabel;
  final double? width;
  final double? height;

  static Future<bool>? _riveAssetAvailable;

  @override
  State<KilaMascot> createState() => _KilaMascotState();
}

class _KilaMascotState extends State<KilaMascot> {
  Future<bool> get _riveAssetAvailable =>
      KilaMascot._riveAssetAvailable ??= _checkRiveAsset();

  Future<bool> _checkRiveAsset() async {
    try {
      await rootBundle.load('assets/rive/kila.riv');
      return true;
    } on Object {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.milestracksTokens;
    final width = widget.width ?? tokens.mascotWidth;
    final height = widget.height ?? tokens.mascotHeight;
    final canAnimate = !MediaQuery.disableAnimationsOf(context);
    return FutureBuilder<bool>(
      future: _riveAssetAvailable,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return _KilaRiveView(
            mood: widget.mood,
            width: width,
            height: height,
            semanticLabel: widget.semanticLabel,
          );
        }
        final artwork = CustomPaint(
          size: Size(width, height),
          painter: _KilaPainter(
            // Mirrors assets/mascot/kila.svg exactly. Keeping the SVG's
            // palette here preserves its appearance without an SVG runtime.
            fur: const Color(0xffa9927d),
            shade: const Color(0xff5e503f),
            eye: const Color(0xff22333b),
            highlight: Colors.white,
            mood: widget.mood,
          ),
        );
        final animateMood =
            widget.mood == KilaMood.think ||
            widget.mood == KilaMood.cheer ||
            widget.mood == KilaMood.celebrateStreak ||
            widget.mood == KilaMood.levelUp;
        final fallback = canAnimate && animateMood
            ? artwork
                  .animate(
                    key: ValueKey<KilaMood>(widget.mood),
                    onPlay: (controller) {
                      if (widget.mood == KilaMood.cheer ||
                          widget.mood == KilaMood.celebrateStreak ||
                          widget.mood == KilaMood.levelUp) {
                        controller.repeat(reverse: true);
                      }
                    },
                  )
                  .scale(
                    begin: const Offset(.94, .94),
                    end: const Offset(1.04, 1.04),
                    duration: 420.ms,
                    curve: Curves.easeInOut,
                  )
            : artwork;
        return widget.semanticLabel == null
            ? ExcludeSemantics(child: fallback)
            : Semantics(
                image: true,
                label: widget.semanticLabel,
                child: fallback,
              );
      },
    );
  }
}

class _KilaRiveView extends StatefulWidget {
  const _KilaRiveView({
    required this.mood,
    required this.width,
    required this.height,
    required this.semanticLabel,
  });

  final KilaMood mood;
  final double width;
  final double height;
  final String? semanticLabel;

  @override
  State<_KilaRiveView> createState() => _KilaRiveViewState();
}

class _KilaRiveViewState extends State<_KilaRiveView> {
  SMINumber? _moodInput;

  @override
  void didUpdateWidget(covariant _KilaRiveView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.mood != widget.mood) _applyMood();
  }

  void _onInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'KilaMachine',
    );
    if (controller == null) return;
    artboard.addController(controller);
    _moodInput = controller.findSMI<SMINumber>('mood');
    _applyMood();
  }

  void _applyMood() {
    final input = _moodInput;
    if (input == null) return;
    input.value = switch (widget.mood) {
      KilaMood.idle || KilaMood.happy => 0,
      KilaMood.cheer => 1,
      KilaMood.warn => 2,
      KilaMood.think || KilaMood.scout => 3,
      KilaMood.levelUp => 4,
      KilaMood.rest => 5,
      KilaMood.celebrateStreak => 6,
      KilaMood.sadSoft => 7,
    };
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.disableAnimationsOf(context);
    final animation = SizedBox(
      width: widget.width,
      height: widget.height,
      child: RiveAnimation.asset(
        'assets/rive/kila.riv',
        onInit: _onInit,
        placeHolder: const SizedBox.shrink(),
        speedMultiplier: reducedMotion ? 0 : 1,
      ),
    );
    final label = widget.semanticLabel;
    return label == null
        ? ExcludeSemantics(child: animation)
        : Semantics(image: true, label: label, child: animation);
  }
}

class _KilaPainter extends CustomPainter {
  const _KilaPainter({
    required this.fur,
    required this.shade,
    required this.eye,
    required this.highlight,
    required this.mood,
  });

  final Color fur;
  final Color shade;
  final Color eye;
  final Color highlight;
  final KilaMood mood;

  static final _ear = Path()
    ..moveTo(2.2, 2.6)
    ..cubicTo(7.3, -.9, 15.8, 1.8, 20.4, 8.7)
    ..cubicTo(23.1, 12.7, 24.6, 17.9, 22.9, 21.7)
    ..cubicTo(21, 25.7, 15.9, 26.1, 11, 22.5)
    ..cubicTo(4.7, 17.9, .3, 8.1, 2.2, 2.6)
    ..close();

  static final _head = Path()
    ..moveTo(35.28, 12)
    ..lineTo(40.72, 12)
    ..cubicTo(58, 12, 72, 22.8, 72, 39.6)
    ..lineTo(72, 46.2)
    ..cubicTo(72, 60.45, 58.87, 72, 42.76, 72)
    ..lineTo(33.24, 72)
    ..cubicTo(17.13, 72, 4, 60.45, 4, 46.2)
    ..lineTo(4, 39.6)
    ..cubicTo(4, 22.8, 18.1, 12, 35.28, 12)
    ..close();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 76, size.height / 72);
    final furPaint = Paint()..color = fur;

    _drawEar(canvas, mirror: false, furPaint: furPaint);
    _drawEar(canvas, mirror: true, furPaint: furPaint);

    canvas.drawPath(_head, furPaint);
    canvas.save();
    canvas.clipPath(_head);
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, 76, 72),
      Paint()
        ..shader = LinearGradient(
          begin: const Alignment(-.45, -.8),
          end: const Alignment(.8, 1),
          colors: <Color>[
            shade.withValues(alpha: 0),
            shade.withValues(alpha: .12),
            shade.withValues(alpha: .38),
          ],
          stops: const <double>[0, .58, 1],
        ).createShader(const Rect.fromLTWH(0, 0, 76, 72)),
    );
    canvas.restore();

    final eyePaint = Paint()..color = eye;
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(25, 37.5), width: 8, height: 9),
      eyePaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(51, 37.5), width: 8, height: 9),
      eyePaint,
    );
    final highlightPaint = Paint()..color = highlight;
    canvas.drawCircle(const Offset(23, 35.9), 1.2, highlightPaint);
    canvas.drawCircle(const Offset(49, 35.9), 1.2, highlightPaint);

    canvas.restore();
  }

  void _drawEar(
    Canvas canvas, {
    required bool mirror,
    required Paint furPaint,
  }) {
    canvas.save();
    if (mirror) {
      canvas.translate(76, 0);
      canvas.scale(-1, 1);
    }
    canvas.translate(5, 6);
    canvas.translate(12, 12.5);
    canvas.rotate(32 * math.pi / 180);
    canvas.translate(-12, -12.5);
    canvas.drawPath(_ear, furPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_KilaPainter oldDelegate) =>
      fur != oldDelegate.fur ||
      shade != oldDelegate.shade ||
      eye != oldDelegate.eye ||
      highlight != oldDelegate.highlight ||
      mood != oldDelegate.mood;
}
