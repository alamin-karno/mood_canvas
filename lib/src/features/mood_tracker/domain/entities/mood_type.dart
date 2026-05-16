import 'package:flutter/material.dart';

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

  Color get accentColor {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFB300);
      case MoodType.neutral:
        return const Color(0xFF29B6F6);
      case MoodType.sad:
        return const Color(0xFF78909C);
    }
  }

  Color get faceColor {
    switch (this) {
      case MoodType.happy:
        return const Color(0xFFFFD54F);
      case MoodType.neutral:
        return const Color(0xFF81D4FA);
      case MoodType.sad:
        return const Color(0xFF90A4AE);
    }
  }
}
