import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/widgets/course_unit_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CourseUnitsTab extends StatefulWidget {
  const CourseUnitsTab({super.key});

  @override
  State<CourseUnitsTab> createState() => _CourseUnitsTabState();
}

class _CourseUnitsTabState extends State<CourseUnitsTab> {
  late DatabaseProvider databaseProvider;
  late String lecturerEmail;
  late Future<Lecturer?> lecturerFuture;

  @override
  void initState() {
    super.initState();
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    lecturerEmail = LocalStorage().getUser()!.identifier;
    lecturerFuture = _fetchLecturer();
  }

  Future<Lecturer?> _fetchLecturer() async {
    return databaseProvider.getLecturer(lecturerEmail);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Lecturer?>(
      future: lecturerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final lecturer = snapshot.data;
          final courseUnitNames = lecturer?.courseUnits ?? [];
          final courseUnits =
              CourseList.getCourseUnitsFromNames(courseUnitNames);

          return ListView.builder(
            shrinkWrap: true,
            itemCount: courseUnits.length,
            itemBuilder: (context, index) {
              return CourseUnitCard(
                courseUnit: courseUnits[index],
              );
            },
          );
        }
      },
    );
  }
}

