import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/widgets/mood_face_avatar.dart';

void main() {
  testWidgets('MoodFaceAvatar renders without error', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: MoodFaceAvatar(
              moodType: MoodType.happy,
              size: 80,
              intensity: 3,
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MoodFaceAvatar), findsOneWidget);
  });
}
