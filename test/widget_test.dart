import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood/presentation/painters/mood_face_painter.dart';

void main() {
  test('MoodFacePainter shouldRepaint when mood changes', () {
    final painterA = MoodFacePainter(
      moodType: MoodType.happy,
      intensity: 3,
    );
    final painterB = MoodFacePainter(
      moodType: MoodType.sad,
      intensity: 3,
    );

    expect(painterA.shouldRepaint(painterB), isTrue);
  });
}
