import 'package:mood_canvas/src/core/utils/typedefs.dart';
import 'package:mood_canvas/src/features/mood_tracker/data/datasources/mood_tracker_datasource.dart';
import 'package:mood_canvas/src/features/mood_tracker/data/models/mood_tracker_model.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';

class MoodTrackerRepositoryImpl implements MoodTrackerRepository {
  MoodTrackerRepositoryImpl({required MoodTrackerDataSource dataSource})
      : _dataSource = dataSource;

  final MoodTrackerDataSource _dataSource;

  @override
  FutureEither<MoodEntry> logMood({required MoodEntry entry}) async {
    final result = await _dataSource.logMood(
      mood: MoodTrackerModel.fromEntity(entry),
    );
    return result.map((model) => model.toEntity());
  }

  @override
  Stream<List<MoodEntry>> watchMoodHistory() {
    return _dataSource
        .watchMoodHistory()
        .map((models) => models.map((m) => m.toEntity()).toList());
  }
}
