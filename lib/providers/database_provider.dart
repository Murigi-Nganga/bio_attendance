import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/services/auth/auth_service.dart';
import 'package:bio_attendance/services/crud/database_service.dart';
import 'package:flutter/material.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  bool isLoading = false;
  Map<String, dynamic> studentData = {};
  Map<String, dynamic> lecturerData = {};

  Future<Student?> getStudent(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      studentData = await _databaseService.getStudent(email);
      return Student.fromJson(studentData);
    } catch (e) {
      print('Error fetching student data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<Lecturer?> getLecturer(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      lecturerData = await _databaseService.getLecturer(email);
      return Lecturer.fromJson(lecturerData);
    } catch (e) {
      print('Error fetching lecturer data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return null;
  }

  Future<void> addStudent(Map<String, String> addStudentData) async {
    isLoading = true;
    notifyListeners();

    try {
      // Add user to auth
      await AuthService.firebase().createUser(
        email: addStudentData['email']!,
        password: addStudentData['password']!,
      );

      // Add student to users collection
      await addUser({
        'email': addStudentData['email']!,
        'role': 'student',
      });

      addStudentData.remove('password');

      print('LET US SEE IF IT HAS BEEN MODIFIED');
      print(addStudentData);

      await _databaseService.addStudent(addStudentData);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addLecturer(Map<String, dynamic> addLecturerData) async {
    isLoading = true;
    notifyListeners();

    try {
      // Add user to auth
      await AuthService.firebase().createUser(
        email: addLecturerData['email']!,
        password: addLecturerData['password']!,
      );

      // Add student to users collection
      await addUser({
        'email': addLecturerData['email']!,
        'role': 'lecturer',
      });

      addLecturerData.remove('password');

      await _databaseService.addLecturer(addLecturerData);
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(Map<String, String> userData) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.addUser(userData);
    } catch (e) {
      print('Error fetching lecturer data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
