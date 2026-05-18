import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../theme/app_curves.dart';
import '../../../../theme/app_durations.dart';
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

  Future<void> _onTimelineTap(String entryId) async {
    setState(() => _animatingEntryId = entryId);
    await Future<void>.delayed(AppDurations.medium);
    if (mounted) {
      setState(() => _animatingEntryId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MoodTrackerBloc, MoodTrackerState>(
      listenWhen: (previous, current) =>
          previous.failure != current.failure ||
          previous.lastLogged != current.lastLogged,
      listener: (context, state) {
        if (state.failure != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.failure!.message),
                behavior: SnackBarBehavior.floating,
              ),
            );
        } else if (state.lastLogged != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  'Logged ${state.lastLogged!.moodType.label.toLowerCase()}!',
                ),
                behavior: SnackBarBehavior.floating,
                duration: AppDurations.normal,
              ),
            );
        }
      },
      child: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(
        builder: (context, state) {
          final recent = state.history.take(7).toList();
          final highlightPicker = state.isLoading ||
              state.status == MoodTrackerStatus.success;

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
                            final selected = highlightPicker &&
                                state.selectedMood == type;
                            return GestureDetector(
                              onTap: logging
                                  ? null
                                  : () => context
                                      .read<MoodTrackerBloc>()
                                      .add(MoodTrackerLogRequested(type)),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MoodFaceAvatar(
                                    moodType: type,
                                    size: faceSize,
                                    selected: selected,
                                  ),
                                  const SizedBox(height: 4),
                                  AnimatedDefaultTextStyle(
                                    duration: AppDurations.quick,
                                    curve: AppCurves.standard,
                                    style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                        .copyWith(
                                          fontWeight: selected
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                          color: selected
                                              ? type.accentColor
                                              : null,
                                        ),
                                    child: Text(type.label),
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
      ),
    );
  }
}
