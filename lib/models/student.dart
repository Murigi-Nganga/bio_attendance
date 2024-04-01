class Student {
  final String name;
  final String regNo;
  final String course;
  final String email;
  final int yearOfStudy;
  final String faceEncodings;

  const Student({
    required this.name,
    required this.regNo,
    required this.course,
    required this.email,
    required this.yearOfStudy,
    required this.faceEncodings,
  });

  factory Student.fromJson(Map<String, dynamic> data) => Student(
        name: data['name'],
        regNo: data['reg_no'],
        course: data['course'],
        email: data['email'],
        yearOfStudy: data['year_of_study'],
        faceEncodings: data['face_encodings'],
      );

  Map<String, String> toJson() => {
        'name': name,
        'reg_no': regNo,
        'course': course,
        'email': email,
        'year_of_study': yearOfStudy.toString(),
        'face_encodings': faceEncodings
      };
}
