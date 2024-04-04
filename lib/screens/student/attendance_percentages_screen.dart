import 'package:bio_attendance/widgets/attendance_widget.dart';
import 'package:flutter/material.dart';

class AttendancePrecentagesScreen extends StatelessWidget {
  const AttendancePrecentagesScreen({Key? key, required this.courseStats})
      : super(key: key);

  final Map<String, int> courseStats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance percentages'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              ...courseStats.entries
                  .map((entry) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: AttendanceWidget(
                          totalStudents: 15,
                          signedToday: entry.value,
                          title: 'Attendance for ${entry.key}',
                          labels: const ['Signed', 'Remaining'],
                        ),
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}
