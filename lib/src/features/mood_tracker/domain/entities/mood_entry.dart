import 'package:equatable/equatable.dart';

import 'mood_type.dart';

class MoodEntry extends Equatable {
  const MoodEntry({
    required this.id,
    required this.userId,
    required this.moodType,
    required this.intensity,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final MoodType moodType;
  final int intensity;
  final String? note;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, userId, moodType, intensity, note, createdAt];
}
