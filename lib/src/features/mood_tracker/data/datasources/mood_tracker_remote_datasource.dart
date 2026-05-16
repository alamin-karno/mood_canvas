import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_tracker_model.dart';

abstract class MoodTrackerRemoteDataSource {
  FutureEither<MoodTrackerModel> logMood({
    required String userId,
    required MoodTrackerModel mood,
  });

  Stream<List<MoodTrackerModel>> watchMoodHistory({required String userId});

  FutureEither<List<MoodTrackerModel>> getMoodByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  });

  FutureEither<void> deleteMood({
    required String userId,
    required String moodId,
  });
}
