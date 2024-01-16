extension StringExtensions on String {
  String capitalizeFirstChar() => this[0].toUpperCase() + substring(1);
}
