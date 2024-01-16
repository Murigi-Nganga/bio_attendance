class Lecturer {
  final String fullName;
  final String email;
  final List<String> courseUnits;

  const Lecturer({
    required this.fullName,
    required this.email,
    required this.courseUnits,
  });

  factory Lecturer.fromJson(Map<String, dynamic> data) => Lecturer(
        fullName: data['name'],
        email: data['email'],
        //TODO: Know how to convert them to individual objects
        courseUnits: (data['course_units'] as List<dynamic>).map((element) => element.toString()).toList(),
      );
}
