import 'package:bio_attendance/models/course_unit.dart';
import 'package:flutter/material.dart';

class UnitDetailsScreen extends StatelessWidget {
  const UnitDetailsScreen({super.key, required this.courseUnit,});

  final CourseUnit courseUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(courseUnit.name),
        Text(courseUnit.yearStudied.toString()),
        Text(courseUnit.attendanceLocation),
        //TODO: Add text with number of students for that class
      ],
    );
  }
}
