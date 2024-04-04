import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/app_pie_chart.dart';
import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  final int totalStudents;
  final int signedToday;
  final String title;
  final List<String> labels;

  const AttendanceWidget(
      {super.key,
      required this.title,
      required this.totalStudents,
      required this.signedToday,
      required this.labels});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpaceSize.large),
          AppPieChart(dataMap: {
            labels[0]: signedToday.toDouble(),
            labels[1]: (totalStudents - signedToday).toDouble(),
          }),
          const SizedBox(height: SpaceSize.large),
          Text(
            "${labels[0]}: $signedToday",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpaceSize.medium),
          Text(
            "${labels[1]}: ${totalStudents - signedToday}",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.indigo[100]!,
            thickness: 1.5,
            height: 50,
          ),
          Text(
            "Total: $totalStudents",
            style: const TextStyle(
              color: Colors.indigo,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
