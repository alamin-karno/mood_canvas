import '../entities/mood_entry.dart';
import '../repositories/mood_tracker_repository.dart';

class WatchMoodHistoryUseCase {
  const WatchMoodHistoryUseCase(this._repository);

  final MoodTrackerRepository _repository;

  Stream<List<MoodEntry>> call({required String userId}) {
    return _repository.watchMoodHistory(userId: userId);
  }
}
