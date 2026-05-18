import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/usecases/log_mood_usecase.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/usecases/watch_mood_history_usecase.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_event.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_state.dart';

class MoodTrackerBloc extends Bloc<MoodTrackerEvent, MoodTrackerState> {
  MoodTrackerBloc({
    required LogMoodUseCase logMoodUseCase,
    required WatchMoodHistoryUseCase watchMoodHistoryUseCase,
  })  : _logMoodUseCase = logMoodUseCase,
        _watchMoodHistoryUseCase = watchMoodHistoryUseCase,
        super(const MoodTrackerState()) {
    on<MoodTrackerStarted>(_onStarted);
    on<MoodTrackerHistoryUpdated>(_onHistoryUpdated);
    on<MoodTrackerLogRequested>(_onLogRequested);
  }

  final LogMoodUseCase _logMoodUseCase;
  final WatchMoodHistoryUseCase _watchMoodHistoryUseCase;
  StreamSubscription<List<MoodEntry>>? _historySub;

  Future<void> _onStarted(
    MoodTrackerStarted event,
    Emitter<MoodTrackerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MoodTrackerStatus.loading,
        clearFailure: true,
      ),
    );
    await _historySub?.cancel();
    _historySub = _watchMoodHistoryUseCase().listen(
      (entries) => add(MoodTrackerHistoryUpdated(entries)),
      onError: (_, __) => emit(
        state.copyWith(status: MoodTrackerStatus.failure),
      ),
    );
  }

  void _onHistoryUpdated(
    MoodTrackerHistoryUpdated event,
    Emitter<MoodTrackerState> emit,
  ) {
    emit(
      state.copyWith(
        status: MoodTrackerStatus.loaded,
        history: event.entries,
      ),
    );
  }

  Future<void> _onLogRequested(
    MoodTrackerLogRequested event,
    Emitter<MoodTrackerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MoodTrackerStatus.logging,
        selectedMood: event.moodType,
        clearFailure: true,
      ),
    );
    final entry = MoodEntry(
      id: '',
      moodType: event.moodType,
      createdAt: DateTime.now(),
    );
    final result = await _logMoodUseCase(entry: entry);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MoodTrackerStatus.failure,
          failure: failure,
        ),
      ),
      (logged) => emit(
        state.copyWith(
          status: MoodTrackerStatus.success,
          lastLogged: logged,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    unawaited(_historySub?.cancel());
    return super.close();
  }
}
