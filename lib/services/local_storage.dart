import 'package:bio_attendance/models/auth_user.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage._privateConstructor();

  static final LocalStorage _instance = LocalStorage._privateConstructor();

  factory LocalStorage() {
    return _instance;
  }

  Future<void> saveUser(AuthUser authUser) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('identifier', authUser.identifier);
    await prefs.setString('role', authUser.role.name);
  }

  Future<void> saveCourseName(String courseName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('course_name', courseName);
  }

  Future<String?> getCourseName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('course_name');
  }

  Future<AuthUser?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? identifier = prefs.getString('identifier');
    Role? role = prefs.getString('role') == null
        ? null
        : Role.values.byName(prefs.getString('role')!);

    if (role == null || identifier == null) return null;

    return AuthUser(
      identifier: identifier,
      role: role,
    );
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
