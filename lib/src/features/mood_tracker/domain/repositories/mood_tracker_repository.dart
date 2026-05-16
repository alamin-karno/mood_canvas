import 'package:mood_canvas/src/utils/typedefs.dart';

import '../entities/mood_entry.dart';

abstract class MoodTrackerRepository {
  FutureEither<MoodEntry> logMood({
    required String userId,
    required MoodEntry entry,
  });

  Stream<List<MoodEntry>> watchMoodHistory({required String userId});

  FutureEither<List<MoodEntry>> getMoodByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  });

  FutureEither<void> deleteMood({
    required String userId,
    required String moodId,
  });
}
