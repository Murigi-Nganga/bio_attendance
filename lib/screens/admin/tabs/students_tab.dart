import 'package:bio_attendance/models/student.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentsTab extends StatefulWidget {
  const StudentsTab({super.key});

  @override
  State<StudentsTab> createState() => _StudentsTabState();
}

class _StudentsTabState extends State<StudentsTab> {
  late final TextEditingController _email;

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
        TextField(
          controller: _email,
          enableSuggestions: false,
          autocorrect: false,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Student Email Address',
          ),
        ),
        const SizedBox(height: Gap.large),
        Consumer<DatabaseProvider>(
          builder: (context, databaseProvider, child) {
            if (databaseProvider.isLoading) {
              return const CircularProgressIndicator();
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: ElevatedButton(
                  onPressed: () async {
                    Student? student =
                        await databaseProvider.getStudent(_email.text);
                    if (student == null) {
                    } else {
                      if (!mounted) return;
                      print(context);
                      Navigator.of(context).pushNamed(
                        studentDetailsRoute,
                        arguments: {'student': student},
                      );
                    }
                  },
                  child: const Text("Search"),
                ),
              );
            }
          },
        ),
        const SizedBox(height: Gap.medium),
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
