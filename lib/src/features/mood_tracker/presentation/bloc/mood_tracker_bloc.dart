import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/usecases/delete_mood_usecase.dart';
import '../../domain/usecases/log_mood_usecase.dart';
import '../../domain/usecases/watch_mood_history_usecase.dart';
import 'mood_tracker_event.dart';
import 'mood_tracker_state.dart';

class MoodTrackerBloc extends Bloc<MoodTrackerEvent, MoodTrackerState> {
  MoodTrackerBloc({
    required LogMoodUseCase logMoodUseCase,
    required WatchMoodHistoryUseCase watchMoodHistoryUseCase,
    required DeleteMoodUseCase deleteMoodUseCase,
  })  : _logMoodUseCase = logMoodUseCase,
        _watchMoodHistoryUseCase = watchMoodHistoryUseCase,
        _deleteMoodUseCase = deleteMoodUseCase,
        super(const MoodTrackerState()) {
    on<MoodTrackerHistorySubscriptionRequested>(
      _onHistorySubscriptionRequested,
    );
    on<MoodTrackerHistoryUpdated>(_onHistoryUpdated);
    on<MoodTrackerTypeSelected>(_onMoodTypeSelected);
    on<MoodTrackerIntensityChanged>(_onIntensityChanged);
    on<MoodTrackerNoteChanged>(_onNoteChanged);
    on<MoodTrackerLogSubmitted>(_onLogSubmitted);
    on<MoodTrackerDeleteRequested>(_onDeleteRequested);
  }

  final LogMoodUseCase _logMoodUseCase;
  final WatchMoodHistoryUseCase _watchMoodHistoryUseCase;
  final DeleteMoodUseCase _deleteMoodUseCase;
  StreamSubscription<List<MoodEntry>>? _historySub;

  Future<void> _onHistorySubscriptionRequested(
    MoodTrackerHistorySubscriptionRequested event,
    Emitter<MoodTrackerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MoodTrackerStatus.loading,
        clearFailure: true,
      ),
    );
    await _historySub?.cancel();
    _historySub = _watchMoodHistoryUseCase(userId: event.userId).listen(
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

  void _onMoodTypeSelected(
    MoodTrackerTypeSelected event,
    Emitter<MoodTrackerState> emit,
  ) {
    emit(state.copyWith(selectedMood: event.moodType));
  }

  void _onIntensityChanged(
    MoodTrackerIntensityChanged event,
    Emitter<MoodTrackerState> emit,
  ) {
    emit(state.copyWith(intensity: event.intensity));
  }

  void _onNoteChanged(
    MoodTrackerNoteChanged event,
    Emitter<MoodTrackerState> emit,
  ) {
    emit(state.copyWith(note: event.note));
  }

  Future<void> _onLogSubmitted(
    MoodTrackerLogSubmitted event,
    Emitter<MoodTrackerState> emit,
  ) async {
    emit(
      state.copyWith(
        status: MoodTrackerStatus.logging,
        clearFailure: true,
      ),
    );
    final entry = MoodEntry(
      id: '',
      userId: event.userId,
      moodType: state.selectedMood,
      intensity: state.intensity,
      note: state.note.isEmpty ? null : state.note,
      createdAt: DateTime.now(),
    );
    final result = await _logMoodUseCase(userId: event.userId, entry: entry);
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
          note: '',
        ),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    MoodTrackerDeleteRequested event,
    Emitter<MoodTrackerState> emit,
  ) async {
    final result = await _deleteMoodUseCase(
      userId: event.userId,
      moodId: event.moodId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: MoodTrackerStatus.failure,
          failure: failure,
        ),
      ),
      (_) {},
    );
  }

  @override
  Future<void> close() {
    _historySub?.cancel();
    return super.close();
  }
}
