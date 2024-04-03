import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vertical_barchart/vertical-barchart.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';

class AppHorizontalBarChart extends StatelessWidget {
  const AppHorizontalBarChart({super.key, required this.barData});

  final List<Map<String, dynamic>> barData;
  //? Model for barData
  //? {
  //? String label;
  //? List<Color> colors;
  //? double value;
  //? }

  @override
  Widget build(BuildContext context) {
    Random random = Random();

    //* Named horizontal but is a vertical bar chart
    return VerticalBarchart(
      maxX: 55,
      data: barData.map((item) {
        return VBarChartModel(
          index: random.nextInt(50) + random.nextInt(10) + random.nextInt(20),
          label: item["label"],
          colors: item["colors"],
          jumlah: item["value"],
          tooltip: item["value"].toString(),
        );
      }).toList(),
      showLegend: true,
      showBackdrop: true,
      barStyle: BarStyle.DEFAULT,
    );
  }
}
