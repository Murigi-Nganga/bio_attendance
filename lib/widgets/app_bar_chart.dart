import 'package:flutter/material.dart';
import 'package:unique_simple_bar_chart/data_models.dart';
import 'package:unique_simple_bar_chart/simple_bar_chart.dart';

class AppBarChart extends StatelessWidget {
  const AppBarChart({Key? key, required this.barData}) : super(key: key);

  final List<Map<String, dynamic>> barData;
  //? Model for barData
  //? {
  //? String name;
  //? Color color;
  //? double value;
  //? }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 250,
          child: SimpleBarChart(
            horizontalBarPadding: 8,
            verticalBarTextStyleColor: Colors.black87,
            listOfHorizontalBarData: barData
                .map((item) => HorizontalDetailsModel(
                      name: '${item["name"]}',
                      color: item["color"],
                      size: item["value"],
                    ))
                .toList(),
            verticalInterval: 5,
          ),
        ),
      ],
    );
  }
}
