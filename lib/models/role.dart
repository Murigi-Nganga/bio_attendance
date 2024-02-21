import 'package:hive/hive.dart';

part 'role.g.dart';

@HiveType(typeId: 1)
enum Role {
  @HiveField(0)
  admin, 
  
  @HiveField(1)
  student, 
  
  @HiveField(2)
  lecturer 
}
