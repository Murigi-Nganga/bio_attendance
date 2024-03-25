import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/router/app_router.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:bio_attendance/utilities/extenstions/string_extensions.dart';
import 'package:bio_attendance/utilities/helpers/input_validators.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:bio_attendance/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, required this.role}) : super(key: key);

  final Role role;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //_identifier is an email or password
  final TextEditingController _identifier = TextEditingController();
  late final TextEditingController _password = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final homeRoute = switch (widget.role) {
      Role.admin => AppRouter.adminHomeRoute,
      Role.lecturer => AppRouter.lecturerHomeRoute,
      Role.student => AppRouter.studentHomeRoute,
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
                child: Image.asset('assets/images/${widget.role.name}.png'),
              ),
              const SizedBox(height: SpaceSize.large * 2),
              Text(
                widget.role.name.capitalizeFirstChar(),
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
                    widget.role == Role.student
                        ? CustomFormField(
                            controller: _identifier,
                            labelText: 'Registration Number',
                            prefixIcon: Icons.numbers_rounded,
                            validator: validateRegNumber,
                          )
                        : CustomFormField(
                            controller: _identifier,
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
                                  final identifier = _identifier.text;
                                  final password = _password.text;
                                  try {
                                    await databaseProvider.loginUser({
                                      'identifier': identifier,
                                      'role': widget.role,
                                      'password': password,
                                    });
                                    if (!context.mounted) return;
                                  } on UserNotFoundException {
                                    await showErrorDialog(
                                      context,
                                      UserNotFoundException(
                                              identifier:
                                                  widget.role == Role.student
                                                      ? 'registration number'
                                                      : 'email')
                                          .toString(),
                                    );
                                    return;
                                  } on InvalidRoleException {
                                    await showErrorDialog(
                                      context,
                                      InvalidRoleException().toString(),
                                    );
                                    return;
                                  } on IdentifierPasswordMismatchException {
                                    await showErrorDialog(
                                      context,
                                      IdentifierPasswordMismatchException()
                                          .toString(),
                                    );
                                    return;
                                  } on GenericException {
                                    await showErrorDialog(
                                      context,
                                      GenericException().toString(),
                                    );
                                    return;
                                  }

                                  if (!context.mounted) return;
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
