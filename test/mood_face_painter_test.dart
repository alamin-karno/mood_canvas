import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/painters/mood_face_painter.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/widgets/mood_face_avatar.dart';

void main() {
  testWidgets('MoodFaceAvatar renders for each mood type', (tester) async {
    for (final mood in MoodType.values) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: MoodFaceAvatar(
                moodType: mood,
                size: 80,
              ),
            ),
          ),
        ),
      );
      expect(find.byType(MoodFaceAvatar), findsOneWidget);
    }
  });

  test('MoodFacePainter paints without error for each mood', () {
    const size = Size(80, 80);
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    for (final mood in MoodType.values) {
      final painter = MoodFacePainter(moodType: mood);
      painter.paint(canvas, size);
    }

    recorder.endRecording();
  });

  test('MoodType accent colors are distinct', () {
    final colors = MoodType.values.map((m) => m.accentColor).toSet();
    expect(colors.length, MoodType.values.length);
  });
}
