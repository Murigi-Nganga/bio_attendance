import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/app_pie_chart.dart';
import 'package:flutter/material.dart';

class AttendanceWidget extends StatelessWidget {
  final int totalStudents;
  final int signedToday;

  const AttendanceWidget({
    super.key,
    required this.totalStudents,
    required this.signedToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(69, 141, 229, 241),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Statistics for Today's Class",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpaceSize.large),
          AppPieChart(dataMap: {
            "Signed": signedToday.toDouble(),
            "Not signed": (totalStudents - signedToday).toDouble(),
          }),
          const SizedBox(height: SpaceSize.large),
          Text(
            "Signed: $signedToday",
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: SpaceSize.medium),
          Text(
            "Not Signed: ${totalStudents - signedToday}",
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