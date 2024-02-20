import 'package:bio_attendance/utilities/enums/app_enums.dart';

class AuthUser {
  final String identifier;
  final Role role;


  AuthUser({
    required this.identifier,
    required this.role,
  });

  factory AuthUser.fromJSON(Map<String, dynamic> data) => AuthUser(
        identifier: data['identifier'],
        role: data['role'],
      );

  Map<String, dynamic> toJSON() => {
        'identifier': identifier,
        'role': role,
      };
}
