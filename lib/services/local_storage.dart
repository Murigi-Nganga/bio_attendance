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
    await prefs.setString('email', authUser.email);
    await prefs.setString('role', authUser.role.name);
  }

  Future<AuthUser?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    Role? role = prefs.getString('role') == null
        ? null
        : Role.values.byName(prefs.getString('role')!);

    if (role == null || email == null) {
      return null;
    }

    return AuthUser(
      email: email,
      role: role,
    );
  }

  Future<void> deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('role');
  }
}
