import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/confirm_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturerDetailsScreen extends StatelessWidget {
  const LecturerDetailsScreen({super.key, required this.lecturer});

  final Lecturer lecturer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturer Details'),
      ),
      body: Column(children: [
        Image.asset('assets/images/lecturer.png'),
        const SizedBox(height: SpaceSize.large),
        Text('Full Name: ${lecturer.fullName}'),
        const SizedBox(height: SpaceSize.medium),
        Text('Email Address: ${lecturer.email}'),
        const SizedBox(height: SpaceSize.medium),
        const Text('Course Units Taught: '),
        const SizedBox(height: SpaceSize.small),
        ...lecturer.courseUnits.map(
          (courseUnit) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(courseUnit),
              const SizedBox(height: SpaceSize.small),
            ],
          ),
        ),
        const SizedBox(height: SpaceSize.large),
        Consumer<DatabaseProvider>(
          builder: (_, databaseProvider, __) {
            if (databaseProvider.isLoading) {
              return const CircularProgressIndicator(
                  color: Color.fromARGB(255, 185, 16, 16));
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
                          .deleteLecturer(lecturer.email)
                          .then((_) {
                        showSuccessDialog(
                          context,
                          'Lecturer deleted successfully',
                        ).whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      });

                      if (!context.mounted) return;
                    } on UserNotFoundException {
                      showErrorDialog(
                        context,
                        UserNotFoundException().toString(),
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
