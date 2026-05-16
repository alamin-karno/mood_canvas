import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/mood_type.dart';

class MoodFacePainter extends CustomPainter {
  MoodFacePainter({
    required this.moodType,
    this.selected = false,
  });

  final MoodType moodType;
  final bool selected;

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
    canvas.drawCircle(center, radius, strokePaint);

    _drawEyebrows(canvas, center, radius);
    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);
  }

  void _drawEyebrows(Canvas canvas, Offset center, double radius) {
    final browPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.06
      ..strokeCap = StrokeCap.round;

    final browY = center.dy - radius * 0.38;
    final browSpan = radius * 0.22;
    final browArc = radius * 0.12;

    switch (moodType) {
      case MoodType.happy:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx - radius * 0.28, browY),
            width: browSpan,
            height: browArc,
          ),
          math.pi * 0.15,
          math.pi * 0.7,
          false,
          browPaint,
        );
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx + radius * 0.28, browY),
            width: browSpan,
            height: browArc,
          ),
          math.pi * 0.15,
          math.pi * 0.7,
          false,
          browPaint,
        );
      case MoodType.sad:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx - radius * 0.28, browY + browArc * 0.3),
            width: browSpan,
            height: browArc,
          ),
          math.pi * 1.15,
          math.pi * 0.7,
          false,
          browPaint,
        );
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx + radius * 0.28, browY + browArc * 0.3),
            width: browSpan,
            height: browArc,
          ),
          math.pi * 1.15,
          math.pi * 0.7,
          false,
          browPaint,
        );
      case MoodType.neutral:
        canvas.drawLine(
          Offset(center.dx - radius * 0.38, browY),
          Offset(center.dx - radius * 0.18, browY),
          browPaint,
        );
        canvas.drawLine(
          Offset(center.dx + radius * 0.18, browY),
          Offset(center.dx + radius * 0.38, browY),
          browPaint,
        );
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()..color = Colors.black87;
    final eyeOffset = radius * 0.28;
    final eyeRadius = radius * 0.08;
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, center.dy - radius * 0.12),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, center.dy - radius * 0.12),
      eyeRadius,
      eyePaint,
    );
  }

  void _drawMouth(Canvas canvas, Offset center, double radius) {
    final mouthPaint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..strokeCap = StrokeCap.round;

    final mouthWidth = radius * 0.5;

    switch (moodType) {
      case MoodType.happy:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + radius * 0.28),
            width: mouthWidth,
            height: radius * 0.35,
          ),
          math.pi * 0.1,
          math.pi * 0.8,
          false,
          mouthPaint,
        );
      case MoodType.sad:
        canvas.drawArc(
          Rect.fromCenter(
            center: Offset(center.dx, center.dy + radius * 0.42),
            width: mouthWidth,
            height: radius * 0.35,
          ),
          math.pi * 1.1,
          math.pi * 0.8,
          false,
          mouthPaint,
        );
      case MoodType.neutral:
        canvas.drawLine(
          Offset(center.dx - mouthWidth * 0.6, center.dy + radius * 0.3),
          Offset(center.dx + mouthWidth * 0.6, center.dy + radius * 0.3),
          mouthPaint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.moodType != moodType ||
        oldDelegate.selected != selected;
  }
}
