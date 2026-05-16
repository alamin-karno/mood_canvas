import 'package:equatable/equatable.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

abstract class MoodTrackerEvent extends Equatable {
  const MoodTrackerEvent();

  @override
  List<Object?> get props => [];
}

class MoodTrackerStarted extends MoodTrackerEvent {
  const MoodTrackerStarted();
}

class MoodTrackerHistoryUpdated extends MoodTrackerEvent {
  const MoodTrackerHistoryUpdated(this.entries);

  final List<MoodEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class MoodTrackerLogRequested extends MoodTrackerEvent {
  const MoodTrackerLogRequested(this.moodType);

  final MoodType moodType;

  @override
  List<Object?> get props => [moodType];
}
