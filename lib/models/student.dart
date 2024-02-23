class Student {
  final String name;
  final String regNo;
  final String course;
  final String email;

  const Student({
    required this.name,
    required this.regNo,
    required this.course,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> data) => Student(
        name: data['name'],
        regNo: data['reg_no'],
        course: data['course'],
        email: data['email'],
      );

  Map<String, String> toJson() => {
        'name': name,
        'reg_no': regNo,
        'course': course,
        'email': email
      };
}
