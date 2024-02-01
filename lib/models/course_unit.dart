class CourseUnit {
  final String name;
  final int yearStudied;
  final String attendanceLocation;

  const CourseUnit({
    required this.name,
    required this.yearStudied,
    required this.attendanceLocation,
  });

  @override
  String toString() {
    return '$name studied in year $yearStudied at $attendanceLocation';
  }
}
