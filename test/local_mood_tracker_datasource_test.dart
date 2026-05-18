import 'package:flutter_test/flutter_test.dart';
import 'package:mood_canvas/src/features/mood_tracker/data/datasources/local_mood_tracker_datasource.dart';
import 'package:mood_canvas/src/features/mood_tracker/data/models/mood_tracker_model.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/services/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalMoodTrackerDataSource dataSource;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await StorageService.instance.init();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    dataSource = LocalMoodTrackerDataSource();
  });

  MoodTrackerModel entry(int index) => MoodTrackerModel(
        id: 'id-$index',
        moodType: MoodType.happy.name,
        createdAt: DateTime(2026, 5, index + 1),
      );

  test('keeps at most seven entries, newest first', () async {
    for (var i = 0; i < 9; i++) {
      final result = await dataSource.logMood(mood: entry(i));
      expect(result.isRight(), isTrue);
    }

    final history = await dataSource.watchMoodHistory().first;
    expect(history.length, 7);
    expect(history.first.id, 'id-8');
    expect(history.last.id, 'id-2');
  });

  test('watchMoodHistory emits updates after logging', () async {
    final emissions = <List<MoodTrackerModel>>[];
    final sub = dataSource.watchMoodHistory().listen(emissions.add);

    await Future<void>.delayed(Duration.zero);
    await dataSource.logMood(
      mood: MoodTrackerModel(
        id: '',
        moodType: MoodType.neutral.name,
        createdAt: DateTime(2026, 5, 18),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    await sub.cancel();
    expect(emissions.length, greaterThanOrEqualTo(2));
    expect(
      emissions.last.any((m) => m.moodType == MoodType.neutral.name),
      isTrue,
    );
  });
}
