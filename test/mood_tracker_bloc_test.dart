import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mood_canvas/src/core/error/failure.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/repositories/mood_tracker_repository.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/usecases/log_mood_usecase.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/usecases/watch_mood_history_usecase.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_bloc.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_event.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_state.dart';

class _MockMoodTrackerRepository extends Mock
    implements MoodTrackerRepository {}

void main() {
  late _MockMoodTrackerRepository repository;
  late MoodTrackerBloc bloc;

  setUpAll(() {
    registerFallbackValue(
      MoodEntry(
        id: 'fallback',
        moodType: MoodType.neutral,
        createdAt: DateTime(2026),
      ),
    );
  });

  final sampleEntry = MoodEntry(
    id: '1',
    moodType: MoodType.happy,
    createdAt: DateTime(2026, 5, 16, 12),
  );

  setUp(() {
    repository = _MockMoodTrackerRepository();
    bloc = MoodTrackerBloc(
      logMoodUseCase: LogMoodUseCase(repository),
      watchMoodHistoryUseCase: WatchMoodHistoryUseCase(repository),
    );
  });

  tearDown(() => bloc.close());

  blocTest<MoodTrackerBloc, MoodTrackerState>(
    'loads history when started',
    build: () {
      when(() => repository.watchMoodHistory()).thenAnswer(
        (_) => Stream.value([sampleEntry]),
      );
      return bloc;
    },
    act: (b) => b.add(const MoodTrackerStarted()),
    expect: () => [
      isA<MoodTrackerState>().having(
        (s) => s.status,
        'status',
        MoodTrackerStatus.loading,
      ),
      isA<MoodTrackerState>()
          .having((s) => s.status, 'status', MoodTrackerStatus.loaded)
          .having((s) => s.history, 'history', [sampleEntry]),
    ],
  );

  blocTest<MoodTrackerBloc, MoodTrackerState>(
    'emits success and lastLogged when log succeeds',
    build: () {
      when(() => repository.watchMoodHistory()).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => repository.logMood(entry: any(named: 'entry')),
      ).thenAnswer((_) async => Right(sampleEntry));
      return bloc;
    },
    act: (b) => b.add(const MoodTrackerLogRequested(MoodType.happy)),
    expect: () => [
      isA<MoodTrackerState>().having(
        (s) => s.status,
        'status',
        MoodTrackerStatus.logging,
      ),
      isA<MoodTrackerState>()
          .having((s) => s.status, 'status', MoodTrackerStatus.success)
          .having((s) => s.lastLogged, 'lastLogged', sampleEntry)
          .having((s) => s.selectedMood, 'selectedMood', MoodType.happy),
    ],
  );

  blocTest<MoodTrackerBloc, MoodTrackerState>(
    'emits failure when log fails',
    build: () {
      when(() => repository.watchMoodHistory()).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => repository.logMood(entry: any(named: 'entry')),
      ).thenAnswer(
        (_) async => const Left(CacheFailure('Could not save mood')),
      );
      return bloc;
    },
    act: (b) => b.add(const MoodTrackerLogRequested(MoodType.sad)),
    expect: () => [
      isA<MoodTrackerState>().having(
        (s) => s.status,
        'status',
        MoodTrackerStatus.logging,
      ),
      isA<MoodTrackerState>()
          .having((s) => s.status, 'status', MoodTrackerStatus.failure)
          .having(
            (s) => s.failure,
            'failure',
            isA<CacheFailure>(),
          ),
    ],
  );
}
