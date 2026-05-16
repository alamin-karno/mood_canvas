import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/usecases/delete_mood_usecase.dart';
import '../../domain/usecases/log_mood_usecase.dart';
import '../../domain/usecases/watch_mood_history_usecase.dart';
import 'mood_event.dart';
import 'mood_state.dart';

class MoodBloc extends Bloc<MoodEvent, MoodState> {
  MoodBloc({
    required LogMoodUseCase logMoodUseCase,
    required WatchMoodHistoryUseCase watchMoodHistoryUseCase,
    required DeleteMoodUseCase deleteMoodUseCase,
  })  : _logMoodUseCase = logMoodUseCase,
        _watchMoodHistoryUseCase = watchMoodHistoryUseCase,
        _deleteMoodUseCase = deleteMoodUseCase,
        super(const MoodState()) {
    on<MoodHistorySubscriptionRequested>(_onHistorySubscriptionRequested);
    on<MoodHistoryUpdated>(_onHistoryUpdated);
    on<MoodTypeSelected>(_onMoodTypeSelected);
    on<MoodIntensityChanged>(_onIntensityChanged);
    on<MoodNoteChanged>(_onNoteChanged);
    on<MoodLogSubmitted>(_onLogSubmitted);
    on<MoodDeleteRequested>(_onDeleteRequested);
  }

  final LogMoodUseCase _logMoodUseCase;
  final WatchMoodHistoryUseCase _watchMoodHistoryUseCase;
  final DeleteMoodUseCase _deleteMoodUseCase;
  StreamSubscription<List<MoodEntry>>? _historySub;

  Future<void> _onHistorySubscriptionRequested(
    MoodHistorySubscriptionRequested event,
    Emitter<MoodState> emit,
  ) async {
    emit(state.copyWith(status: MoodStatus.loading, clearFailure: true));
    await _historySub?.cancel();
    _historySub = _watchMoodHistoryUseCase(userId: event.userId).listen(
      (entries) => add(MoodHistoryUpdated(entries)),
      onError: (_, __) => emit(
        state.copyWith(status: MoodStatus.failure),
      ),
    );
  }

  void _onHistoryUpdated(MoodHistoryUpdated event, Emitter<MoodState> emit) {
    emit(
      state.copyWith(
        status: MoodStatus.loaded,
        history: event.entries,
      ),
    );
  }

  void _onMoodTypeSelected(MoodTypeSelected event, Emitter<MoodState> emit) {
    emit(state.copyWith(selectedMood: event.moodType));
  }

  void _onIntensityChanged(
    MoodIntensityChanged event,
    Emitter<MoodState> emit,
  ) {
    emit(state.copyWith(intensity: event.intensity));
  }

  void _onNoteChanged(MoodNoteChanged event, Emitter<MoodState> emit) {
    emit(state.copyWith(note: event.note));
  }

  Future<void> _onLogSubmitted(
    MoodLogSubmitted event,
    Emitter<MoodState> emit,
  ) async {
    emit(state.copyWith(status: MoodStatus.logging, clearFailure: true));
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
        state.copyWith(status: MoodStatus.failure, failure: failure),
      ),
      (logged) => emit(
        state.copyWith(
          status: MoodStatus.success,
          lastLogged: logged,
          note: '',
        ),
      ),
    );
  }

  Future<void> _onDeleteRequested(
    MoodDeleteRequested event,
    Emitter<MoodState> emit,
  ) async {
    final result = await _deleteMoodUseCase(
      userId: event.userId,
      moodId: event.moodId,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(status: MoodStatus.failure, failure: failure),
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
