import 'package:mood_canvas/src/core/utils/typedefs.dart';
import 'package:mood_canvas/src/features/mood_tracker/data/models/mood_tracker_model.dart';

abstract class MoodTrackerDataSource {
  FutureEither<MoodTrackerModel> logMood({required MoodTrackerModel mood});

  Stream<List<MoodTrackerModel>> watchMoodHistory();
}
