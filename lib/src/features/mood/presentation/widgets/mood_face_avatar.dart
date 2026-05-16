import 'package:flutter/material.dart';

import '../../domain/entities/mood_type.dart';
import '../painters/mood_face_painter.dart';

class MoodFaceAvatar extends StatelessWidget {
  const MoodFaceAvatar({
    super.key,
    required this.moodType,
    required this.size,
    this.intensity = 3,
    this.selected = false,
  });

  final MoodType moodType;
  final double size;
  final int intensity;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.08 : 1,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: CustomPaint(
        size: Size.square(size),
        painter: MoodFacePainter(
          moodType: moodType,
          intensity: intensity,
          selected: selected,
        ),
      ),
    );
  }
}
