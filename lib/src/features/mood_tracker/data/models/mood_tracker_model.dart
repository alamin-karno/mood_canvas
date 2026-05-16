import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory MoodTrackerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return MoodTrackerModel(
      id: doc.id,
      moodType: data['moodType'] as String? ?? MoodType.neutral.name,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'moodType': moodType,
      'createdAt': Timestamp.fromDate(createdAt),
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
