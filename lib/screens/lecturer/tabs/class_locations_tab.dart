import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/widgets/class_location_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassLocationsTab extends StatefulWidget {
  const ClassLocationsTab({super.key});

  @override
  State<ClassLocationsTab> createState() => _ClassLocationsTabState();
}

class _ClassLocationsTabState extends State<ClassLocationsTab> {
  late DatabaseProvider databaseProvider;
  late String lecturerEmail;
  late Future<Lecturer?> lecturerFuture;

  @override
  void initState() {
    super.initState();
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    lecturerEmail = LocalStorage().getUser()!.identifier;
    lecturerFuture = _fetchLecturerUnits();
  }

  Future<Lecturer?> _fetchLecturerUnits() async {
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
          final courseUnitLocations =
              CourseList.getLocationsForCourseUnits(courseUnitNames).toSet();

          return ListView.builder(
            shrinkWrap: true,
            itemCount: courseUnitLocations.length,
            itemBuilder: (context, index) {
              return ClassLocationCard(
                attLocationName: courseUnitLocations.elementAt(index),
              );
            },
          );
        }
      },
    );
  }
}

