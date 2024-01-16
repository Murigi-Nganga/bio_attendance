import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
import 'package:flutter/material.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Student student = args['student'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Column(
        children: [
        Image.asset('assets/images/student.png'),
        const SizedBox(height: Gap.large),
        Text('Full Name: ${student.fullName}'),
        const SizedBox(height: Gap.medium),
        Text('Registration Number: ${student.regNo}'),
        const SizedBox(height: Gap.medium),
        Text('Course: ${student.course}'),
        const SizedBox(height: Gap.medium),
        Text('Email Address: ${student.email}'),
        const SizedBox(height: Gap.large),
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 185, 16, 16)),
            ),
            onPressed: () => print('Delete student button tapped'),
            child: const Text('Delete'),
          ),
        ),
      ]),
    );
  }
}
