import 'package:bio_attendance/utilities/enums/app_enums.dart';

class AuthUser {
  final String email;
  final Role role;


  AuthUser({
    required this.email,
    required this.role,
  });

  factory AuthUser.fromJSON(Map<String, dynamic> data) => AuthUser(
        email: data['email'],
        role: data['role'],
      );

  Map<String, dynamic> toJSON() => {
        'email': email,
        'role': role,
      };
}
