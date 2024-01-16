class CourseUnit {
  final String name;
  //TODO: Change to the exact location type
  final String location;
  final String department;
  final int yearStudied;
  //TODO: Add number of classes and probably those that have remained

  const CourseUnit({
    required this.name,
    required this.location,
    required this.department,
    required this.yearStudied,
  });

  factory CourseUnit.fromJson(Map<String, dynamic> data) => CourseUnit(
        name: data['name'],
        location: data['location'],
        department: data['department'],
        yearStudied: data['year_studied'],
      );
}
