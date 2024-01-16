import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
import 'package:flutter/material.dart';

class LecturerDetailsScreen extends StatelessWidget {
  const LecturerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final Lecturer lecturer = args['lecturer'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturer Details'),
      ),
      body: Column(
        children: [
        Image.asset('assets/images/lecturer.png'),
        const SizedBox(height: Gap.large),
        Text('Full Name: ${lecturer.fullName}'),
        const SizedBox(height: Gap.medium),
        Text('Email Address: ${lecturer.email}'),
        const SizedBox(height: Gap.medium),
        const Text('Course Units Taught: '),
        const SizedBox(height: Gap.small),
        ...lecturer.courseUnits.map((courseUnit) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(courseUnit),
            const SizedBox(height: Gap.small),
          ],
        ),),
        const SizedBox(height: Gap.large),
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(Color.fromARGB(255, 185, 16, 16)),
              ),
              onPressed: () => print('Delete lecturer button tapped'),
              child: const Text('Delete'),
            ),
        ),
      ]),
    );
  }
}
