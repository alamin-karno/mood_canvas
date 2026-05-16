import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/painters/mood_face_painter.dart';

void main() {
  test('MoodFacePainter shouldRepaint when mood changes', () {
    final painterA = MoodFacePainter(moodType: MoodType.happy);
    final painterB = MoodFacePainter(moodType: MoodType.sad);

    expect(painterA.shouldRepaint(painterB), isTrue);
  });
}
