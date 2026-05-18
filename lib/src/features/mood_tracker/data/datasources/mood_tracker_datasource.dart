import 'package:mood_canvas/src/features/mood_tracker/data/models/mood_tracker_model.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

abstract class MoodTrackerDataSource {
  FutureEither<MoodTrackerModel> logMood({required MoodTrackerModel mood});

  Stream<List<MoodTrackerModel>> watchMoodHistory();
}
