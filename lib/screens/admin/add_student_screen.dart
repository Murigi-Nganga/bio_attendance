import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/helpers/input_validators.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/app_dropdown_button.dart';
import 'package:bio_attendance/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({Key? key}) : super(key: key);

  @override
  State<AddStudentScreen> createState() => _RegisterViewState();
}

@override
class _RegisterViewState extends State<AddStudentScreen> {
  late final TextEditingController _regNo;
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  final List<String> _courseValues = [
    'Information Technology',
    'Computer Science',
    'Business Information Technology'
  ];

  late String _selectedCourse;

  @override
  void initState() {
    _email = TextEditingController();
    _regNo = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
    _selectedCourse = _courseValues[0];
    super.initState();
  }

  _resetForm() {
    setState(() {
      _email.text = '';
      _regNo.text = '';
      _name.text = '';
      _password.text = '';
      _selectedCourse = _courseValues[0];
    });
  }

  @override
  void dispose() {
    _regNo.dispose();
    _email.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/add_user.png',
                height: 250.0,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: _name,
                      labelText: 'Full Name',
                      prefixIcon: Icons.abc_rounded,
                      validator: validateName,
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    CustomFormField(
                      controller: _regNo,
                      labelText: 'Registration Number',
                      prefixIcon: Icons.app_registration_rounded,
                      validator: validateRegNumber,
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    CustomFormField(
                      controller: _email,
                      labelText: 'Email Address',
                      prefixIcon: Icons.email_rounded,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    CustomFormField(
                      controller: _password,
                      labelText: 'Password',
                      obscureText: true,
                      textInputAction: TextInputAction.next,
                      prefixIcon: Icons.password_rounded,
                      validator: validatePassword,
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    AppDropdownButton<String>(
                      items: _courseValues
                          .map(
                            (courseValue) => DropdownMenuItem(
                              value: courseValue,
                              child: Text(courseValue),
                            ),
                          )
                          .toList(),
                      value: _selectedCourse,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCourse = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    Consumer<DatabaseProvider>(
                        builder: (_, databaseProvider, __) {
                      if (databaseProvider.isLoading) {
                        return const CircularProgressIndicator();
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width * .75,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (!_formKey.currentState!.validate()) return;

                              final email = _email.text;
                              final name = _name.text;
                              final regNo = _regNo.text;
                              final password = _password.text;
                              final course = _selectedCourse;

                              try {
                                await databaseProvider.addStudent({
                                  'name': name,
                                  'email': email,
                                  'reg_no': regNo,
                                  'course': course,
                                  'password': password
                                });
                                if (!mounted) return;
                                await showSuccessDialog(
                                  context,
                                  'Student added successfully',
                                ).then((_) => _resetForm());

                                if (!mounted) return;
                              } on EmailAlreadyInUseException {
                                showErrorDialog(
                                  context,
                                  EmailAlreadyInUseException().toString(),
                                );
                              } on RegNoAlreadyInUseException {
                                showErrorDialog(
                                  context,
                                  RegNoAlreadyInUseException().toString(),
                                );
                              } on GenericException {
                                showErrorDialog(
                                  context,
                                  GenericException().toString(),
                                );
                              }
                            },
                            child: const Text("Register"),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
