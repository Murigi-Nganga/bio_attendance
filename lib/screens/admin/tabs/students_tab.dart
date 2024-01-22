import 'dart:io';

import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/helpers/validators/input_validators.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  late final TextEditingController _email;
  final _searchFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/search.png'),
        Form(
          key: _searchFormKey,
          child: Column(
            children: [
              CustomFormField(
                controller: _email,
                labelText: 'Student Email Address',
                textInputAction: TextInputAction.done,
                prefixIcon: Icons.email_rounded,
                validator: validateEmail,
              ),
              const SizedBox(height: SpaceSize.large),
              Consumer<DatabaseProvider>(
                builder: (context, databaseProvider, child) {
                  if (databaseProvider.isLoading) {
                    return const CircularProgressIndicator();
                  } else {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_searchFormKey.currentState!.validate()) return;
                          try {
                            Student student =
                                await databaseProvider.getStudent(_email.text);

                            if (!mounted) return;
                            Navigator.of(context).pushNamed(
                              studentDetailsRoute,
                              arguments: {'student': student},
                            );
                          } on UserNotFoundException {
                            showErrorDialog(
                              context,
                              UserNotFoundException().toString(),
                            );
                          } on SocketException {
                            showErrorDialog(
                              context,
                              'Please check your internet connection',
                            );
                          } on GenericException {
                            showErrorDialog(
                              context,
                              GenericException().toString(),
                            );
                          }
                        },
                        child: const Text("Search"),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: SpaceSize.medium),
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: OutlinedButton(
            onPressed: () async {
              Navigator.of(context).pushNamed(addStudentRoute);
            },
            child: const Text("Add Student"),
          ),
        ),
      ],
    );
  }
}
