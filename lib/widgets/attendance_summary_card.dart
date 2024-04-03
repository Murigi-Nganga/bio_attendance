import 'package:flutter/material.dart';

class AttendanceSummaryCard extends StatelessWidget {
  const AttendanceSummaryCard({
    super.key,
    required this.courseUnit,
    required this.timeSignedIn,
  });

  final String courseUnit;
  final DateTime timeSignedIn;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      leading: _buildIcon(timeSignedIn),
      title: Text(courseUnit),
      subtitle: Text('${timeSignedIn.hour}: ${timeSignedIn.minute} hrs'),
    ));
  }

  Icon _buildIcon(DateTime timeSignedIn) {
    Icon iconData = switch (timeSignedIn.hour) {
      >= 7 && < 12 => Icon(Icons.light_mode_rounded, color: Colors.blue[700],),
      >= 12 && <= 16 => Icon(Icons.wb_twilight_outlined, color: Colors.yellow[700]),
      _ => Icon(Icons.dark_mode_rounded, color: Colors.blue[900])
    };

    return iconData;
  }
}
