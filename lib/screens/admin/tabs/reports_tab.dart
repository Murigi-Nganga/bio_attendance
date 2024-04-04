import 'package:bio_attendance/models/attendance.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/utilities/helpers/stats_utils.dart';
import 'package:bio_attendance/widgets/app_horizontal_bar_chart.dart';
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

  List<Map<String, dynamic>> convertToChartData(
      Map<String, int> attendanceStatistics) {
    List<Map<String, dynamic>> chartData = [];

    attendanceStatistics.forEach((courseUnit, count) {
      chartData.add({
        'label': courseUnit,
        'colors': [generateRandomColor(), generateRandomColor()],
        'value': count.toDouble(),
      });
    });

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder<List<Attendance>>(
        future: Provider.of<DatabaseProvider>(context).getAllAttendances(),
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

            Map<String, int> courseUnitStats =
                groupAttendanceStatisticsByYear(attendances);

            Map<String, int> dayOccurrences =
                groupAttendanceStatisticsByDay(attendances);

            List<double> chartData =
                dayOccurrences.values.map((value) => value.toDouble()).toList();
            List<String> chartLabels = dayOccurrences.keys.toList();

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "All Students Attendance Summary",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 27, 84, 110),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Divider(
                    thickness: 1,
                    color: Colors.black38,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Attendances for today",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 6, 96, 138),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  todaysAttendances.isEmpty
                      ? 
                      Column(
                        children: [
                          Image.asset('assets/images/not_found.png', height: 200),
                      const SizedBox(height: 5),
                            const Text(
                              "Today's attendances will appear here once they are taken",
                              textAlign: TextAlign.center,
                            )
                        ]
                      )
                      : 
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
                  const SizedBox(height: 20),
                  const Text(
                    'General Statistics',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 69, 5, 118),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  chartData.reduce((value, element) => value + element) == 0
                      ? Column(
                          children: [
                            Image.asset('assets/images/not_found_2.png'),
                            const SizedBox(height: 5),
                            const Text(
                              "General statistics will appear here once atendances are taken",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            const Text(
                              'Attendances by day',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 6, 96, 138),
                                  fontWeight: FontWeight.bold),
                            ),
                            GridAppBarChart(
                              chartData: chartData,
                              chartLabels: chartLabels,
                              startColor: Colors.blue,
                              endColor: Colors.indigo,
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              "Attendances by year of study",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 6, 96, 138),
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            AppHorizontalBarChart(
                                barData: convertToChartData(courseUnitStats)),
                          ],
                        ),
                  //? {
                  //? String label;
                  //? List<Color> colors;
                  //? double value;
                  //? }
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
