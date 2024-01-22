import 'dart:io';

import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:bio_attendance/utilities/extenstions/string_extensions.dart';
import 'package:bio_attendance/utilities/helpers/validators/input_validators.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset('assets/images/${role.name}.png'),
              ),
              const SizedBox(height: SpaceSize.large * 2),
              Text(
                role.name.capitalizeFirstChar(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: SpaceSize.large),
              Form(
                key: _loginFormKey,
                child: Column(
                  children: [
                    CustomFormField(
                      controller: _email,
                      textInputType: TextInputType.emailAddress,
                      labelText: 'Email Address',
                      prefixIcon: Icons.email_rounded,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    CustomFormField(
                      controller: _password,
                      textInputAction: TextInputAction.done,
                      obscureText: true,
                      labelText: 'Password',
                      prefixIcon: Icons.password,
                      validator: validatePassword,
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
                                if (_loginFormKey.currentState!.validate()) {
                                  final email = _email.text;
                                  final password = _password.text;
                                  try {
                                    await databaseProvider.loginUser({
                                      'email': email,
                                      'role': role,
                                      'password': password,
                                    });
                                    if (!mounted) return;
                                  } on UserNotFoundException {
                                    await showErrorDialog(
                                      context,
                                      UserNotFoundException().toString(),
                                    );
                                    return;
                                  } on InvalidRoleException {
                                    await showErrorDialog(
                                      context,
                                      InvalidRoleException().toString(),
                                    );
                                    return;
                                  } on EmailPasswordMismatchException {
                                    await showErrorDialog(
                                      context,
                                      EmailPasswordMismatchException()
                                          .toString(),
                                    );
                                    return;
                                  } on SocketException {
                                    await showErrorDialog(
                                      context,
                                      'Please check your internet connection',
                                    );
                                    return;
                                  } on GenericException {
                                    await showErrorDialog(
                                      context,
                                      GenericException().toString(),
                                    );
                                    return;
                                  }

                                  if (!mounted) return;
                                  showSuccessDialog(
                                      context, 'Login Successful');
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                    homeRoute,
                                    (route) => false,
                                  );
                                }
                              },
                              child: const Text('Login'),
                            ),
                          );
                        }
                      },
                    )
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
