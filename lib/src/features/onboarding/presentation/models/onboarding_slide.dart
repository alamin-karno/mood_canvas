import '../../../mood_tracker/domain/entities/mood_type.dart';

class OnboardingSlide {
  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.mood,
    required this.intensity,
  });

  final String title;
  final String subtitle;
  final MoodType mood;
  final int intensity;
}
