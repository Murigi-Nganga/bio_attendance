import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/models/attendance_track.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/providers/student_image_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/services/local_storage.dart';
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
  String? _studentCourseName;

  final LocalAuthentication auth = LocalAuthentication();
  bool? isAuthenticated;
  late int _yearOfStudy;
  late String _selectedCourseUnit;
  late String _studentRegNo;

  @override
  void initState() {
    _yearOfStudy = LocalStorage().getYearOfStudy()!;
    _studentRegNo = LocalStorage().getUser()!.identifier;
    _studentCourseName = LocalStorage().getCourseName();
    _selectedCourseUnit = CourseList.getUnitsForYearAndCourse(
            year: _yearOfStudy, courseName: _studentCourseName!)
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
        await showErrorDialog(
            context,
            '$_selectedCourseUnit taught in location $courseLocation'
            'does not have a defined geofence');
        databaseProvider.changeLoadingStatus(false);
        return;
      }

      Position currentLocation = await getCurrentLocation();

      //* Check if student is in the correct location
      isInAttLocation = isPointInPolygon(
        LatLng(currentLocation.latitude, currentLocation.longitude),
        attLocation.polygonPoints!,
      );

      if (!mounted) return;
    } on LocationNotFoundException {
      await showErrorDialog(context, LocationNotFoundException().toString());
      databaseProvider.changeLoadingStatus(false);
    } on GenericException {
      await showErrorDialog(context, GenericException().toString());
      databaseProvider.changeLoadingStatus(false);
    }

    if (!mounted) return;
    if (isInAttLocation == false) {
      databaseProvider.changeLoadingStatus(false);
      await showErrorDialog(
        context,
        'You are not in the correct location for the class',
      );
      return;
    }

    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

    if (canAuthenticateWithBiometrics == false) {
      if (!mounted) return;
      await showErrorDialog(context, 'Biometric authentication is unavailable');
      databaseProvider.changeLoadingStatus(false);
      return;
    }

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();

    //* Do fingerprint auth
    if (availableBiometrics.isNotEmpty) {
      try {
        final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to sign your attendance',
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        if (didAuthenticate) {
          setState(() {
            isAuthenticated = true;
          });

          await databaseProvider.addAttendance(
            Attendance(
              studentRegNo: _studentRegNo,
              yearOfStudy: attendanceDetails['year_of_study'],
              timeSignedIn: DateTime.now(),
              course: attendanceDetails['course'],
              courseUnit: attendanceDetails['course_unit'],
            ),
            attendanceDetails['student_image'],
          );

          if (!mounted) return;
          await showSuccessDialog(context, 'Sign out recorded successfully');
        } else {
          setState(() {
            isAuthenticated = false;
          });
          if (!mounted) return;
          await showErrorDialog(context, 'Authentication failed');
        }
      } on AttendanceAlreadyTakenException {
        if (!mounted) return;
        await showErrorDialog(
            context,
            AttendanceAlreadyTakenException(
                    courseUnit: attendanceDetails['course_unit'])
                .toString());
      } on FacesDontMatchException {
        if (!mounted) return;
        await showErrorDialog(context, FacesDontMatchException().toString());
      } on SuccessfulSIgnIn {
        if (!mounted) return;
        await showSuccessDialog(context, SuccessfulSIgnIn().toString());
      } on WaitForTimeElapseException {
        AttendanceTrack? attTrack = LocalStorage()
            .getAttendnaceTrack(attendanceDetails['course_unit'])!;

        int minuteDifference =
            DateTime.now().difference(attTrack.timeSignedIn).inMinutes;
        if (!mounted) return;
        await showErrorDialog(
            context,
            WaitForTimeElapseException(minToElapse: minuteDifference)
                .toString());
      } on GenericException {
        if (!mounted) return;
        await showErrorDialog(context, GenericException().toString());
      } catch (e) {
        if (!mounted) return;
        setState(() {
          isAuthenticated = null;
        });
        await showErrorDialog(context, e.toString());
      }
    } else {
      if (!mounted) return;
      await showErrorDialog(context, 'Could not do authentication');
    }

    databaseProvider.changeLoadingStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return _studentCourseName == null
        ? const LinearProgressIndicator()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _studentRegNo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: FontSize.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: SpaceSize.medium,
              ),
              Text(
                '${_studentCourseName!}, Year $_yearOfStudy',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: FontSize.small,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SpaceSize.large),
              Consumer<StudentImageProvider>(builder: (_, imgProvider, __) {
                if (imgProvider.isLoading) {
                  return const LinearProgressIndicator();
                } else {
                  return Column(
                    children: [
                      CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: imgProvider.studImage == null
                            ? null
                            : FileImage(imgProvider.studImage!),
                        radius: 100,
                        child: imgProvider.studImage == null
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(height: SpaceSize.large),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: OutlinedButton(
                          onPressed: () async {
                            try {
                              await imgProvider.takePicture(context);
                              if (!context.mounted) return;
                            } on ManyOrNoFacesException {
                              await showErrorDialog(
                                  context, ManyOrNoFacesException().toString());
                            } on IncorrectHeadPositionException {
                              await showErrorDialog(context,
                                  IncorrectHeadPositionException().toString());
                            } on DimEnvironmentException {
                              await showErrorDialog(context,
                                  DimEnvironmentException().toString());
                            } on NoPhotoCapturedException {
                              await showErrorDialog(context,
                                  NoPhotoCapturedException().toString());
                            } catch (error) {
                              await showErrorDialog(
                                  context, GenericException().toString());
                            }
                          },
                          child: const Text('Take picture'),
                        ),
                      ),
                    ],
                  );
                }
              }),
              const SizedBox(height: SpaceSize.large),
              const Text(
                'Select course unit',
              ),
              const SizedBox(height: SpaceSize.small),
              AppDropdownButton<String>(
                items: CourseList.getUnitsForYearAndCourse(
                        year: _yearOfStudy, courseName: _studentCourseName!)
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
              const SizedBox(height: SpaceSize.medium),
              Text(
                'Taught in location ${CourseList.getLocationsForCourseUnits([
                      _selectedCourseUnit
                    ])[0]}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: SpaceSize.large),
              Consumer<StudentImageProvider>(
                builder: (_, imgProvider, __) => Consumer<DatabaseProvider>(
                  builder: (_, databaseProvider, __) {
                    if (databaseProvider.isLoading) {
                      return const LinearProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () async {
                        if (imgProvider.studImage == null) {
                          await showErrorDialog(
                              context, 'Please add a student image');
                          return;
                        }

                        await _submitDetails(
                          {
                            'course': _studentCourseName,
                            'year_of_study': _yearOfStudy,
                            'course_unit': _selectedCourseUnit,
                            'student_image': imgProvider.studImage
                          },
                          databaseProvider,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Authenticate'),
                          SizedBox(width: SpaceSize.medium),
                          Icon(Icons.blur_circular),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
  }
}
