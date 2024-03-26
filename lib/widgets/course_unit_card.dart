import 'package:bio_attendance/models/course_unit.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/router/app_router.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:provider/provider.dart';

class CourseUnitCard extends StatelessWidget {
  const CourseUnitCard({Key? key, required this.courseUnit}) : super(key: key);

  final CourseUnit courseUnit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 63, 65, 181),
            Color.fromARGB(255, 30, 29, 48),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      child: Consumer<DatabaseProvider>(builder: (_, databaseProvider, __) {
        if (databaseProvider.isLoading) {
          return const SizedBox(height: 60, child: LinearProgressIndicator());
        }
        return ListTile(
          onTap: () {
            try {
              Navigator.of(context).pushNamed(
                AppRouter.courseUnitDetailsRoute,
                arguments: {"courseUnit": courseUnit},
              );
            } on CourseUnitNotFoundException {
              showErrorDialog(
                  context, CourseUnitNotFoundException().toString());
            }
          },
          title: Text(
            courseUnit.name,
            style: const TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            'Taught in ${courseUnit.attendanceLocation}',
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 20,
          ),
        );
      }),
    );
  }
}
