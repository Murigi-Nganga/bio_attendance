import 'package:bio_attendance/models/course.dart';
import 'package:bio_attendance/models/course_unit.dart';

class CourseList {
  static const List<Course> courseList = [
    Course(
      id: 1,
      name: "Information Technology",
      units: [
        CourseUnit(
            name: "Introduction to Programming",
            yearStudied: 1,
            attendanceLocation: 'Location A'),
        CourseUnit(
            name: "Computer Architecture",
            yearStudied: 1,
            attendanceLocation: 'Location A'),
        CourseUnit(
            name: "Data Structures",
            yearStudied: 2,
            attendanceLocation: 'Location B'),
        CourseUnit(
            name: "Algorithm Design",
            yearStudied: 2,
            attendanceLocation: 'Location B'),
        CourseUnit(
            name: "Database Systems",
            yearStudied: 3,
            attendanceLocation: 'Location C'),
        CourseUnit(
            name: "Software Engineering",
            yearStudied: 3,
            attendanceLocation: 'Location C'),
        CourseUnit(
            name: "Network Security",
            yearStudied: 4,
            attendanceLocation: 'Location D'),
        CourseUnit(
            name: "Artificial Intelligence",
            yearStudied: 4,
            attendanceLocation: 'Location D'),
      ],
    ),
    Course(
      id: 2,
      name: "Computer Science",
      units: [
        CourseUnit(
            name: "Introduction to Computer Science",
            yearStudied: 1,
            attendanceLocation: 'Location E'),
        CourseUnit(
            name: "Operating Systems",
            yearStudied: 1,
            attendanceLocation: 'Location E'),
        CourseUnit(
            name: "Database Management",
            yearStudied: 2,
            attendanceLocation: 'Location F'),
        CourseUnit(
            name: "Programming Languages",
            yearStudied: 2,
            attendanceLocation: 'Location F'),
        CourseUnit(
            name: "Computer Networks",
            yearStudied: 3,
            attendanceLocation: 'Location G'),
        CourseUnit(
            name: "Web Development",
            yearStudied: 3,
            attendanceLocation: 'Location G'),
        CourseUnit(
            name: "Machine Learning",
            yearStudied: 4,
            attendanceLocation: 'Location H'),
        CourseUnit(
            name: "Human-Computer Interaction",
            yearStudied: 4,
            attendanceLocation: 'Location H'),
      ],
    ),
    Course(
      id: 3,
      name: "Business Information Technology",
      units: [
        CourseUnit(
            name: "Business Basics",
            yearStudied: 1,
            attendanceLocation: 'Location J'),
        CourseUnit(
            name: "IT Project Management",
            yearStudied: 1,
            attendanceLocation: 'Location J'),
        CourseUnit(
            name: "Data Analysis for Business",
            yearStudied: 2,
            attendanceLocation: 'Location K'),
        CourseUnit(
            name: "E-Business Technologies",
            yearStudied: 2,
            attendanceLocation: 'Location K'),
        CourseUnit(
            name: "Information Systems Audit",
            yearStudied: 3,
            attendanceLocation: 'Location L'),
        CourseUnit(
            name: "IT Strategy and Governance",
            yearStudied: 3,
            attendanceLocation: 'Location L'),
        CourseUnit(
            name: "Enterprise Resource Planning",
            yearStudied: 4,
            attendanceLocation: 'Location M'),
        CourseUnit(
            name: "Business Intelligence",
            yearStudied: 4,
            attendanceLocation: 'Location M'),
      ],
    ),
  ];

  static List<String> getUnitsForYearAndCourse({
    required int year,
    required String courseName,
  }) {
    Course selectedCourse =
        courseList.firstWhere((course) => course.name == courseName);

    List<CourseUnit> unitsForYear = selectedCourse.units
        .where(
          (unit) => unit.yearStudied == year,
        )
        .toList();

    return unitsForYear.map((unit) => unit.name).toList();
  }

  static List<String> getLocationsForCourseUnits(List<String> courseUnitNames) {
    List<String> locations = [];

    for (Course course in courseList) {
      for (CourseUnit unit in course.units) {
        if (courseUnitNames.contains(unit.name)) {
          locations.add(unit.attendanceLocation);
        }
      }
    }

    return locations;
  }
}
