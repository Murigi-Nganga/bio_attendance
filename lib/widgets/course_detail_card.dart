import 'package:flutter/material.dart';

class CourseDetailCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const CourseDetailCard({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}