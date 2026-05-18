import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_entry.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/widgets/mood_face_avatar.dart';
import 'package:mood_canvas/src/theme/app_borders.dart';
import 'package:mood_canvas/src/theme/app_curves.dart';
import 'package:mood_canvas/src/theme/app_durations.dart';
import 'package:mood_canvas/src/theme/app_spacing.dart';

class MoodTimelineTile extends StatelessWidget {
  const MoodTimelineTile({
    required this.entry,
    super.key,
    this.animating = false,
    this.onTap,
  });

  final MoodEntry entry;
  final bool animating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final accent = entry.moodType.accentColor;
    final dateLabel = DateFormat.MMMd().format(entry.createdAt);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: animating ? 1.12 : 1,
        duration: AppDurations.quick,
        curve: AppCurves.spring,
        child: AnimatedContainer(
          duration: AppDurations.quick,
          curve: AppCurves.spring,
          width: 88,
          padding: const EdgeInsets.all(AppSpacing.ms),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: AppBorders.card,
            border: Border(
              left: BorderSide(
                color: accent,
                width: animating ? 6 : 4,
              ),
            ),
            boxShadow: animating
                ? [
                    BoxShadow(
                      color: accent.withValues(alpha: 0.45),
                      blurRadius: 14,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: animating ? FontWeight.w700 : FontWeight.w400,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              MoodFaceAvatar(
                moodType: entry.moodType,
                size: 48,
                selected: animating,
              ),
              const SizedBox(height: AppSpacing.xs),
              AnimatedContainer(
                duration: AppDurations.quick,
                curve: AppCurves.standard,
                width: animating ? 10 : 8,
                height: animating ? 10 : 8,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
