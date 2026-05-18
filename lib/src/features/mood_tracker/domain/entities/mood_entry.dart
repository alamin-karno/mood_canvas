import 'package:equatable/equatable.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.moodType,
    required this.createdAt,
  });

  final String id;
  final MoodType moodType;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, moodType, createdAt];
}
