import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  // TODO: Fetch this from local storage
  final _studentCourseName = CourseList.courseList[0].name;

  final LocalAuthentication auth = LocalAuthentication();
  bool? isAuthenticated;
  int _yearOfStudy = 1;
  late String _selectedCourseUnit;

  @override
  void initState() {
    _selectedCourseUnit = CourseList.getUnitsForYearAndCourse(
            year: _yearOfStudy, courseName: _studentCourseName)
        .first;
    super.initState();
  }

  Future<void> _authenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

    if (canAuthenticateWithBiometrics) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        try {
          final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to sign your attendance',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
          );
          if (!mounted) return;
          if (didAuthenticate) {
            setState(() {
              isAuthenticated = true;
            });
            showSuccessDialog(context, 'Authentication successful');
          } else {
            setState(() {
              isAuthenticated = false;
            });
            showErrorDialog(context, 'Authentication failed');
          }
        } catch (e) {
          if (!mounted) return;
          setState(() {
              isAuthenticated = null;
            });
          showErrorDialog(context, 'Could not do authentication');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButton<int>(
          value: _yearOfStudy,
          onChanged: (newValue) {
            setState(() {
              _yearOfStudy = newValue!;
              _selectedCourseUnit = CourseList.getUnitsForYearAndCourse(
                      year: _yearOfStudy, courseName: _studentCourseName)
                  .first;
            });
          },
          items: [1, 2, 3, 4]
              .map(
                (number) => DropdownMenuItem(
                  value: number,
                  child: Text(number.toString()),
                ),
              )
              .toList(),
        ),
        DropdownButton<String>(
          value: _selectedCourseUnit,
          onChanged: (newValue) {
            setState(() {
              _selectedCourseUnit = newValue!;
            });
          },
          items: CourseList.getUnitsForYearAndCourse(
                  year: _yearOfStudy, courseName: _studentCourseName)
              .map(
                (unitName) => DropdownMenuItem(
                  value: unitName,
                  child: Text(unitName),
                ),
              )
              .toList(),
        ),
        ElevatedButton(
          onPressed: _authenticate,
          child: const Text('Authenticate'),
        ),
        const SizedBox(height: 20),
        Text(
          isAuthenticated == null
              ? 'Authentication not done'
              : (isAuthenticated! == true
                  ? 'Authentication successful'
                  : 'Authentication failed'),
        ),
      ],
    );
  }
}
