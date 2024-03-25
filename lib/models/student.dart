class Student {
  final String name;
  final String regNo;
  final String course;
  final String email;
  final int yearOfStudy;
  final String facialEncodings;

  const Student({
    required this.name,
    required this.regNo,
    required this.course,
    required this.email,
    required this.yearOfStudy,
    required this.facialEncodings,
  });

  factory Student.fromJson(Map<String, dynamic> data) => Student(
        name: data['name'],
        regNo: data['reg_no'],
        course: data['course'],
        email: data['email'],
        yearOfStudy: data['year_of_study'],
        facialEncodings: data['facial_encodings'],
      );

  Map<String, String> toJson() => {
        'name': name,
        'reg_no': regNo,
        'course': course,
        'email': email,
        'year_of_study': yearOfStudy.toString(),
        'facial_encodings': facialEncodings
      };
}
