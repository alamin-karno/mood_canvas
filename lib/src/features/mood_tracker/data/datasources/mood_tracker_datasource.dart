import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_tracker_model.dart';

abstract class MoodTrackerDataSource {
  FutureEither<MoodTrackerModel> logMood({required MoodTrackerModel mood});

  Stream<List<MoodTrackerModel>> watchMoodHistory();
}
