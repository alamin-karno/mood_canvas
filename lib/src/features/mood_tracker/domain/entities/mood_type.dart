enum MoodType {
  happy,
  neutral,
  sad,
}

extension MoodTypeX on MoodType {
  String get label {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.neutral:
        return 'Neutral';
      case MoodType.sad:
        return 'Sad';
    }
  }
}
