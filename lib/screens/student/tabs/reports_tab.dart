import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/helpers/date_utils.dart';
// import 'package:bio_attendance/widgets/app_bar_chart.dart';
import 'package:bio_attendance/widgets/attendance_summary_card.dart';
import 'package:bio_attendance/widgets/grid_app_bar_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportsTab extends StatelessWidget {
  const ReportsTab({Key? key}) : super(key: key);

  Map<String, dynamic> convertToBarDataEntry(String name, double value) {
    // Define colors for each day
    Map<String, Color> dayColors = {
      'Mon': Colors.blue,
      'Tue': Colors.green,
      'Wed': Colors.orange,
      'Thu': Colors.red,
      'Fri': Colors.purple,
      'Sat': Colors.yellow,
      'Sun': Colors.teal,
    };

    Color color = dayColors[name] ?? Colors.grey;

    return {
      'name': name,
      'color': color,
      'value': value,
    };
  }

  List<Map<String, dynamic>> convertToBarData(Map<String, int> dayOccurrences) {
    List<Map<String, dynamic>> barData = [];
    dayOccurrences.forEach((day, count) {
      barData.add(convertToBarDataEntry(day, count.toDouble()));
    });

    return barData;
  }

  @override
  Widget build(BuildContext context) {
    String studentRegNo = LocalStorage().getUser()!.identifier;

    return FutureBuilder<List<Attendance>>(
      future: Provider.of<DatabaseProvider>(context)
          .getStudentAttendances(studentRegNo),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<Attendance> attendances = snapshot.data ?? [];
          List<Attendance> todaysAttendances = attendances
              .where((attendance) => isWithinToday(attendance.timeSignedIn))
              .toList();

          Map<String, int> dayOccurrences =
              groupAttendanceStatisticsByDay(attendances);

          List<double> chartData =
              dayOccurrences.values.map((value) => value.toDouble()).toList();
          List<String> chartLabels = dayOccurrences.keys.toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("My Attendance Summary"),
              const Divider(
                height: 8,
                thickness: 1,
              ),
              const Text("Attendances for today"),
              ListView.builder(
                shrinkWrap: true,
                itemCount: todaysAttendances.length,
                itemBuilder: (context, index) {
                  var attendance = todaysAttendances[index];
                  return AttendanceSummaryCard(
                    courseUnit: attendance.courseUnit,
                    timeSignedIn: attendance.timeSignedIn,
                  );
                },
              ),
              const SizedBox(height: 10),
              //? Model for barData
              //? {
              //? String name;
              //? Color color;
              //? double value;
              //? }
              const Text('General Statistics'),
              const SizedBox(height: 20),
              const Text('Attendance by day'),
              // AppBarChart(barData: barData),
              GridAppBarChart(
                  chartData: chartData,
                  chartLabels: chartLabels,
                  startColor: Colors.blue,
                  endColor: Colors.indigo),
            ],
          );
        }
      },
    );
  }
}
