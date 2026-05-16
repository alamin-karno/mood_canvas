import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:mood_canvas/src/core/error/error.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_tracker_model.dart';
import 'mood_tracker_remote_datasource.dart';

class FirestoreMoodTrackerDataSource implements MoodTrackerRemoteDataSource {
  FirestoreMoodTrackerDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _moodsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('moods');
  }

  @override
  FutureEither<MoodTrackerModel> logMood({
    required String userId,
    required MoodTrackerModel mood,
  }) async {
    return runTask(() async {
      final docRef = mood.id.isEmpty
          ? _moodsCollection(userId).doc()
          : _moodsCollection(userId).doc(mood.id);
      final model = MoodTrackerModel(
        id: docRef.id,
        moodType: mood.moodType,
        createdAt: mood.createdAt,
      );
      await docRef.set(model.toFirestore());
      return model;
    }, requiresNetwork: true);
  }

  @override
  Stream<List<MoodTrackerModel>> watchMoodHistory({required String userId}) {
    return _moodsCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(MoodTrackerModel.fromFirestore)
              .toList(),
        );
  }

  @override
  FutureEither<List<MoodTrackerModel>> getMoodByDateRange({
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
      return snapshot.docs.map(MoodTrackerModel.fromFirestore).toList();
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
