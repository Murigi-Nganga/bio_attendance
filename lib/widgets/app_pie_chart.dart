//* Pie Chart Widget

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AppPieChart extends StatelessWidget {
  const AppPieChart({
    super.key,
    required this.dataMap,
  });

  final Map<String, double> dataMap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: PieChart(
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          decimalPlaces: 1,
          showChartValuesInPercentage: true,
          chartValueStyle: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerWidget: const Text(
          "Attendance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        colorList: const [Colors.indigoAccent, Colors.redAccent],
        // ringStrokeWidth: 30.0,
        chartType: ChartType.ring,
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 1500),
      ),
    );
  }
}