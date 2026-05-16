import 'package:equatable/equatable.dart';

import 'package:mood_canvas/src/core/error/failure.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

enum MoodStatus { initial, loading, loaded, logging, success, failure }

class MoodState extends Equatable {
  const MoodState({
    this.status = MoodStatus.initial,
    this.selectedMood = MoodType.happy,
    this.intensity = 3,
    this.note = '',
    this.history = const [],
    this.failure,
    this.lastLogged,
  });

  final MoodStatus status;
  final MoodType selectedMood;
  final int intensity;
  final String note;
  final List<MoodEntry> history;
  final Failure? failure;
  final MoodEntry? lastLogged;

  bool get isLoading =>
      status == MoodStatus.loading || status == MoodStatus.logging;

  MoodState copyWith({
    MoodStatus? status,
    MoodType? selectedMood,
    int? intensity,
    String? note,
    List<MoodEntry>? history,
    Failure? failure,
    MoodEntry? lastLogged,
    bool clearFailure = false,
    bool clearLastLogged = false,
  }) {
    return MoodState(
      status: status ?? this.status,
      selectedMood: selectedMood ?? this.selectedMood,
      intensity: intensity ?? this.intensity,
      note: note ?? this.note,
      history: history ?? this.history,
      failure: clearFailure ? null : (failure ?? this.failure),
      lastLogged: clearLastLogged ? null : (lastLogged ?? this.lastLogged),
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedMood,
        intensity,
        note,
        history,
        failure,
        lastLogged,
      ];
}
