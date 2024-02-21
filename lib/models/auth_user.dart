import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:hive/hive.dart';

part 'auth_user.g.dart';

@HiveType(typeId: 0)
class AuthUser {
  @HiveField(0)
  final String identifier;

  @HiveField(1)
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
