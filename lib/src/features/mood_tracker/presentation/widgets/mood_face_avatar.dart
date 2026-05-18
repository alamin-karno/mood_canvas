import 'package:flutter/material.dart';

import '../../../../theme/app_curves.dart';
import '../../../../theme/app_durations.dart';
import '../../domain/entities/mood_type.dart';
import '../painters/mood_face_painter.dart';

class MoodFaceAvatar extends StatelessWidget {
  const MoodFaceAvatar({
    super.key,
    required this.moodType,
    required this.size,
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
