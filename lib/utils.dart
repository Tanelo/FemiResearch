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
