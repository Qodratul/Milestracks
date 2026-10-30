import 'package:flutter/material.dart';

/// Flutter rendering of the Lucide outlines used by the React design.
/// The path geometry matches the corresponding icons in public/icons and
/// components/ui/Icon.tsx, without adding an SVG runtime dependency.
class MilestracksIcon extends StatelessWidget {
  const MilestracksIcon(this.name, {this.size = 20, super.key});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: Size.square(size),
    painter: _MilestracksIconPainter(name, IconTheme.of(context).color),
  );
}

class _MilestracksIconPainter extends CustomPainter {
  const _MilestracksIconPainter(this.name, this.color);

  final String name;
  final Color? color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.scale(scale);
    final paint = Paint()
      ..color = color ?? const Color(0xFF203238)
      ..style = PaintingStyle.stroke
      ..strokeWidth = name == 'coin'
          ? 1.5
          : const <String>{'history', 'friends', 'bell', 'arrow'}.contains(name)
          ? 1.75
          : 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final paths = _paths[name] ?? _paths['route']!;
    for (final path in paths) {
      canvas.drawPath(path, paint);
    }
    for (final circle in _circles[name] ?? const <Rect>[]) {
      canvas.drawCircle(circle.center, circle.width / 2, paint);
    }
    canvas.restore();
  }

  static final Map<String, List<Path>> _paths = <String, List<Path>>{
    'route': <Path>[
      Path()
        ..moveTo(5, 18)
        ..cubicTo(5, 15, 8, 15, 8, 12)
        ..cubicTo(8, 9, 5, 9, 5, 6),
      Path()
        ..moveTo(19, 6)
        ..cubicTo(19, 9, 16, 9, 16, 12)
        ..cubicTo(16, 15, 19, 15, 19, 18),
    ],
    'mail': <Path>[
      Path()
        ..moveTo(4, 5)
        ..lineTo(20, 5)
        ..lineTo(20, 19)
        ..lineTo(4, 19)
        ..close(),
      Path()
        ..moveTo(4, 6)
        ..lineTo(12, 13)
        ..lineTo(20, 6),
    ],
    'lock': <Path>[
      Path()
        ..moveTo(5, 11)
        ..lineTo(19, 11)
        ..lineTo(19, 21)
        ..lineTo(5, 21)
        ..close(),
      Path()
        ..moveTo(8, 11)
        ..lineTo(8, 7)
        ..cubicTo(8, 1, 16, 1, 16, 7)
        ..lineTo(16, 11),
    ],
    'login': <Path>[
      Path()
        ..moveTo(10, 17)
        ..lineTo(15, 12)
        ..lineTo(10, 7),
      Path()
        ..moveTo(15, 12)
        ..lineTo(3, 12),
      Path()
        ..moveTo(12, 3)
        ..lineTo(20, 3)
        ..lineTo(20, 21)
        ..lineTo(12, 21),
    ],
    'userPlus': <Path>[
      Path()
        ..moveTo(2.5, 20)
        ..cubicTo(2.5, 14, 15.5, 14, 15.5, 20),
      Path()
        ..moveTo(19, 7)
        ..lineTo(19, 13),
      Path()
        ..moveTo(16, 10)
        ..lineTo(22, 10),
    ],
    'eye': <Path>[
      Path()
        ..moveTo(2, 12)
        ..cubicTo(5, 5, 19, 5, 22, 12)
        ..cubicTo(19, 19, 5, 19, 2, 12)
        ..close(),
    ],
    'eyeOff': <Path>[
      Path()
        ..moveTo(3, 3)
        ..lineTo(21, 21),
      Path()
        ..moveTo(10, 10)
        ..cubicTo(9, 13, 12, 15, 14, 13),
      Path()
        ..moveTo(6, 6)
        ..cubicTo(3, 8, 2, 12, 2, 12)
        ..cubicTo(5, 19, 19, 19, 22, 12)
        ..cubicTo(21, 10, 19, 7, 16, 6),
    ],
    'coin': <Path>[
      Path()
        ..moveTo(8.25, 15)
        ..lineTo(8.25, 9)
        ..lineTo(12, 12.375)
        ..lineTo(15.75, 9)
        ..lineTo(15.75, 15),
    ],
    // Exact vector equivalent of assets/icons/route.svg.
    'brand': <Path>[
      Path()
        ..moveTo(9, 19)
        ..lineTo(17.5, 19)
        ..cubicTo(22.17, 19, 22.17, 12, 17.5, 12)
        ..lineTo(6.5, 12)
        ..cubicTo(1.83, 12, 1.83, 5, 6.5, 5)
        ..lineTo(15, 5),
    ],
    'weather': <Path>[
      Path()
        ..moveTo(12, 2)
        ..lineTo(12, 4),
      Path()
        ..moveTo(4.93, 4.93)
        ..lineTo(6.34, 6.34),
      Path()
        ..moveTo(20, 12)
        ..lineTo(22, 12),
      Path()
        ..moveTo(19.07, 4.93)
        ..lineTo(17.66, 6.34),
      Path()
        ..moveTo(15.95, 12.65)
        ..cubicTo(15.4, 9.6, 11.2, 7.4, 9, 9.2),
      Path()
        ..moveTo(13, 22)
        ..lineTo(7, 22)
        ..cubicTo(2, 22, 2, 15, 7, 15)
        ..cubicTo(10, 15, 11, 17, 12, 18)
        ..lineTo(13, 18)
        ..cubicTo(17, 18, 17, 22, 13, 22)
        ..close(),
    ],
    'bell': <Path>[
      Path()
        ..moveTo(18, 8)
        ..cubicTo(18, 4, 6, 4, 6, 8)
        ..cubicTo(6, 15, 3, 15, 3, 17)
        ..lineTo(21, 17)
        ..cubicTo(21, 15, 18, 15, 18, 8),
      Path()
        ..moveTo(10, 21)
        ..lineTo(14, 21),
    ],
    'home': <Path>[
      Path()
        ..moveTo(3, 11)
        ..lineTo(12, 3)
        ..lineTo(21, 11),
      Path()
        ..moveTo(5, 10)
        ..lineTo(5, 20)
        ..lineTo(19, 20)
        ..lineTo(19, 10),
      Path()
        ..moveTo(9, 20)
        ..lineTo(9, 14)
        ..lineTo(15, 14)
        ..lineTo(15, 20),
    ],
    'history': <Path>[
      Path()
        ..moveTo(12, 7)
        ..lineTo(12, 12)
        ..lineTo(15, 14),
    ],
    'search': <Path>[
      Path()..addOval(
        Rect.fromCircle(center: const Offset(10.8, 10.8), radius: 6.3),
      ),
      Path()
        ..moveTo(15.4, 15.4)
        ..lineTo(21, 21),
    ],
    'shop': <Path>[
      Path()
        ..moveTo(5, 8)
        ..lineTo(19, 8)
        ..lineTo(20, 20)
        ..lineTo(4, 20)
        ..close(),
      Path()
        ..moveTo(9, 9)
        ..lineTo(9, 6)
        ..cubicTo(9, 2, 15, 2, 15, 6)
        ..lineTo(15, 9),
    ],
    'run': <Path>[
      Path()
        ..moveTo(4, 16)
        ..lineTo(4, 13.62)
        ..cubicTo(4, 11.5, 3, 10.5, 3, 8)
        ..cubicTo(3, 5.28, 4.5, 2, 7.5, 2)
        ..cubicTo(9.4, 2, 10, 3.8, 10, 5.5)
        ..cubicTo(10, 8.6, 8, 11.2, 8, 14.2)
        ..lineTo(8, 16)
        ..cubicTo(8, 19, 4, 19, 4, 16),
      Path()
        ..moveTo(20, 20)
        ..lineTo(20, 17.62)
        ..cubicTo(20, 15.5, 21, 14.5, 21, 12)
        ..cubicTo(21, 9.28, 19.5, 6, 16.5, 6)
        ..cubicTo(14.6, 6, 14, 7.8, 14, 9.5)
        ..cubicTo(14, 12.6, 16, 15.2, 16, 18.2)
        ..lineTo(16, 20)
        ..cubicTo(16, 23, 20, 23, 20, 20),
      Path()
        ..moveTo(16, 17)
        ..lineTo(20, 17),
      Path()
        ..moveTo(4, 13)
        ..lineTo(8, 13),
    ],
    'league': <Path>[
      Path()
        ..moveTo(10, 14.66)
        ..lineTo(10, 17)
        ..cubicTo(10, 17.55, 9.55, 18, 9, 18)
        ..cubicTo(7.9, 18, 7, 18.9, 7, 20)
        ..lineTo(7, 22),
      Path()
        ..moveTo(14, 14.66)
        ..lineTo(14, 17)
        ..cubicTo(14, 17.55, 14.45, 18, 15, 18)
        ..cubicTo(16.1, 18, 17, 18.9, 17, 20)
        ..lineTo(17, 22),
      Path()
        ..moveTo(17.916, 10)
        ..lineTo(19.5, 10)
        ..cubicTo(20.88, 10, 22, 8.88, 22, 7.5)
        ..lineTo(22, 5)
        ..cubicTo(22, 4.45, 21.55, 4, 21, 4)
        ..lineTo(18, 4),
      Path()
        ..moveTo(4, 22)
        ..lineTo(20, 22),
      Path()
        ..moveTo(6, 9)
        ..cubicTo(6, 12.3, 8.7, 15, 12, 15)
        ..cubicTo(15.3, 15, 18, 12.3, 18, 9)
        ..lineTo(18, 3)
        ..cubicTo(18, 2.45, 17.55, 2, 17, 2)
        ..lineTo(7, 2)
        ..cubicTo(6.45, 2, 6, 2.45, 6, 3)
        ..lineTo(6, 9)
        ..close(),
      Path()
        ..moveTo(6.084, 10)
        ..lineTo(4.5, 10)
        ..cubicTo(3, 10, 2, 9, 2, 7.5)
        ..lineTo(2, 5)
        ..cubicTo(2, 3, 4, 4, 6, 4),
    ],
    'friends': <Path>[
      Path()
        ..moveTo(16, 21)
        ..lineTo(16, 19)
        ..cubicTo(16, 16.8, 14.2, 15, 12, 15)
        ..lineTo(8, 15)
        ..cubicTo(5.8, 15, 4, 16.8, 4, 19)
        ..lineTo(4, 21),
      Path()
        ..moveTo(20, 21)
        ..lineTo(20, 19)
        ..cubicTo(20, 17.2, 18.8, 15.7, 17, 15.2),
      Path()
        ..moveTo(16, 3.2)
        ..cubicTo(19.3, 4, 20.2, 8.2, 17, 10.3),
    ],
    'profile': <Path>[
      Path()
        ..moveTo(4, 21)
        ..cubicTo(4, 11, 20, 11, 20, 21),
    ],
    'arrow': <Path>[
      Path()
        ..moveTo(9, 18)
        ..lineTo(15, 12)
        ..lineTo(9, 6),
    ],
    'arrow-left': <Path>[
      Path()
        ..moveTo(15, 18)
        ..lineTo(9, 12)
        ..lineTo(15, 6),
      Path()
        ..moveTo(9, 12)
        ..lineTo(21, 12),
    ],
    'check': <Path>[
      Path()
        ..moveTo(5, 12)
        ..lineTo(9, 16)
        ..lineTo(19, 6),
    ],
    'shield': <Path>[
      Path()
        ..moveTo(12, 22)
        ..cubicTo(12, 22, 20, 18, 20, 11)
        ..lineTo(20, 5)
        ..lineTo(12, 2)
        ..lineTo(4, 5)
        ..lineTo(4, 11)
        ..cubicTo(4, 18, 12, 22, 12, 22)
        ..close(),
    ],
    'flame': <Path>[
      Path()
        ..moveTo(13, 22)
        ..cubicTo(17, 21, 20, 18, 20, 14)
        ..cubicTo(20, 11, 18, 8, 15, 5)
        ..cubicTo(15, 8, 14, 10, 12, 11)
        ..cubicTo(12, 8, 11, 5, 9, 2)
        ..cubicTo(9, 6, 4, 9, 4, 14)
        ..cubicTo(4, 18, 7, 21, 11, 22)
        ..cubicTo(9, 20, 9, 17, 12, 15)
        ..cubicTo(12, 18, 14, 19, 13, 22)
        ..close(),
    ],
    'receipt': <Path>[
      Path()
        ..moveTo(5, 3)
        ..lineTo(19, 3)
        ..lineTo(19, 21)
        ..lineTo(15, 19)
        ..lineTo(12, 21)
        ..lineTo(9, 19)
        ..lineTo(5, 21)
        ..close(),
      Path()
        ..moveTo(8, 8)
        ..lineTo(16, 8),
      Path()
        ..moveTo(8, 12)
        ..lineTo(16, 12),
      Path()
        ..moveTo(8, 16)
        ..lineTo(12, 16),
    ],
    'clock': <Path>[
      Path()
        ..moveTo(12, 7)
        ..lineTo(12, 12)
        ..lineTo(15, 14),
    ],
  };

  static final Map<String, List<Rect>> _circles = <String, List<Rect>>{
    'history': <Rect>[Rect.fromCircle(center: const Offset(12, 12), radius: 9)],
    'eye': <Rect>[Rect.fromCircle(center: const Offset(12, 12), radius: 3)],
    'userPlus': <Rect>[
      Rect.fromCircle(center: const Offset(9, 8), radius: 3.5),
    ],
    'coin': <Rect>[Rect.fromCircle(center: const Offset(12, 12), radius: 10.5)],
    'brand': <Rect>[
      Rect.fromCircle(center: const Offset(6, 19), radius: 3),
      Rect.fromCircle(center: const Offset(18, 5), radius: 3),
    ],
    'profile': <Rect>[Rect.fromCircle(center: const Offset(12, 8), radius: 5)],
    'friends': <Rect>[Rect.fromCircle(center: const Offset(10, 7), radius: 4)],
    'route': <Rect>[
      Rect.fromCircle(center: const Offset(5, 5), radius: 2),
      Rect.fromCircle(center: const Offset(19, 19), radius: 2),
    ],
  };

  @override
  bool shouldRepaint(_MilestracksIconPainter oldDelegate) =>
      name != oldDelegate.name || color != oldDelegate.color;
}
