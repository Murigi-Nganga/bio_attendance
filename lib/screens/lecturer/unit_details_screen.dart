import 'package:bio_attendance/models/course_unit.dart';
import 'package:bio_attendance/widgets/attendance_widget.dart';
import 'package:bio_attendance/widgets/course_detail_card.dart';
import 'package:flutter/material.dart';

class UnitDetailsScreen extends StatelessWidget {
  const UnitDetailsScreen({
    super.key,
    required this.courseUnit,
  });

  final CourseUnit courseUnit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Unit Details'),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CourseDetailCard(
            icon: Icons.calendar_today,
            text: 'Year of Study: 2',
          ),
          CourseDetailCard(
            icon: Icons.location_on,
            text: 'Study Location: Location B',
          ),
          SizedBox(height: 20),
          Expanded(
            child: AttendanceWidget(
              totalStudents: 56,
              signedToday: 34,
            ),
          ),
        ],
      ),
    );
  }
}
