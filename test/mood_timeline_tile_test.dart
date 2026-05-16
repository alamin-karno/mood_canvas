import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/widgets/mood_timeline_tile.dart';

void main() {
  testWidgets('MoodTimelineTile shows date and face', (tester) async {
    final entry = MoodEntry(
      id: '1',
      moodType: MoodType.happy,
      createdAt: DateTime(2026, 5, 16),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MoodTimelineTile(entry: entry),
        ),
      ),
    );

    expect(find.text('May 16'), findsOneWidget);
    expect(find.byType(MoodTimelineTile), findsOneWidget);
  });
}
