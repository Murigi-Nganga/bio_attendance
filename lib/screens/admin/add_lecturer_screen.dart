import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
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

  final List<String> _courseUnitValues = [
    'Linear Algebra',
    'Introduction to Programming',
    'System Analysis and Design',
    'Database Design',
    'Mobile Development',
    'Data Structures and Algorithms',
    'Cloud Computing',
    'Compiler Construction'
  ];

  List<String> _selectedUnits = [];

  @override
  void initState() {
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
              const SizedBox(
                height: Gap.small,
              ),
              MultiSelectDialogField(
                items: _courseUnitValues
                    .map((courseUnit) =>
                        MultiSelectItem<String>(courseUnit, courseUnit))
                    .toList(),
                title: const Text("Course Units"),
                selectedColor: Colors.blue,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(40)),
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
                        final password = _password.text;
                        //TODO: Add selection of multiple values

                        try {
                          await databaseProvider.addLecturer({
                            'name': name,
                            'email': email,
                            'course_units': _selectedUnits,
                            'password': password
                          });
                          if (!mounted) return;
                          //TODO: Show a different type of dialog
                          await showErrorDialog(
                            context,
                            'Lecturer added successfully',
                          ).then((_) => _resetForm());

                          if (!mounted) return;
                        } catch (e) {
                          print(e);
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
