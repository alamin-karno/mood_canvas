enum MoodType {
  happy,
  calm,
  sad,
  anxious,
  angry,
  excited,
}

extension MoodTypeX on MoodType {
  String get label {
    switch (this) {
      case MoodType.happy:
        return 'Happy';
      case MoodType.calm:
        return 'Calm';
      case MoodType.sad:
        return 'Sad';
      case MoodType.anxious:
        return 'Anxious';
      case MoodType.angry:
        return 'Angry';
      case MoodType.excited:
        return 'Excited';
    }
  }
}
