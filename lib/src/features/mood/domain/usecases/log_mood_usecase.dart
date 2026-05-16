import 'package:mood_canvas/src/utils/typedefs.dart';

import '../entities/mood_entry.dart';
import '../repositories/mood_repository.dart';

class LogMoodUseCase {
  const LogMoodUseCase(this._repository);

  final MoodRepository _repository;

  FutureEither<MoodEntry> call({
    required String userId,
    required MoodEntry entry,
  }) {
    return _repository.logMood(userId: userId, entry: entry);
  }
}
