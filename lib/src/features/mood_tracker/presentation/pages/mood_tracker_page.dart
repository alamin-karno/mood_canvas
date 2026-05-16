import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/presentation/bloc/session_bloc.dart';
import '../../domain/entities/mood_type.dart';
import '../bloc/mood_tracker_bloc.dart';
import '../bloc/mood_tracker_event.dart';
import '../bloc/mood_tracker_state.dart';
import '../widgets/mood_face_avatar.dart';
import '../widgets/mood_timeline_tile.dart';

class MoodTrackerPage extends StatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  State<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends State<MoodTrackerPage> {
  String? _animatingEntryId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _subscribeHistory());
  }

  void _subscribeHistory() {
    final userId = context.read<SessionBloc>().state.user?.id;
    if (userId != null) {
      context.read<MoodTrackerBloc>().add(
            MoodTrackerHistorySubscriptionRequested(userId: userId),
          );
    }
  }

  Future<void> _onTimelineTap(String entryId) async {
    setState(() => _animatingEntryId = entryId);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      setState(() => _animatingEntryId = null);
    }
  }

  void _onMoodTap(MoodType mood, String userId) {
    context.read<MoodTrackerBloc>().add(
          MoodTrackerLogRequested(userId: userId, moodType: mood),
        );
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SessionBloc>().state.user?.id;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocBuilder<MoodTrackerBloc, MoodTrackerState>(
      builder: (context, state) {
        final recent = state.history.take(7).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mood Canvas'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final faceSize =
                    constraints.maxWidth < 600 ? 72.0 : 88.0;

                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'How are you feeling?',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: MoodType.values.map((type) {
                          final logging = state.isLoading;
                          return GestureDetector(
                            onTap: logging
                                ? null
                                : () => _onMoodTap(type, userId),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MoodFaceAvatar(
                                  moodType: type,
                                  size: faceSize,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  type.label,
                                  style:
                                      Theme.of(context).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        'Recent moods',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: recent.isEmpty
                            ? Center(
                                child: Text(
                                  'Log your first mood above',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: recent.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final entry = recent[index];
                                  return MoodTimelineTile(
                                    entry: entry,
                                    animating:
                                        _animatingEntryId == entry.id,
                                    onTap: () => _onTimelineTap(entry.id),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
