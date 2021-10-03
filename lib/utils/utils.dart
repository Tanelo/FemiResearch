import 'dart:math';

class Utils {
  static double rand(double min, double max) {
    final _random = Random();
    return min + (max - min) * _random.nextDouble();
  }

  static int randint(int min, int max) {
    final _random = Random();
    return min + _random.nextInt(max - min);
  }
}

extension StringExtension on String {
  num toReal() {
    String result = replaceAll(',', '.');
    result = result.replaceAll(' ', '');
    return num.parse(result);
  }

  String firstUpperCase() {
    if (length > 1) {
      return substring(0, 1).toUpperCase() + substring(1);
    } else if (length == 1) {
      return toUpperCase();
    } else {
      return this;
    }
  }

  String toFrench() {
    if (length < 1) {
      return this;
    } else if (length == 1) {
      return this;
    } else {
      String s = toLowerCase();

      switch (s) {
        case "angry":
          return "En colère";
        case "happy":
          return "Joyeux";
        case "sad":
          return "Triste";
        case "disgust":
          return "Dégouté";
        case "surprised":
          return "Surpris";
        case "fear":
          return "Effrayé";
        case "neutral":
          return "Neutre";
        case "pensive":
          return "Pensif";
        case "funny":
          return "Envie de rire";
        case "illuminated":
          return "Illuminé";
        case "love":
          return "Amoureux";
        default:
          return this;
      }
    }
  }
}
