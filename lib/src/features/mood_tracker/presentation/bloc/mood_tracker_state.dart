import 'package:equatable/equatable.dart';
import 'package:mood_canvas/src/core/error/failure.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';

enum MoodTrackerStatus {
  initial,
  loading,
  loaded,
  logging,
  success,
  failure,
}

class MoodTrackerState extends Equatable {
  const MoodTrackerState({
    this.status = MoodTrackerStatus.initial,
    this.selectedMood = MoodType.happy,
    this.history = const [],
    this.failure,
    this.lastLogged,
  });

  final MoodTrackerStatus status;
  final MoodType selectedMood;
  final List<MoodEntry> history;
  final Failure? failure;
  final MoodEntry? lastLogged;

  bool get isLoading =>
      status == MoodTrackerStatus.loading ||
      status == MoodTrackerStatus.logging;

  MoodTrackerState copyWith({
    MoodTrackerStatus? status,
    MoodType? selectedMood,
    List<MoodEntry>? history,
    Failure? failure,
    MoodEntry? lastLogged,
    bool clearFailure = false,
    bool clearLastLogged = false,
  }) {
    return MoodTrackerState(
      status: status ?? this.status,
      selectedMood: selectedMood ?? this.selectedMood,
      history: history ?? this.history,
      failure: clearFailure ? null : (failure ?? this.failure),
      lastLogged: clearLastLogged ? null : (lastLogged ?? this.lastLogged),
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedMood,
        history,
        failure,
        lastLogged,
      ];
}
