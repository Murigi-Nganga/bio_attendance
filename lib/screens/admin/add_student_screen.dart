import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/auth/auth_exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
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
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/add_user.png',
                height: 250.0,
              ),
              TextField(
                controller: _name,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                ),
              ),
              TextField(
                controller: _regNo,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Registration Number',
                ),
              ),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email Address',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: Gap.small),
              DropdownButton<String>(
                value: _selectedCourse,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCourse = newValue!;
                  });
                },
                items: _courseValues
                    .map(
                      (courseValue) => DropdownMenuItem(
                        value: courseValue,
                        child: Text(courseValue),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: Gap.medium),
              Consumer<DatabaseProvider>(builder: (_, databaseProvider, __) {
                if (databaseProvider.isLoading) {
                  return const CircularProgressIndicator();
                } else {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: ElevatedButton(
                      onPressed: () async {
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
                          //TODO: Show a different type of dialog
                          await showErrorDialog(
                            context,
                            'Student added successfully',
                          ).then((_) => _resetForm());

                          if (!mounted) return;
                        } on WeakPasswordAuthException {
                          await showErrorDialog(
                            context,
                            'Weak password',
                          );
                        } on EmailAlreadyInUseAuthException {
                          await showErrorDialog(
                            context,
                            'Email is already in use',
                          );
                        } on InvalidEmailAuthException {
                          await showErrorDialog(
                            context,
                            'This is an invalid email address',
                          );
                        } on GenericAuthException {
                          await showErrorDialog(
                            context,
                            'Failed to register',
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
      ),
    );
  }
}
