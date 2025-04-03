import 'dart:math';

class NumberGenerator {
  static int getRandomNumber(int max) {
    return Random().nextInt(max);
  }
}
