import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/entities/mood_type.dart';

class MoodFacePainter extends CustomPainter {
  MoodFacePainter({
    required this.moodType,
    required this.intensity,
    this.selected = false,
  });

  final MoodType moodType;
  final int intensity;
  final bool selected;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 * 0.9;
    final paint = Paint()
      ..color = _faceColor()
      ..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = selected ? Colors.white : Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = selected ? 3 : 2;

    canvas.drawCircle(center, radius, paint);
    canvas.drawCircle(center, radius, stroke);

    _drawEyes(canvas, center, radius);
    _drawMouth(canvas, center, radius);
  }

  Color _faceColor() {
    switch (moodType) {
      case MoodType.happy:
        return const Color(0xFFFFD54F);
      case MoodType.neutral:
        return const Color(0xFF81D4FA);
      case MoodType.sad:
        return const Color(0xFF90A4AE);
    }
  }

  void _drawEyes(Canvas canvas, Offset center, double radius) {
    final eyePaint = Paint()..color = Colors.black87;
    final eyeOffset = radius * 0.28;
    final eyeRadius = radius * 0.08 * (1 + intensity * 0.05);
    canvas.drawCircle(
      Offset(center.dx - eyeOffset, center.dy - radius * 0.15),
      eyeRadius,
      eyePaint,
    );
    canvas.drawCircle(
      Offset(center.dx + eyeOffset, center.dy - radius * 0.15),
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

    final mouthY = center.dy + radius * 0.2;
    final mouthWidth = radius * 0.45;

    switch (moodType) {
      case MoodType.happy:
        final path = Path()
          ..moveTo(center.dx - mouthWidth, mouthY)
          ..quadraticBezierTo(
            center.dx,
            mouthY + radius * 0.35 * (intensity / 5),
            center.dx + mouthWidth,
            mouthY,
          );
        canvas.drawPath(path, mouthPaint);
      case MoodType.sad:
        final path = Path()
          ..moveTo(center.dx - mouthWidth, mouthY + radius * 0.15)
          ..quadraticBezierTo(
            center.dx,
            mouthY - radius * 0.2,
            center.dx + mouthWidth,
            mouthY + radius * 0.15,
          );
        canvas.drawPath(path, mouthPaint);
      case MoodType.neutral:
        canvas.drawLine(
          Offset(center.dx - mouthWidth * 0.7, mouthY),
          Offset(center.dx + mouthWidth * 0.7, mouthY),
          mouthPaint,
        );
    }
  }

  @override
  bool shouldRepaint(covariant MoodFacePainter oldDelegate) {
    return oldDelegate.moodType != moodType ||
        oldDelegate.intensity != intensity ||
        oldDelegate.selected != selected;
  }
}
