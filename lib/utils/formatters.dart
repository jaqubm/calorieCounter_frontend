class Formatters {
  static String formatDouble(double value) {
  int roundedValue = value.round();
  return roundedValue.toString();
  }
}
