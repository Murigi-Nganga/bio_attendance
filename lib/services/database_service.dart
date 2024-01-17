import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final _db = FirebaseFirestore.instance;

  late CollectionReference _usersCollection;
  late CollectionReference _lecturersCollection;
  late CollectionReference _studentsCollection;
  // late CollectionReference _unitsCollection;

  DatabaseService() {
    _usersCollection = _db.collection('users');
    _lecturersCollection = _db.collection('lecturers');
    _studentsCollection = _db.collection('students');
    // _unitsCollection = _db.collection('course_units');
  }

  Future<bool> isRoleCorrect(Role role, String email) async {
    QuerySnapshot querySnapshot =
        await _usersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return role.name ==
          (documentSnapshot.data() as Map<String, dynamic>)['role'];
    } else {
      throw Exception('Lecturer with that email not found !!');
    }
  }

  Future<Map<String, dynamic>> getStudent(String email) async {
    QuerySnapshot querySnapshot =
        await _studentsCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Student with that email not found !!');
    }
  }

  Future<Map<String, dynamic>> getLecturer(String email) async {
    QuerySnapshot querySnapshot =
        await _lecturersCollection.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot documentSnapshot = querySnapshot.docs.first;
      return documentSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Lecturer with that email not found !!');
    }
  }

  Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      DocumentReference documentReference =
          await _studentsCollection.add(studentData);
      String documentId = documentReference.id;

      print('Student added successfully with ID: $documentId');
    } catch (error) {
      print('Error adding student: $error');
    }
  }

  Future<void> addLecturer(Map<String, dynamic> lecturerData) async {
    try {
      DocumentReference documentReference =
          await _lecturersCollection.add(lecturerData);
      String documentId = documentReference.id;

      print('Lecturer added successfully with ID: $documentId');
    } catch (error) {
      print('Error adding lecturer: $error');
    }
  }

  Future<void> addUser(Map<String, dynamic> userData) async {
    try {
      DocumentReference documentReference =
          await _usersCollection.add(userData);
      String documentId = documentReference.id;

      print('User added successfully with ID: $documentId');
    } catch (error) {
      print('Error adding user: $error');
    }
  }

  Future<void> deleteUser(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete auth user from Firebase Authentication
        querySnapshot.docs.first['user_id'];

        // Delete user from the 'users' collection
        await querySnapshot.docs.first.reference.delete();
      } else {
        print('User with the provided email has not been found');
      }
    } catch (error) {
      print('Error adding user: $error');
    }
  }

  Future<void> deleteLecturer(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete auth user from Firebase Authentication
        querySnapshot.docs.first['user_id'];

        // Delete user from the 'users' collection
        await querySnapshot.docs.first.reference.delete();
      } else {
        print('User with the provided email has not been found');
      }
    } catch (error) {
      print('Error adding user: $error');
    }
  }

  Future<void> deleteStudent(String email) async {
    try {
      QuerySnapshot querySnapshot =
          await _usersCollection.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Delete auth user from Firebase Authentication
        querySnapshot.docs.first['user_id'];

        // Delete user from the 'users' collection
        await querySnapshot.docs.first.reference.delete();
      } else {
        print('User with the provided email has not been found');
      }
    } catch (error) {
      print('Error adding user: $error');
    }
  }
}
