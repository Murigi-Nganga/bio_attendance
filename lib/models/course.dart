import 'package:bio_attendance/models/course_unit.dart';

class Course {
  final int id;
  final String name;
  final List<CourseUnit> units;

  const Course({
    required this.id,
    required this.name,
    required this.units,
  });

  @override
  String toString() {
    return 'Course $name with id $id';
  }
}
