import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mood_canvas/src/core/error/error.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_model.dart';
import 'mood_remote_datasource.dart';

class FirestoreMoodDataSource implements MoodRemoteDataSource {
  FirestoreMoodDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _moodsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('moods');
  }

  @override
  FutureEither<MoodModel> logMood({
    required String userId,
    required MoodModel mood,
  }) async {
    return runTask(() async {
      final docRef = mood.id.isEmpty
          ? _moodsCollection(userId).doc()
          : _moodsCollection(userId).doc(mood.id);
      final model = MoodModel(
        id: docRef.id,
        userId: userId,
        moodType: mood.moodType,
        intensity: mood.intensity,
        note: mood.note,
        createdAt: mood.createdAt,
      );
      await docRef.set(model.toFirestore());
      return model;
    }, requiresNetwork: true);
  }

  @override
  Stream<List<MoodModel>> watchMoodHistory({required String userId}) {
    return _moodsCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(MoodModel.fromFirestore)
              .toList(),
        );
  }

  @override
  FutureEither<List<MoodModel>> getMoodByDateRange({
    required String userId,
    required DateTime start,
    required DateTime end,
  }) async {
    return runTask(() async {
      final snapshot = await _moodsCollection(userId)
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map(MoodModel.fromFirestore).toList();
    }, requiresNetwork: true);
  }

  @override
  FutureEither<void> deleteMood({
    required String userId,
    required String moodId,
  }) {
    return runTask(
      () => _moodsCollection(userId).doc(moodId).delete(),
      requiresNetwork: true,
    );
  }
}
