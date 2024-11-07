// lib/utils/formatters.dart
class Formatters {
  static String formatDouble(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toString();
    }
  }
}
