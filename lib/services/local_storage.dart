import 'package:bio_attendance/models/auth_user.dart';
import 'package:hive/hive.dart';

class LocalStorage {
  LocalStorage._privateConstructor();

  static final LocalStorage _instance = LocalStorage._privateConstructor();

  factory LocalStorage() {
    return _instance;
  }

  final Box<AuthUser> _userBox = Hive.box<AuthUser>('user');
  final Box<String> _courseNameBox = Hive.box<String>('course');

  Future<void> saveUser(AuthUser authUser) async =>
      await _userBox.put('app_user', authUser);

  AuthUser? getUser() => _userBox.get('app_user');

  Future<void> deleteUser() async {
    await _userBox.clear();
    await _courseNameBox.clear();
  }

  Future<void> saveCourseName(String courseName) async =>
      await _courseNameBox.put('course_name', courseName);

  String? getCourseName() => _courseNameBox.get('course_name');
}
