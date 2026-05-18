import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

class LogMoodUseCase {
  const LogMoodUseCase(this._repository);

  final MoodTrackerRepository _repository;

  FutureEither<MoodEntry> call({required MoodEntry entry}) {
    return _repository.logMood(entry: entry);
  }
}
