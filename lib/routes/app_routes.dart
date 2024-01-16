import 'package:bio_attendance/screens/admin/add_lecturer_screen.dart';
import 'package:bio_attendance/screens/admin/add_student_screen.dart';
import 'package:bio_attendance/screens/admin/admin_home_screen.dart';
import 'package:bio_attendance/screens/admin/lecturer_details_screen.dart';
import 'package:bio_attendance/screens/admin/student_details_screen.dart';
import 'package:bio_attendance/screens/auth/login_screen.dart';
import 'package:bio_attendance/screens/auth/user_selection_screen.dart';
import 'package:bio_attendance/screens/lecturer/lecturer_home_screen.dart';
import 'package:bio_attendance/screens/student/student_home_screen.dart';
import 'package:flutter/material.dart';

const userSelectionRoute = '/select-user';
const loginRoute = '/login/';
const adminHomeRoute = '/admin/home';
const lecturerHomeRoute = '/lecturer/home';
const studentHomeRoute = '/student/home';

const studentDetailsRoute = '/student/details';
const lecturerDetailsRoute = '/lecturer/details';
const addLecturerRoute = '/lecturers/add';
const addStudentRoute = '/students/add';

Map<String, Widget Function(BuildContext)> appRoutes = {
  userSelectionRoute: (context) => const UserSelectionScreen(),
  loginRoute: (context) => const LoginScreen(),
  adminHomeRoute: (context) => const AdminHomeScreen(),
  lecturerHomeRoute: (context) => const LecturerHomeScreen(),
  studentHomeRoute: (context) => const StudentHomeScreen(),

  lecturerDetailsRoute: (context) => const LecturerDetailsScreen(),
  studentDetailsRoute: (context) => const StudentDetailsScreen(),
  addLecturerRoute: (context) => const AddLecturerScreen(),
  addStudentRoute: (context) => const AddStudentScreen()
};
