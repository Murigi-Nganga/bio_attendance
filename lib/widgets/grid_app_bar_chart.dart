

import 'package:chart_components/chart_components.dart';
import 'package:flutter/material.dart';

class GridAppBarChart extends StatelessWidget {
  const GridAppBarChart(
      {Key? key,
      required this.chartData,
      required this.chartLabels,
      required this.startColor,
      required this.endColor}) : super(key: key);

  final List<double> chartData;
  final List<String> chartLabels;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 200,
      child: BarChart(
        data: chartData,
        labels: chartLabels,
        labelStyle: const TextStyle(fontSize: 15),
        valueStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        displayValue: true,
        getColor: (double value) {
          // Calculate the interpolation factor based on the value
          final double interpolationFactor =
              (value - chartData.reduce((a, b) => a < b ? a : b)) /
                  (chartData.reduce((a, b) => a > b ? a : b) -
                      chartData.reduce((a, b) => a < b ? a : b));

          // Interpolate colors between startColor and endColor
          final Color interpolatedColor =
              Color.lerp(startColor, endColor, interpolationFactor)!;

          return interpolatedColor;
        },
        barWidth: 36,
        barSeparation: 16,
        animationDuration: const Duration(milliseconds: 1500),
        animationCurve: Curves.easeInOutSine,
        itemRadius: 4,
        iconHeight: 24,
        footerHeight: 24,
        headerValueHeight: 16,
        roundValuesOnText: false,
        lineGridColor: Colors.lightBlue,
      ),
    );
  }
}
