import '../entities/mood_entry.dart';
import '../repositories/mood_repository.dart';

class WatchMoodHistoryUseCase {
  const WatchMoodHistoryUseCase(this._repository);

  final MoodRepository _repository;

  Stream<List<MoodEntry>> call({required String userId}) {
    return _repository.watchMoodHistory(userId: userId);
  }
}
