import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_model.dart';

abstract class MoodRemoteDataSource {
  FutureEither<MoodModel> logMood({required String userId, required MoodModel mood});

  Stream<List<MoodModel>> watchMoodHistory({required String userId});

  FutureEither<List<MoodModel>> getMoodByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  });

  FutureEither<void> deleteMood({
    required String userId,
    required String moodId,
  });
}
