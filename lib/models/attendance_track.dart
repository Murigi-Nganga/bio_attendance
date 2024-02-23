import 'package:hive/hive.dart';

part 'attendance_track.g.dart';

@HiveType(typeId: 2)
class AttendanceTrack {
  @HiveField(0)
  final String courseUnit;

  @HiveField(1)
  final bool signInSuccessful;

  @HiveField(2)
  final DateTime timeSignedIn;

  AttendanceTrack({
    required this.courseUnit,
    required this.signInSuccessful,
    required this.timeSignedIn,
  });

  factory AttendanceTrack.fromJSON(Map<String, dynamic> data) =>
      AttendanceTrack(
        courseUnit: data['course_unit'],
        signInSuccessful: data['sign_in_successful'],
        timeSignedIn: data['time_signed_in'],
      );

  Map<String, dynamic> toJSON(Map<String, dynamic> data) => {
        'course_unit': courseUnit,
        'sign_in_successful': signInSuccessful,
        'time_signed_in': timeSignedIn
      };
}
