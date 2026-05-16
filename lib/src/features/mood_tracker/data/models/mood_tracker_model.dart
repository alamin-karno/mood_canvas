import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

class MoodTrackerModel {
  const MoodTrackerModel({
    required this.id,
    required this.moodType,
    required this.createdAt,
  });

  final String id;
  final String moodType;
  final DateTime createdAt;

  factory MoodTrackerModel.fromJson(Map<String, dynamic> json) {
    return MoodTrackerModel(
      id: json['id'] as String,
      moodType: json['moodType'] as String? ?? MoodType.neutral.name,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moodType': moodType,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  MoodEntry toEntity() {
    return MoodEntry(
      id: id,
      moodType: MoodType.values.byName(moodType),
      createdAt: createdAt,
    );
  }

  factory MoodTrackerModel.fromEntity(MoodEntry entry) {
    return MoodTrackerModel(
      id: entry.id,
      moodType: entry.moodType.name,
      createdAt: entry.createdAt,
    );
  }
}
