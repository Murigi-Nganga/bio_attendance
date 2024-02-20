import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/confirm_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
      ),
      body: Column(children: [
        Image.asset('assets/images/student.png'),
        const SizedBox(height: SpaceSize.large),
        Text('Full Name: ${student.fullName}'),
        const SizedBox(height: SpaceSize.medium),
        Text('Registration Number: ${student.regNo}'),
        const SizedBox(height: SpaceSize.medium),
        Text('Course: ${student.course}'),
        const SizedBox(height: SpaceSize.medium),
        Text('Email Address: ${student.email}'),
        const SizedBox(height: SpaceSize.large),
        Consumer<DatabaseProvider>(
          builder: (_, databaseProvider, __) {
            if (databaseProvider.isLoading) {
              return const CircularProgressIndicator(
                color: Color.fromARGB(255, 185, 16, 16),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      Color.fromARGB(255, 185, 16, 16),
                    ),
                  ),
                  onPressed: () async {
                    try {
                      final shouldDelete = await showConfirmDialog(
                        context,
                        'Are you sure you want to delete',
                      );

                      if (shouldDelete == false) return;

                      await databaseProvider
                          .deleteStudent(student.regNo)
                          .then((_) {
                        showSuccessDialog(
                          context,
                          'Student deleted successfully',
                        ).whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      });
                      if (!context.mounted) return;
                    } on UserNotFoundException {
                      showErrorDialog(
                        context,
                        const UserNotFoundException(identifier: 'registration number').toString(),
                      );
                    } on GenericException {
                      showErrorDialog(
                        context,
                        GenericException().toString(),
                      );
                    }
                  },
                  child: const Text('Delete'),
                ),
              );
            }
          },
        ),
      ]),
    );
  }
}
