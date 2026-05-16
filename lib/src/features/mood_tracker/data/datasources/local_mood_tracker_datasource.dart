import 'dart:async';
import 'dart:convert';

import 'package:mood_canvas/src/core/error/error.dart';
import 'package:mood_canvas/src/services/storage_service.dart';
import 'package:mood_canvas/src/utils/typedefs.dart';

import '../models/mood_tracker_model.dart';
import 'mood_tracker_datasource.dart';

class LocalMoodTrackerDataSource implements MoodTrackerDataSource {
  LocalMoodTrackerDataSource({StorageService? storage})
      : _storage = storage ?? StorageService.instance;

  static const _storageKey = 'mood_entries';
  static const _maxEntries = 7;

  final StorageService _storage;
  final _historyController =
      StreamController<List<MoodTrackerModel>>.broadcast();

  Future<List<MoodTrackerModel>> _loadEntries() async {
    final raw = _storage.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((e) => MoodTrackerModel.fromJson(e as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _saveEntries(List<MoodTrackerModel> entries) async {
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await _storage.setString(_storageKey, encoded);
  }

  Future<void> _emitCurrent() async {
    if (_historyController.isClosed) return;
    _historyController.add(await _loadEntries());
  }

  @override
  FutureEither<MoodTrackerModel> logMood({required MoodTrackerModel mood}) {
    return runTask(() async {
      final entries = await _loadEntries();
      final id = mood.id.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : mood.id;
      final newEntry = MoodTrackerModel(
        id: id,
        moodType: mood.moodType,
        createdAt: mood.createdAt,
      );
      final updated = [newEntry, ...entries]
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      if (updated.length > _maxEntries) {
        updated.removeRange(_maxEntries, updated.length);
      }
      await _saveEntries(updated);
      await _emitCurrent();
      return newEntry;
    });
  }

  @override
  Stream<List<MoodTrackerModel>> watchMoodHistory() {
    late final StreamController<List<MoodTrackerModel>> controller;

    controller = StreamController<List<MoodTrackerModel>>(
      onListen: () async {
        controller.add(await _loadEntries());
        final sub = _historyController.stream.listen(
          controller.add,
          onError: controller.addError,
        );
        controller.onCancel = () => sub.cancel();
      },
    );

    return controller.stream;
  }
}
