import 'package:bio_attendance/models/lecturer.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LecturersTab extends StatefulWidget {
  const LecturersTab({super.key});

  @override
  State<LecturersTab> createState() => _LecturersTabState();
}

class _LecturersTabState extends State<LecturersTab> {
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
            hintText: 'Lecturer Email Address',
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
                    Lecturer? lecturer =
                        await databaseProvider.getLecturer(_email.text);
                    if (lecturer == null) {
                    } else {
                      if (!mounted) return;
                      Navigator.of(context).pushNamed(
                        lecturerDetailsRoute,
                        arguments: {'lecturer': lecturer},
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
              Navigator.of(context).pushNamed(addLecturerRoute);
            },
            child: const Text("Add Lecturer"),
          ),
        ),
      ],
    );
  }
}
