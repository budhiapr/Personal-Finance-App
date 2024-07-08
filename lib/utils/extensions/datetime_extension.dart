/// Extension on DateTime class
extension DateTimeX on DateTime {
  /// Returns the date without time
  DateTime get withoutTime => DateTime(year, month, day);
}
