import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';

class MoodModel {
  const MoodModel({
    required this.id,
    required this.userId,
    required this.moodType,
    required this.intensity,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final String moodType;
  final int intensity;
  final String? note;
  final DateTime createdAt;

  factory MoodModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return MoodModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      moodType: data['moodType'] as String? ?? MoodType.calm.name,
      intensity: (data['intensity'] as num?)?.toInt() ?? 3,
      note: data['note'] as String?,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'moodType': moodType,
      'intensity': intensity,
      if (note != null) 'note': note,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  MoodEntry toEntity() {
    return MoodEntry(
      id: id,
      userId: userId,
      moodType: MoodType.values.byName(moodType),
      intensity: intensity,
      note: note,
      createdAt: createdAt,
    );
  }

  factory MoodModel.fromEntity(MoodEntry entry) {
    return MoodModel(
      id: entry.id,
      userId: entry.userId,
      moodType: entry.moodType.name,
      intensity: entry.intensity,
      note: entry.note,
      createdAt: entry.createdAt,
    );
  }
}
