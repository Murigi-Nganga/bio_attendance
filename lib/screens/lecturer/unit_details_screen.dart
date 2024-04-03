import 'package:bio_attendance/models/course_unit.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/widgets/attendance_widget.dart';
import 'package:bio_attendance/widgets/course_detail_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnitDetailsScreen extends StatefulWidget {
  const UnitDetailsScreen({
    super.key,
    required this.courseUnit,
  });

  final CourseUnit courseUnit;

  @override
  State<UnitDetailsScreen> createState() => _UnitDetailsScreenState();
}

class _UnitDetailsScreenState extends State<UnitDetailsScreen> {
  late DatabaseProvider databaseProvider;
  late Future<Map<String, dynamic>> statisticsFuture;

  @override
  void initState() {
    super.initState();
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    statisticsFuture = _fetchStatistics();
  }

  Future<Map<String, dynamic>> _fetchStatistics() async {
    return await databaseProvider.getCourseUnitStatistics(widget.courseUnit.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Unit Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const CourseDetailCard(
            icon: Icons.calendar_today,
            text: 'Year of Study: 2',
          ),
          const CourseDetailCard(
            icon: Icons.location_on,
            text: 'Study Location: Location B',
          ),
          const SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(
            future: statisticsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: LinearProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                Map<String, dynamic> results = snapshot.data!;
                return Expanded(
                  child: AttendanceWidget(
                    totalStudents: results['students'].length,
                    signedToday: results['attendances'].length,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
