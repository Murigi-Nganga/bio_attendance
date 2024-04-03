import 'package:bio_attendance/models/attendance.dart';

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
    print(timeSignedIn.weekday);
    String dayOfWeek = daysOfWeek[timeSignedIn.weekday]!;
    dayOccurrences[dayOfWeek] = dayOccurrences[dayOfWeek]! + 1;
  }

  return dayOccurrences;
}
