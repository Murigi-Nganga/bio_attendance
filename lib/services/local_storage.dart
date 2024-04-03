import 'package:bio_attendance/models/attendance_track.dart';
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
  final Box<int> _yearOfStudyBox = Hive.box<int>('year_of_study');
  final Box<AttendanceTrack> _attTrackBox =
      Hive.box<AttendanceTrack>('att_track');

  Future<void> saveUser(AuthUser authUser) async =>
      await _userBox.put('app_user', authUser);

  AuthUser? getUser() => _userBox.get('app_user');

  Future<void> deleteUser() async {
    await _userBox.clear();
    await _courseNameBox.clear();
    await _attTrackBox.clear();
    await _yearOfStudyBox.clear();
  }

  Future<void> saveCourseName(String courseName) async =>
      await _courseNameBox.put('course_name', courseName);

  String? getCourseName() => _courseNameBox.get('course_name');

  Future<void> saveYearOfStudy(int yearOfStudy) async =>
      await _yearOfStudyBox.put('study_year', yearOfStudy);

  int? getYearOfStudy() => _yearOfStudyBox.get('study_year');

  Future<void> addAttendanceTrack(AttendanceTrack attTrack) async =>
      await _attTrackBox.put(attTrack.courseUnit, attTrack);

  AttendanceTrack? getAttendnaceTrack(String courseUnit) =>
      _attTrackBox.get(courseUnit);

  List<AttendanceTrack> getAttendanceTracks() => _attTrackBox.values.toList();

  Future<void> deleteAttendnaceTrack(String courseUnit) async =>
      await _attTrackBox.delete(courseUnit);
}
