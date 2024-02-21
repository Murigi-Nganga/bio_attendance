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
  Lecturer? lecturer;

  @override
  void initState() {
    databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    _fetchLecturerUnits();
    super.initState();
  }

  _fetchLecturerUnits() async {
    lecturerEmail = LocalStorage().getUser()!.identifier;
    lecturer = await databaseProvider.getLecturer(lecturerEmail);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if lecturer is null before accessing courseUnits
    final courseUnitNames = lecturer?.courseUnits ?? [];
    final courseUnitLocations =
        CourseList.getLocationsForCourseUnits(courseUnitNames);

    if (lecturer == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: courseUnitNames.length,
        itemBuilder: (context, index) {
          return ClassLocationCard(
            courseUnitName: courseUnitNames[index],
            attLocationName: courseUnitLocations[index],
          );
        });
  }
}
