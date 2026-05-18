import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

abstract class MoodTrackerRepository {
  FutureEither<MoodEntry> logMood({required MoodEntry entry});

  Stream<List<MoodEntry>> watchMoodHistory();
}
