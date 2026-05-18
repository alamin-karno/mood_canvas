import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';

class MoodFacePainter extends CustomPainter {
  MoodFacePainter({
    required this.moodType,
    this.selected = false,
  });

  final MoodType moodType;
  final bool selected;

  /// Builds a tear droplet path for sad mood (used by painter and tests).
  @visibleForTesting
  static Path buildTearPath(Offset origin, double scale) {
    final path = Path()
      ..moveTo(origin.dx, origin.dy)
      ..quadraticBezierTo(
        origin.dx + scale * 0.35,
        origin.dy + scale * 0.45,
        origin.dx,
        origin.dy + scale,
      )
      ..quadraticBezierTo(
        origin.dx - scale * 0.35,
        origin.dy + scale * 0.45,
        origin.dx,
        origin.dy,
      )
      ..close();
    return path;
  }

  /// Builds a subtle cheek blush path for happy mood.
  @visibleForTesting
  static Path buildCheekPath(Offset center, double radius) {
    final path = Path()
      ..addOval(
        Rect.fromCenter(
          center: center,
          width: radius * 0.35,
          height: radius * 0.22,
        ),
      );
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;

    final fillPaint = Paint()
      ..color = moodType.faceColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = selected ? Colors.white : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 3 : 2;

    canvas.drawCircle(center, radius, fillPaint);
    _drawFaceHighlight(canvas, center, radius);
    canvas.drawCircle(center, radius, strokePaint);

    _drawCheeks(canvas, center, radius);
    _drawEyebrows(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);
    _drawTears(canvas, center, radius);
  }

  void _drawFaceHighlight(Canvas canvas, Offset center, double radius) {
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.22)
      ..style = PaintingStyle.fill;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - radius * 0.15, center.dy - radius * 0.35),
        width: radius * 0.55,
        height: radius * 0.4,
      ),
      math.pi * 1.05,
      math.pi * 0.75,
      true,
      highlightPaint,
    );
  }

  void _drawCheeks(Canvas canvas, Offset center, double radius) {
    if (moodType != MoodType.happy) return;

    final cheekPaint = Paint()
      ..color = const Color(0xFFFF8A80).withValues(alpha: 0.45)
      ..style = PaintingStyle.fill;

    for (final side in [-1.0, 1.0]) {
      canvas.drawPath(
        buildCheekPath(
          Offset(center.dx + side * radius * 0.42, center.dy + radius * 0.08),
          radius * 0.28,
        ),
        cheekPaint,
      );
    }
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius) {
    final browPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.065
      ..strokeCap = StrokeCap.round;

    final browY = center.dy - radius * 0.4;
    final browSpan = radius * 0.24;
    final browArc = radius * 0.14;

    switch (moodType) {
      case MoodType.happy:
        for (final side in [-1.0, 1.0]) {
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(center.dx + side * radius * 0.3, browY),
              width: browSpan,
              height: browArc,
            ),
            math.pi * 0.12,
            math.pi * 0.76,
            false,
            browPaint,
          );
        }
      case MoodType.sad:
        for (final side in [-1.0, 1.0]) {
          canvas.drawArc(
            Rect.fromCenter(
              center: Offset(
                center.dx + side * radius * 0.3,
                browY + browArc * 0.35,
              ),
              width: browSpan,
              height: browArc,
            ),
            math.pi * 1.12,
            math.pi * 0.76,
            false,
            browPaint,
          );
        }
      case MoodType.neutral:
        canvas.drawLine(
          Offset(center.dx - radius * 0.4, browY),
          Offset(center.dx - radius * 0.16, browY),
          browPaint,
        );
        canvas.drawLine(
          Offset(center.dx + radius * 0.16, browY),
          Offset(center.dx + radius * 0.4, browY),
          browPaint,
        );
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()..color = Colors.black87;
    final eyeOffset = radius * 0.3;
    final eyeY = center.dy - radius * 0.1;

    final eyeRadius = switch (moodType) {
      MoodType.happy => radius * 0.09,
      MoodType.sad => radius * 0.075,
      MoodType.neutral => radius * 0.08,
    };

    for (final side in [-1.0, 1.0]) {
      canvas.drawCircle(
        Offset(center.dx + side * eyeOffset, eyeY),
        eyeRadius,
        eyePaint,
      );
    }

    if (moodType == MoodType.sad) {
      final lidPaint = Paint()
        ..color = moodType.faceColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.05
        ..strokeCap = StrokeCap.round;
      for (final side in [-1.0, 1.0]) {
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx + side * eyeOffset, eyeY - radius * 0.02),
            width: radius * 0.2,
            height: radius * 0.12,
          ),
          math.pi * 1.05,
          math.pi * 0.7,
          false,
          lidPaint,
        );
      }
    }
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.085
      ..strokeCap = StrokeCap.round;

    switch (moodType) {
      case MoodType.happy:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + radius * 0.25),
            width: radius * 0.55,
            height: radius * 0.38,
          ),
          math.pi * 0.08,
          math.pi * 0.84,
          false,
          mouthPaint,
        );
      case MoodType.sad:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + radius * 0.45),
            width: radius * 0.48,
            height: radius * 0.32,
          ),
          math.pi * 1.08,
          math.pi * 0.84,
          false,
          mouthPaint,
        );
      case MoodType.neutral:
        canvas.drawLine(
          Offset(center.dx - radius * 0.28, center.dy + radius * 0.32),
          Offset(center.dx + radius * 0.28, center.dy + radius * 0.32),
          mouthPaint,
        );
    }
  }

  void _drawTears(Canvas canvas, Offset center, double radius) {
    if (moodType != MoodType.sad) return;

    final tearPaint = Paint()
      ..color = const Color(0xFF4FC3F7).withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final tearScale = radius * 0.14;
    for (final side in [-1.0, 1.0]) {
      canvas.drawPath(
        buildTearPath(
          Offset(
            center.dx + side * radius * 0.34,
            center.dy + radius * 0.02,
          ),
          tearScale,
        ),
        tearPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.moodType != moodType || oldDelegate.selected != selected;
  }
}
