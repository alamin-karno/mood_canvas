import 'package:mood_canvas/src/utils/typedefs.dart';

import '../entities/mood_entry.dart';

abstract class MoodTrackerRepository {
  FutureEither<MoodEntry> logMood({required MoodEntry entry});

  Stream<List<MoodEntry>> watchMoodHistory();
}
