import 'dart:io';

import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/models/attendance_track.dart';
import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:bio_attendance/services/image_api_service.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/helpers/stats_utils.dart';
import 'package:bio_attendance/utilities/helpers/password_hash.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  late ImageAPIService _imageApiService;
  late CollectionReference _usersCollection;
  late CollectionReference _lecturersCollection;
  late CollectionReference _studentsCollection;
  late CollectionReference _attLocationsCollection;
  late CollectionReference _attendancesCollection;

  DatabaseService() {
    _imageApiService = ImageAPIService();
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
      Map<String, dynamic> imgUploadResult =
          await _imageApiService.uploadImage(studentData['student_image']);

      print("THE RESULT FOR UPLOADING THE IMAGE: ");
      print(imgUploadResult);

      if (imgUploadResult["success"] == false) {
        throw ImageUploadErrorException();
      }

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
        'year_of_study': studentData['year_of_study'],
        'face_encodings': imgUploadResult["encodings"].toString(),
      });
    } on EmailAlreadyInUseException {
      rethrow;
    } on RegNoAlreadyInUseException {
      rethrow;
    } on ImageUploadErrorException {
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

  Future<void> addAttendance(Attendance attendance, File studImage) async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfDay = DateTime(now.year, now.month, now.day);
      DateTime startOfNextDay = startOfDay.add(const Duration(days: 1));

      QuerySnapshot querySnapshot = await _attendancesCollection
          .where('student_reg_no', isEqualTo: attendance.studentRegNo)
          .where('course_unit', isEqualTo: attendance.courseUnit)
          .get();

      for (QueryDocumentSnapshot queryDocSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data =
            queryDocSnapshot.data() as Map<String, dynamic>;
        DateTime storedDateTime = DateTime.fromMillisecondsSinceEpoch(
          data['time_signed_in'].seconds * 1000 +
              (data['time_signed_in'].nanoseconds / 1000000).round(),
        ).toLocal();

        if (storedDateTime.isAfter(startOfDay) &&
            storedDateTime.isBefore(startOfNextDay)) {
          print(
              "A ATTENDANCEALREADYTAKENEXCEPTION HAS OCCURRED | FN: ADDATTENDANCE - DATABASESERVICE");
          throw AttendanceAlreadyTakenException(
              courseUnit: attendance.courseUnit);
        }
      }
      //* Get student's stored face encodings
      Map<String, dynamic> studentDetails =
          await getStudent(attendance.studentRegNo);

      print("STUDENT SUCCESSFULLY FOUND | FN: ADDATTENDANCE - DATABASESERVICE");

      String faceEncodings = studentDetails['face_encodings'];

      print(
          "SAVED FACE ENCODINGS FOR THE STUDENT | FN: ADDATTENDANCE - DATABASESERVICE");
      print("FACE ENCODINGS: $faceEncodings");

      Map<String, dynamic> comparisonResult =
          await _imageApiService.compareFaceEncodings(studImage, faceEncodings);

      print(
          "THE COMPARISON RESULT FOR THE FACES | FN: ADDATTENDANCE - DATABASESERVICE");
      print("COMPARISON RESULT: $comparisonResult");

      print(
          "IS COMPARISON TRUE: ${comparisonResult["result"]} == true | FN: ADDATTENDANCE - DATABASESERVICE");

      if (comparisonResult["success"] == true) {
        AttendanceTrack? attTrack =
            LocalStorage().getAttendnaceTrack(attendance.courseUnit);

        print(
            "COLLECTING ATTENDANCE TRACK | FN: ADDATTENDANCE - DATABASESERVICE");

        if (attTrack == null) {
          //* If attTrack is null, this is a sign in
          await LocalStorage().addAttendanceTrack(AttendanceTrack(
            courseUnit: attendance.courseUnit,
            signInSuccessful: true,
            timeSignedIn: DateTime.now(),
          ));

          print(
              "SUCCESSFUL SIGN IN PERSISTED IN LOCAL STORAGE | FN: ADDATTENDANCE - DATABASESERVICE");

          throw SuccessfulSIgnIn();
        } else {
          //* If attTrack is not null, this is a sign out

          //* Get minute difference from sign in to now
          int minuteDifference =
              DateTime.now().difference(attTrack.timeSignedIn).inMinutes;

          if (minuteDifference < 5) {
            print(
                "A WAITFORTIMETOELAPSEEXCEPTION HAS OCCURRED | FN: ADDATTENDANCE - DATABASESERVICE");
            throw WaitForTimeElapseException(minToElapse: minuteDifference);
          }

          print("ATTTRACK NOT NULL | FN: ADDATTENDANCE - DATABASESERVICE");
          print("ATTENDANCE TRACK COURSE UNIT: ${attendance.courseUnit}");
          print("ATTENDANCE COURSE UNIT: ${attendance.courseUnit}");

          //* If time is 5 minutes after, delete persisted attTrack
          await LocalStorage().deleteAttendnaceTrack(attendance.courseUnit);

          print(
              "ATTENDANCE TRACK DELETED FROM LOCAL STORAGE | FN: ADDATTENDANCE - DATABASESERVICE");
        }

        await _attendancesCollection.add(attendance.toJSON());
      } else {
        if (comparisonResult["message"] == "Student faces don't match") {
          throw FacesDontMatchException();
        } else {
          print("GENERIC EXCEPTION ON 308");
          throw GenericException();
        }
      }
    } on UserNotFoundException {
      //* Abstract the UserNotFoundException from the user
      throw GenericException();
    } on AttendanceAlreadyTakenException {
      rethrow;
    } on FacesDontMatchException {
      rethrow;
    } on SuccessfulSIgnIn {
      rethrow;
    } on WaitForTimeElapseException {
      rethrow;
    } catch (error) {
      print("ERROR HAS OCCURRED | FN: ADDATTENDANCE - DATABASESERVICE");
      print("ERROR: ${error.toString()}");
      rethrow;
    }
  }

  //* Total number of students taking a course
  Future<List<Student>> getStudentsForCourse(
      String courseName, int yearOfStudy) async {
    QuerySnapshot querySnapshot = await _studentsCollection
        .where('course', isEqualTo: courseName)
        .where('year_of_study', isEqualTo: yearOfStudy)
        .get();

    List<Student> students = querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocSnapshot) =>
            Student.fromJson(queryDocSnapshot.data() as Map<String, dynamic>))
        .toList();

    return students;
  }

  Future<List<Attendance>> getSignedStudentsForCourseUnit(
      String courseUnit) async {
    QuerySnapshot querySnapshot = await _attendancesCollection
        .where('course_unit', isEqualTo: courseUnit)
        .get();

    List<Attendance> attendances = querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocSnapshot) => Attendance.fromJSON(
            queryDocSnapshot.data() as Map<String, dynamic>))
        .toList()
        //* Attendance falls in the bracket of today
        .where((attendance) => isWithinToday(attendance.timeSignedIn))
        .toList();

    return attendances;
  }

  Future<List<Attendance>> getStudentAttendances(String studentRegNo) async {
    QuerySnapshot querySnapshot = await _attendancesCollection
        .where('student_reg_no', isEqualTo: studentRegNo)
        .get();

    List<Attendance> attendances = querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocSnapshot) => Attendance.fromJSON(
            queryDocSnapshot.data() as Map<String, dynamic>))
        .toList();

    return attendances;
  }

  Future<List<Attendance>> getAllAttendances() async {
    QuerySnapshot querySnapshot = await _attendancesCollection
        .get();

    List<Attendance> attendances = querySnapshot.docs
        .map((QueryDocumentSnapshot queryDocSnapshot) => Attendance.fromJSON(
            queryDocSnapshot.data() as Map<String, dynamic>))
        .toList();

    return attendances;
  }
}
