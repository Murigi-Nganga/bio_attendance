class Attendance {
  final String studentRegNo;
  final int yearOfStudy;
  final DateTime timeSignedIn;
  final String course;
  final String courseUnit;

  Attendance({
    required this.studentRegNo,
    required this.yearOfStudy,
    required this.timeSignedIn,
    required this.course,
    required this.courseUnit,
  });

  factory Attendance.fromJSON(Map<String, dynamic> data) {
    // Convert Timestamp to DateTime
    DateTime formattedTime = data['time_signed_in'].toDate();

    return Attendance(
      studentRegNo: data['student_reg_no'],
      yearOfStudy: data['year_of_study'],
      timeSignedIn: formattedTime,
      course: data['course'],
      courseUnit: data['course_unit'],
    );
  }

  Map<String, dynamic> toJSON() => {
        'student_reg_no': studentRegNo,
        'year_of_study': yearOfStudy,
        'time_signed_in': timeSignedIn,
        'course': course,
        'course_unit': courseUnit,
      };
}
