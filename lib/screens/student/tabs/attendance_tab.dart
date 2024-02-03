import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/helpers/attendance_utils.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/app_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  //TODO: Fetch from preferences or database
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

  Future<void> _submitDetails(
    Map<String, dynamic> attendanceDetails,
    DatabaseProvider databaseProvider,
  ) async {
    bool isInAttLocation = false;

    try {
      String courseLocation =
          CourseList.getLocationsForCourseUnits([_selectedCourseUnit]).first;

      AttendanceLocation attLocation =
          await databaseProvider.getClassLocation(courseLocation);

      databaseProvider.changeLoadingStatus(true);

      if (attLocation.polygonPoints == null) {
        if (!mounted) return;
        showErrorDialog(
            context, '$_selectedCourseUnit does not have a defined location');
        databaseProvider.changeLoadingStatus(false);
        return;
      }

      Position currentLocation = await getCurrentLocation();

      isInAttLocation = isPointInPolygon(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        attLocation.polygonPoints!,
      );

      if (!mounted) return;
    } on LocationNotFoundException {
      await showErrorDialog(context, LocationNotFoundException().toString());
      databaseProvider.changeLoadingStatus(false);
    } on GenericException {
      showErrorDialog(context, GenericException().toString());
      databaseProvider.changeLoadingStatus(false);
    }

    if (!mounted) return;
    if (isInAttLocation == false) {
      databaseProvider.changeLoadingStatus(false);
      showErrorDialog(
        context,
        'You are not in the correct location for the class',
      );
      return;
    } else {
      await showSuccessDialog(
        context,
        'You are in the correct location \n\n'
        'You will be prompted to authenticate using your fingerprint',
      );
    }

    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

    if (canAuthenticateWithBiometrics == false) {
      if (!mounted) return;
      showErrorDialog(context, 'Biometric authentication is unavailable');
      databaseProvider.changeLoadingStatus(false);
      return;
    }

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
          showSuccessDialog(
              context,
              '** Experimental ** \n\n'
              'Authentication successful \n\n'
              'Attendance details to be recorded \n\n'
              '$attendanceDetails');
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

    databaseProvider.changeLoadingStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _studentCourseName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: FontSize.medium,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: SpaceSize.medium,
        ),
        const Text('Select year of study'),
        const SizedBox(height: SpaceSize.small),
        AppDropdownButton<int>(
          items: [1, 2, 3, 4]
              .map(
                (number) => DropdownMenuItem(
                  value: number,
                  child: Text(number.toString()),
                ),
              )
              .toList(),
          value: _yearOfStudy,
          onChanged: (newValue) {
            setState(() {
              _yearOfStudy = newValue!;
              _selectedCourseUnit = CourseList.getUnitsForYearAndCourse(
                      year: _yearOfStudy, courseName: _studentCourseName)
                  .first;
            });
          },
        ),
        const SizedBox(height: SpaceSize.medium),
        const Text(
          'Select course unit',
        ),
        const SizedBox(height: SpaceSize.small),
        AppDropdownButton<String>(
          items: CourseList.getUnitsForYearAndCourse(
                  year: _yearOfStudy, courseName: _studentCourseName)
              .map(
                (unitName) => DropdownMenuItem(
                  value: unitName,
                  child: Text(unitName),
                ),
              )
              .toList(),
          value: _selectedCourseUnit,
          onChanged: (newValue) {
            setState(() {
              _selectedCourseUnit = newValue!;
            });
          },
        ),
        const SizedBox(height: SpaceSize.large),
        Consumer<DatabaseProvider>(
          builder: (_, databaseProvider, __) {
            if (databaseProvider.isLoading) {
              return const LinearProgressIndicator();
            }
            return ElevatedButton(
              onPressed: () => _submitDetails({
                'course': _studentCourseName,
                'year_of_study': _yearOfStudy,
                'course_unit': _selectedCourseUnit,
                'time_signed': DateTime.now(),
              }, databaseProvider),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Authenticate'),
                  SizedBox(width: SpaceSize.medium),
                  Icon(Icons.fingerprint_rounded)
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
