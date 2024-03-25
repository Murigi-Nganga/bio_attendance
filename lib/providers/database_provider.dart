import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/models/auth_user.dart';
import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/services/database_service.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:bio_attendance/utilities/helpers/password_hash.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  changeLoadingStatus(bool status) {
    _isLoading = status;
    notifyListeners();
  }

  Future<void> addStudent(Map<String, dynamic> addStudentData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addStudent(addStudentData);
    } on EmailAlreadyInUseException {
      rethrow;
    } on RegNoAlreadyInUseException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLecturer(Map<String, dynamic> addLecturerData) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addLecturer(addLecturerData);
    } on EmailAlreadyInUseException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(Map<String, dynamic> userData) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> dbUser =
          await _databaseService.getUser(userData['identifier']);

      if (userData['identifier'] == dbUser['identifier'] &&
          comparePasswords(dbUser['password'], userData['password'])) {
        if (dbUser['role'] != (userData['role'] as Role).name) {
          throw InvalidRoleException();
        }
        if (dbUser['role'] == 'student') {
          Student student = Student.fromJson(
              await _databaseService.getStudent(userData['identifier']));

          await LocalStorage().saveCourseName(student.course);
        }

        await LocalStorage().saveUser(AuthUser.fromJSON(userData));
      } else {
        throw IdentifierPasswordMismatchException();
      }
    } on UserNotFoundException {
      rethrow;
    } on InvalidRoleException {
      rethrow;
    } on IdentifierPasswordMismatchException {
      rethrow;
    } catch (e) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Student> getStudent(String regNo) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> studentData =
          await _databaseService.getStudent(regNo);
      return Student.fromJson(studentData);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Lecturer> getLecturer(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> lecturerData =
          await _databaseService.getLecturer(email);
      return Lecturer.fromJson(lecturerData);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLecturer(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteLecturer(email);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String regNo) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteStudent(regNo);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<AttendanceLocation> getClassLocation(String locationName) async {
    _isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> attLocationData =
          await _databaseService.getClassLocation(locationName);
      AttendanceLocation attLocation =
          AttendanceLocation.fromJson(attLocationData);
      return attLocation;
    } on LocationNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClassLocation(
      String locationName, String polygonPoints) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.updateClassLocation(locationName, polygonPoints);
    } on LocationNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAttendance(Attendance attendance) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addAttendance(attendance);
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int> getNumberOfStudents(String courseUnitName) async {
    _isLoading = true;
    notifyListeners();

    int numberOfStudents = 0;
    Map<String, dynamic> details;

    try {
      details = CourseList.getCourseNameAndYearOfStudy(courseUnitName);
      await _databaseService.getNumberOfStudents(
        details['course_name'],
        details['year_of_study'],
      );
    } on CourseNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      _isLoading = false;
    }

    return numberOfStudents;
  }
}
