import 'package:mood_canvas/src/imports/core_imports.dart';
import 'package:mood_canvas/src/imports/packages_imports.dart';

import '../../../auth/presentation/bloc/session_bloc.dart';
import '../../domain/entities/mood_type.dart';
import '../bloc/mood_tracker_bloc.dart';
import '../bloc/mood_tracker_event.dart';
import '../bloc/mood_tracker_state.dart';
import '../widgets/mood_face_avatar.dart';

class MoodHistoryPage extends StatefulWidget {
  const MoodHistoryPage({super.key});

  @override
  State<MoodHistoryPage> createState() => _MoodHistoryPageState();
}

class _MoodHistoryPageState extends State<MoodHistoryPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<SessionBloc>().state.user?.id;
      if (userId != null) {
        context.read<MoodTrackerBloc>().add(
              MoodTrackerHistorySubscriptionRequested(userId: userId),
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SessionBloc>().state.user?.id;

    return Scaffold(
      appBar: AppTopBar(title: 'mood.history'.tr()),
      body: BlocBuilder<MoodTrackerBloc, MoodTrackerState>(
        builder: (context, state) {
          if (userId == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == MoodTrackerStatus.loading &&
              state.history.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.history.isEmpty) {
            return AppEmptyState(
              title: 'mood.no_entries'.tr(),
              subtitle: 'mood.no_entries_subtitle'.tr(),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(AppSpacing.lg.w),
            itemCount: state.history.length,
            separatorBuilder: (_, __) => SizedBox(height: AppSpacing.sm.h),
            itemBuilder: (context, index) {
              final entry = state.history[index];
              return AppCard(
                child: Row(
                  children: [
                    MoodFaceAvatar(
                      moodType: entry.moodType,
                      size: 48,
                      intensity: entry.intensity,
                    ),
                    SizedBox(width: AppSpacing.md.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.moodType.label,
                            style: context.theme.textTheme.titleSmall,
                          ),
                          Text(
                            '${entry.intensity}/5 · ${_formatDate(entry.createdAt)}',
                            style: context.theme.textTheme.bodySmall,
                          ),
                          if (entry.note != null && entry.note!.isNotEmpty)
                            Text(
                              entry.note!,
                              style: context.theme.textTheme.bodyMedium,
                            ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context.read<MoodTrackerBloc>().add(
                            MoodTrackerDeleteRequested(
                              userId: userId,
                              moodId: entry.id,
                            ),
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
