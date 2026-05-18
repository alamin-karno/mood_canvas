import 'package:flutter/material.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/painters/mood_face_painter.dart';
import 'package:mood_canvas/src/theme/app_curves.dart';
import 'package:mood_canvas/src/theme/app_durations.dart';

class MoodFaceAvatar extends StatelessWidget {
  const MoodFaceAvatar({
    required this.moodType,
    required this.size,
    super.key,
    this.selected = false,
  });

  final MoodType moodType;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: selected ? 1.1 : 1,
      duration: AppDurations.quick,
      curve: AppCurves.microInteraction,
      child: CustomPaint(
        size: Size.square(size),
        painter: MoodFacePainter(
          moodType: moodType,
          selected: selected,
        ),
      ),
    );
  }
}
