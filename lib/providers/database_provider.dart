import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/models/auth_user.dart';
import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/services/database_service.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:bio_attendance/utilities/helpers/password_hash.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  bool isLoading = false;

  Future<void> addStudent(Map<String, dynamic> addStudentData) async {
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLecturer(Map<String, dynamic> addLecturerData) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addLecturer(addLecturerData);
    } on EmailAlreadyInUseException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(Map<String, dynamic> userData) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> dbUser =
          await _databaseService.getUser(userData['email']);

      if (userData['email'] == dbUser['email'] &&
          comparePasswords(dbUser['password'], userData['password'])) {
        if (dbUser['role'] != (userData['role'] as Role).name) {
          throw InvalidRoleException();
        }
        await LocalStorage().saveUser(AuthUser.fromJSON(userData));
      } else {
        throw EmailPasswordMismatchException();
      }
    } on UserNotFoundException {
      rethrow;
    } on InvalidRoleException {
      rethrow;
    } on EmailPasswordMismatchException {
      rethrow;
    } catch (e) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Student> getStudent(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      Map<String, dynamic> studentData =
          await _databaseService.getStudent(email);
      return Student.fromJson(studentData);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Lecturer> getLecturer(String email) async {
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteLecturer(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteLecturer(email);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteStudent(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteStudent(email);
    } on UserNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<AttendanceLocation> getClassLocation(String locationName) async {
    isLoading = true;
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
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateClassLocation(
      String locationName, String polygonPoints) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.updateClassLocation(locationName, polygonPoints);
    } on LocationNotFoundException {
      rethrow;
    } catch (_) {
      throw GenericException();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
