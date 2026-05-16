import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/mood_entry.dart';
import '../../domain/entities/mood_type.dart';
import 'mood_face_avatar.dart';

class MoodTimelineTile extends StatelessWidget {
  const MoodTimelineTile({
    super.key,
    required this.entry,
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
        scale: animating ? 1.15 : 1,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Container(
          width: 88,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(color: accent, width: 4),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                dateLabel,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              MoodFaceAvatar(
                moodType: entry.moodType,
                size: 48,
              ),
              const SizedBox(height: 6),
              Container(
                width: 8,
                height: 8,
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
