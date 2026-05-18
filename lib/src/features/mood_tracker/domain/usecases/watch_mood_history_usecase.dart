import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';

class WatchMoodHistoryUseCase {
  const WatchMoodHistoryUseCase(this._repository);

  final MoodTrackerRepository _repository;

  Stream<List<MoodEntry>> call() {
    return _repository.watchMoodHistory();
  }
}
