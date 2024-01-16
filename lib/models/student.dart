class Student {
  final String fullName;
  final String regNo;
  final String course;
  final String email;
  //TODO: Add the attendances field

  const Student({
    required this.fullName,
    required this.regNo,
    required this.course,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> data) => Student(
        fullName: data['name'],
        regNo: data['reg_no'],
        course: data['course'],
        email: data['email'],
      );

  Map<String, String> toJson() => {
        'full_name': fullName,
        'reg_no': regNo,
        'course': course,
        'email': email
      };
}
