import 'package:equatable/equatable.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

abstract class MoodTrackerEvent extends Equatable {
  const MoodTrackerEvent();

  @override
  List<Object?> get props => [];
}

class MoodTrackerHistorySubscriptionRequested extends MoodTrackerEvent {
  const MoodTrackerHistorySubscriptionRequested({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MoodTrackerHistoryUpdated extends MoodTrackerEvent {
  const MoodTrackerHistoryUpdated(this.entries);

  final List<MoodEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class MoodTrackerTypeSelected extends MoodTrackerEvent {
  const MoodTrackerTypeSelected(this.moodType);

  final MoodType moodType;

  @override
  List<Object?> get props => [moodType];
}

class MoodTrackerIntensityChanged extends MoodTrackerEvent {
  const MoodTrackerIntensityChanged(this.intensity);

  final int intensity;

  @override
  List<Object?> get props => [intensity];
}

class MoodTrackerNoteChanged extends MoodTrackerEvent {
  const MoodTrackerNoteChanged(this.note);

  final String note;

  @override
  List<Object?> get props => [note];
}

class MoodTrackerLogSubmitted extends MoodTrackerEvent {
  const MoodTrackerLogSubmitted({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MoodTrackerDeleteRequested extends MoodTrackerEvent {
  const MoodTrackerDeleteRequested({
    required this.userId,
    required this.moodId,
  });

  final String userId;
  final String moodId;

  @override
  List<Object?> get props => [userId, moodId];
}
