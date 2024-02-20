import 'package:bio_attendance/data/course_list.dart';
import 'package:bio_attendance/models/course_unit.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/helpers/input_validators.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/app_dropdown_button.dart';
import 'package:bio_attendance/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class AddLecturerScreen extends StatefulWidget {
  const AddLecturerScreen({Key? key}) : super(key: key);

  @override
  State<AddLecturerScreen> createState() => _RegisterViewState();
}

@override
class _RegisterViewState extends State<AddLecturerScreen> {
  late final TextEditingController _email;
  late final TextEditingController _name;
  late final TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final List<String> _courseValues = [
    'Information Technology',
    'Computer Science',
    'Business Information Technology'
  ];

  late List<CourseUnit> _courseUnitValues;

  late String _selectedCourse;
  late List<String> _selectedUnits;

  @override
  void initState() {
    _selectedCourse = _courseValues[0];
    _courseUnitValues =
        CourseList.getUnitsForCourse(courseName: _selectedCourse);
    _selectedUnits = [];
    _email = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  _resetForm() {
    setState(() {
      _email.text = '';
      _name.text = '';
      _password.text = '';
      _selectedUnits = [];
    });
  }

  @override
  void dispose() {
    _email.dispose();
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lecturer'),
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
                      textInputAction: TextInputAction.done,
                      prefixIcon: Icons.password_rounded,
                      validator: validatePassword,
                    ),
                    const SizedBox(
                      height: SpaceSize.medium,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: AppDropdownButton<String>(
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
                            _courseUnitValues = CourseList.getUnitsForCourse(
                                courseName: _selectedCourse);
                            _selectedUnits = [];
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    MultiSelectDialogField(
                      items: _courseUnitValues
                          .map((courseUnit) => MultiSelectItem<String>(
                              courseUnit.name,
                              "${courseUnit.name} - Year ${courseUnit.yearStudied}"))
                          .toList(),
                      title: Text("Course Units for $_selectedCourse"),
                      selectedColor: Colors.blue,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(40)),
                        border: Border.all(
                          color: Colors.blue,
                          width: 2,
                        ),
                      ),
                      buttonIcon: const Icon(
                        Icons.my_library_books_rounded,
                        color: Colors.blue,
                      ),
                      buttonText: Text(
                        "Units Taught",
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontSize: 16,
                        ),
                      ),
                      onConfirm: (results) {
                        setState(() {
                          _selectedUnits = results;
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
                              final password = _password.text;

                              try {
                                await databaseProvider.addLecturer({
                                  'name': name,
                                  'email': email,
                                  'course_units': _selectedUnits,
                                  'password': password
                                });
                                if (!mounted) return;
                                await showSuccessDialog(
                                  context,
                                  'Lecturer added successfully',
                                ).then((_) => _resetForm());

                                if (!mounted) return;
                              } on EmailAlreadyInUseException {
                                showErrorDialog(
                                  context,
                                  EmailAlreadyInUseException().toString(),
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
