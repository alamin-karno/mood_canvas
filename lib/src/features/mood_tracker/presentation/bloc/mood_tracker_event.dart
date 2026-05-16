import 'package:equatable/equatable.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

abstract class MoodEvent extends Equatable {
  const MoodEvent();

  @override
  List<Object?> get props => [];
}

class MoodHistorySubscriptionRequested extends MoodEvent {
  const MoodHistorySubscriptionRequested({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MoodHistoryUpdated extends MoodEvent {
  const MoodHistoryUpdated(this.entries);

  final List<MoodEntry> entries;

  @override
  List<Object?> get props => [entries];
}

class MoodTypeSelected extends MoodEvent {
  const MoodTypeSelected(this.moodType);

  final MoodType moodType;

  @override
  List<Object?> get props => [moodType];
}

class MoodIntensityChanged extends MoodEvent {
  const MoodIntensityChanged(this.intensity);

  final int intensity;

  @override
  List<Object?> get props => [intensity];
}

class MoodNoteChanged extends MoodEvent {
  const MoodNoteChanged(this.note);

  final String note;

  @override
  List<Object?> get props => [note];
}

class MoodLogSubmitted extends MoodEvent {
  const MoodLogSubmitted({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class MoodDeleteRequested extends MoodEvent {
  const MoodDeleteRequested({
    required this.userId,
    required this.moodId,
  });

  final String userId;
  final String moodId;

  @override
  List<Object?> get props => [userId, moodId];
}
