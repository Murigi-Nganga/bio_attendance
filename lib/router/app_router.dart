import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/screens/admin/add_lecturer_screen.dart';
import 'package:bio_attendance/screens/admin/add_student_screen.dart';
import 'package:bio_attendance/screens/admin/admin_home_screen.dart';
import 'package:bio_attendance/screens/admin/lecturer_details_screen.dart';
import 'package:bio_attendance/screens/admin/student_details_screen.dart';
import 'package:bio_attendance/screens/auth/login_screen.dart';
import 'package:bio_attendance/screens/auth/user_selection_screen.dart';
import 'package:bio_attendance/screens/lecturer/lecturer_home_screen.dart';
import 'package:bio_attendance/screens/lecturer/location_geofence_screen.dart';
import 'package:bio_attendance/screens/student/student_home_screen.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const userSelectionRoute = '/select-user';
  static const loginRoute = '/login/';
  static const adminHomeRoute = '/admin/home';
  static const lecturerHomeRoute = '/lecturer/home';
  static const studentHomeRoute = '/student/home';
  static const studentDetailsRoute = '/student/details';
  static const lecturerDetailsRoute = '/lecturer/details';
  static const addLecturerRoute = '/lecturers/add';
  static const addStudentRoute = '/students/add';
  static const locationGeofenceRoute = '/courseunit/location';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case userSelectionRoute:
        return MaterialPageRoute(
          builder: (context) => const UserSelectionScreen(),
        );
      case loginRoute:
        Role role = (args as Map<String, dynamic>)['role'];
        return MaterialPageRoute(
          builder: (context) => LoginScreen(
            role: role
          ),
        );
      case adminHomeRoute:
        return MaterialPageRoute(
          builder: (context) => const AdminHomeScreen(),
        );
      case lecturerHomeRoute:
        return MaterialPageRoute(
          builder: (context) => const LecturerHomeScreen(),
        );
      case studentHomeRoute:
        return MaterialPageRoute(
          builder: (context) => const StudentHomeScreen(),
        );
      case studentDetailsRoute:
        Student student = (args as Map<String, dynamic>)['student'];
        return MaterialPageRoute(
          builder: (context) => StudentDetailsScreen(
            student: student
          ),
        );
      case lecturerDetailsRoute:
      Lecturer lecturer = (args as Map<String, dynamic>)['lecturer'];
        return MaterialPageRoute(
          builder: (context) => LecturerDetailsScreen(
            lecturer: lecturer
          ),
        );
      case addLecturerRoute:
        return MaterialPageRoute(
          builder: (context) => const AddLecturerScreen(),
        );
      case addStudentRoute:
        return MaterialPageRoute(
          builder: (context) => const AddStudentScreen(),
        );
      case locationGeofenceRoute:
        AttendanceLocation classLocation =
            (args as Map<String, dynamic>)['attLocation'];
        return MaterialPageRoute(
          builder: (context) => LocationGeofenceScreen(
            classLocation: classLocation,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Bio Attendance App')),
            body: const Center(
              child: Text('Unknown Page'),
            ),
          ),
        );
    }
  }
}
