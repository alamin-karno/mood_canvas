import 'package:mood_canvas/src/utils/typedefs.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/repositories/mood_repository.dart';
import '../datasources/mood_remote_datasource.dart';
import '../models/mood_model.dart';

class MoodRepositoryImpl implements MoodRepository {
  MoodRepositoryImpl({required MoodRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final MoodRemoteDataSource _remoteDataSource;

  @override
  FutureEither<MoodEntry> logMood({
    required String userId,
    required MoodEntry entry,
  }) async {
    final result = await _remoteDataSource.logMood(
      userId: userId,
      mood: MoodModel.fromEntity(entry),
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Stream<List<MoodEntry>> watchMoodHistory({required String userId}) {
    return _remoteDataSource
        .watchMoodHistory(userId: userId)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  FutureEither<List<MoodEntry>> getMoodByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    final result = await _remoteDataSource.getMoodByDateRange(
      userId: userId,
      start: start,
      end: end,
    );
    return result.map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  FutureEither<void> deleteMood({
    required String userId,
    required String moodId,
  }) {
    return _remoteDataSource.deleteMood(userId: userId, moodId: moodId);
  }
}
