import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/services/database_service.dart';
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

      // Add student to users collection
      await addUser({
        'email': addStudentData['email']!,
        'role': 'student',
        'password': addStudentData['password']!
      });

      addStudentData.remove('password');

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

      // Add student to users collection
      await addUser({
        'email': addLecturerData['email']!,
        'role': 'lecturer',
        'password': addLecturerData['password']
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

  Future<void> deleteUser(String email) async {
    isLoading = true;
    notifyListeners();

    try {
      await _databaseService.deleteUser(email);
    } catch (e) {
      print('Error fetching lecturer data: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
