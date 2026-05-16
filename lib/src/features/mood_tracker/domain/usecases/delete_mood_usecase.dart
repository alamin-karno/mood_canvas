import 'package:mood_canvas/src/utils/typedefs.dart';

import '../repositories/mood_tracker_repository.dart';

class DeleteMoodUseCase {
  const DeleteMoodUseCase(this._repository);

  final MoodTrackerRepository _repository;

  FutureEither<void> call({
    required String userId,
    required String moodId,
  }) {
    return _repository.deleteMood(userId: userId, moodId: moodId);
  }
}
