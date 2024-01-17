import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/services/database_service.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:bio_attendance/utilities/extenstions/string_extensions.dart';
import 'package:bio_attendance/utilities/theme/gaps.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;

    final Role role = arguments['role']!;

    final homeRoute = switch (role) {
      Role.admin => adminHomeRoute,
      Role.lecturer => lecturerHomeRoute,
      Role.student => studentHomeRoute,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset('assets/images/${role.name}.png'),
              ),
              const SizedBox(height: Gap.large * 2),
              Text(
                role.name.capitalizeFirstChar(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: Gap.large),
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter your email here',
                ),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                  hintText: 'Enter your password here',
                ),
              ),
              const SizedBox(height: Gap.medium),
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: ElevatedButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;

                    //TODO: Correct the login logic
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
