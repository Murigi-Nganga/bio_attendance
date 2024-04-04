import 'dart:math';

import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/attendance.dart';
import 'package:flutter/material.dart';

Color generateRandomColor() {
  Random random = Random();
  return Color.fromARGB(
    255,
    random.nextInt(256),
    random.nextInt(256),
    random.nextInt(256),
  );
}

bool isWithinToday(DateTime timeSignedIn) {
  //* Get today's date
  DateTime today = DateTime.now();
  DateTime todayDate = DateTime(today.year, today.month, today.day);

  //* Check if the attendance date is today
  return timeSignedIn.year == todayDate.year &&
      timeSignedIn.month == todayDate.month &&
      timeSignedIn.day == todayDate.day;
}

Map<String, int> groupAttendanceStatisticsByDay(List<Attendance> attendances) {
  Map<int, String> daysOfWeek = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun'
  };

  Map<String, int> dayOccurrences = {
    'Mon': 0,
    'Tue': 0,
    'Wed': 0,
    'Thu': 0,
    'Fri': 0,
    'Sat': 0,
    'Sun': 0,
  };

  for (Attendance attendance in attendances) {
    DateTime timeSignedIn = attendance.timeSignedIn;
    String dayOfWeek = daysOfWeek[timeSignedIn.weekday]!;
    dayOccurrences[dayOfWeek] = dayOccurrences[dayOfWeek]! + 1;
  }

  return dayOccurrences;
}

Map<String, int> groupAttendanceStatisticsByCourseUnit(
    List<Attendance> attendances, String courseName, int yearOfStudy) {
  List<String> courseUnitNames = CourseList.getUnitsForYearAndCourse(
      year: yearOfStudy, courseName: courseName);

  Map<String, int> attendanceByCourseUnit = {
    for (var unitName in courseUnitNames) unitName: 0
  };

  for (Attendance attendance in attendances) {
    if (courseUnitNames.contains(attendance.courseUnit)) {
      attendanceByCourseUnit[attendance.courseUnit] =
          attendanceByCourseUnit[attendance.courseUnit]! + 1;
    }
  }

  return attendanceByCourseUnit;
}

Map<String, int> groupAttendanceStatisticsByYear(List<Attendance> attendances) {
  Map<String, int> attendanceByYear = {};

  for (Attendance attendance in attendances) {
    int year = attendance.yearOfStudy;
    if (attendanceByYear.containsKey('Year: ${year.toString()}')) {
      attendanceByYear['Year: ${year.toString()}'] =
          attendanceByYear['Year: ${year.toString()}']! + 1;
    } else {
      attendanceByYear['Year: ${year.toString()}'] = 1;
    }
  }

  return attendanceByYear;
}
