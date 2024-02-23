import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:bio_attendance/utilities/helpers/password_hash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  late CollectionReference _usersCollection;
  late CollectionReference _lecturersCollection;
  late CollectionReference _studentsCollection;
  late CollectionReference _attLocationsCollection;
  late CollectionReference _attendancesCollection;

  DatabaseService() {
    _usersCollection = _db.collection('users');
    _lecturersCollection = _db.collection('lecturers');
    _studentsCollection = _db.collection('students');
    _attLocationsCollection = _db.collection('attendance_locations');
    _attendancesCollection = _db.collection('attendances');
  }

  // Get AuthUser
  Future<Map<String, dynamic>> getUser(String identifier) async {
    QuerySnapshot querySnapshot =
        await _usersCollection.where('identifier', isEqualTo: identifier).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw const UserNotFoundException();
    }
  }

  // Get Student's details
  Future<Map<String, dynamic>> getStudent(String regNo) async {
    QuerySnapshot querySnapshot =
        await _studentsCollection.where('reg_no', isEqualTo: regNo).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw const UserNotFoundException();
    }
  }

  // Get lecturer's details
  Future<Map<String, dynamic>> getLecturer(String email) async {
    QuerySnapshot querySnapshot =
        await _lecturersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw const UserNotFoundException();
    }
  }

  Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      Map<String, dynamic> dbStudent = await getStudent(studentData['email']);
      if (dbStudent.isNotEmpty) {
        throw EmailAlreadyInUseException();
      }
    } on UserNotFoundException {
      QuerySnapshot querySnapshot = await _studentsCollection
          .where('reg_no', isEqualTo: studentData['reg_no'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        throw RegNoAlreadyInUseException();
      }

      await _usersCollection.add({
        'identifier': studentData['reg_no'],
        'role': Role.student.name,
        'password': hashPassword(studentData['password']),
      });

      await _studentsCollection.add({
        'name': studentData['name'],
        'email': studentData['email'],
        'reg_no': studentData['reg_no'],
        'course': studentData['course'],
      });
    } on EmailAlreadyInUseException {
      rethrow;
    } on RegNoAlreadyInUseException {
      rethrow;
    }
  }

  Future<void> addLecturer(Map<String, dynamic> lecturerData) async {
    try {
      Map<String, dynamic> dbLecturer =
          await getLecturer(lecturerData['email']);
      if (dbLecturer.isNotEmpty) {
        throw EmailAlreadyInUseException();
      }
    } on UserNotFoundException {
      await _usersCollection.add({
        'identifier': lecturerData['email'],
        'role': Role.lecturer.name,
        'password': hashPassword(lecturerData['password']),
      });

      await _lecturersCollection.add({
        'name': lecturerData['name'],
        'email': lecturerData['email'],
        'course_units': lecturerData['course_units']
      });
    } on EmailAlreadyInUseException {
      rethrow;
    }
  }

  Future<void> _deleteUser(String identifier) async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection
          .where('identifier', isEqualTo: identifier)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
      } else {
        throw const UserNotFoundException();
      }
    } on UserNotFoundException {
      rethrow;
    }
  }

  Future<void> deleteStudent(String regNo) async {
    try {
      QuerySnapshot querySnapshot =
          await _studentsCollection.where('reg_no', isEqualTo: regNo).get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        await _deleteUser(regNo);
      } else {
        throw const UserNotFoundException();
      }
    } on UserNotFoundException {
      rethrow;
    }
  }

  Future<void> deleteLecturer(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _lecturersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        await _deleteUser(email);
      } else {
        throw const UserNotFoundException();
      }
    } on UserNotFoundException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getClassLocation(String locationName) async {
    try {
      QuerySnapshot querySnapshot = await _attLocationsCollection
          .where('name', isEqualTo: locationName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
        return documentSnapshot.data() as Map<String, dynamic>;
      } else {
        throw LocationNotFoundException();
      }
    } on LocationNotFoundException {
      rethrow;
    }
  }

  Future<void> updateClassLocation(
      String locationName, String polygonPoints) async {
    try {
      QuerySnapshot querySnapshot = await _attLocationsCollection
          .where('name', isEqualTo: locationName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference docReference = querySnapshot.docs.first.reference;
        await docReference.update({'polygon_points': polygonPoints});
      } else {
        throw LocationNotFoundException();
      }
    } on LocationNotFoundException {
      rethrow;
    }
  }

  Future<void> addAttendance(Attendance attendance) async =>
      await _attendancesCollection.add(attendance.toJSON());
}
