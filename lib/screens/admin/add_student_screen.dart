import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/providers/student_image_provider.dart';
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
  late int _yearOfStudy;

  @override
  void initState() {
    _email = TextEditingController();
    _regNo = TextEditingController();
    _name = TextEditingController();
    _password = TextEditingController();
    _selectedCourse = _courseValues[0];
    _yearOfStudy = 1;
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
              // Image.asset(
              //   'assets/images/add_user.png',
              //   height: 250.0,
              // ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Consumer<StudentImageProvider>(
                      builder: (_, imgProvider, __) {
                        if (imgProvider.isLoading) {
                          return const CircularProgressIndicator();
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                backgroundImage: imgProvider.studImage == null
                                    ? null
                                    : FileImage(imgProvider.studImage!),
                                radius: 100,
                                child: imgProvider.studImage == null
                                    ? const Icon(
                                        Icons.person,
                                        size: 70,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(height: SpaceSize.small * .5),
                              imgProvider.isLoading
                                  ? const CircularProgressIndicator()
                                  : Column(
                                      children: [
                                        // imgProvider.studImage == null
                                        //     ? const SizedBox(child: Text("When the image is null"))
                                        //     : const Text('Not null image'),
                                        // SizedBox(
                                        //     width: context.size!.width * .9,
                                        //     child:
                                        //     CustomFormField(

                                        //       initialValue: imgController.studRegNo,
                                        //       keyboardType: TextInputType.text,
                                        //       labelText: 'Student Reg No',
                                        //       prefixIconData:
                                        //           Icons.app_registration_rounded,
                                        //       onChanged: imgController.studRegNo,
                                        //       validator: (value) =>
                                        //           validateRegNumber(
                                        //               value, 'Registration Number'),

                                        //       controller: null,
                                        //       prefixIcon: null,
                                        //     ),
                                        //   ),
                                        const SizedBox(
                                            height: SpaceSize.medium),
                                        // imgProvider.studImage == null
                                        //     ? const SizedBox()
                                        //     : SizedBox(
                                        //         width: context.size!.width * .7,
                                        //         child: ElevatedButton(
                                        //           onPressed: () async =>
                                        //               await imgProvider
                                        //                   .submitImage(),
                                        //           style: ButtonStyle(
                                        //             backgroundColor:
                                        //                 MaterialStateProperty
                                        //                     .all(Colors
                                        //                         .blueGrey[700]),
                                        //           ),
                                        //           child: const Text(
                                        //               'Submit Image'),
                                        //         ),
                                        //       ),
                                        const SizedBox(
                                            height: SpaceSize.small * .5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .7,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                await imgProvider
                                                    .takePicture(context);
                                                if (!context.mounted) return;
                                              } on ManyOrNoFacesException {
                                                await showErrorDialog(
                                                    context,
                                                    ManyOrNoFacesException()
                                                        .toString());
                                              } on IncorrectHeadPositionException {
                                                await showErrorDialog(
                                                    context,
                                                    IncorrectHeadPositionException()
                                                        .toString());
                                              } on DimEnvironmentException {
                                                await showErrorDialog(
                                                    context,
                                                    DimEnvironmentException()
                                                        .toString());
                                              } on NoPhotoCapturedException {
                                                await showErrorDialog(
                                                    context,
                                                    NoPhotoCapturedException()
                                                        .toString());
                                              } catch (error) {
                                                print(error);
                                                await showErrorDialog(
                                                    context,
                                                    GenericException()
                                                        .toString()
                                                        .toString());
                                              }
                                            },
                                            child: const Text('Take picture'),
                                          ),
                                        ),
                                        const SizedBox(
                                            height: SpaceSize.small * .5),
                                        const Text("OR"),
                                        const SizedBox(
                                            height: SpaceSize.medium * .5),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .7,
                                          child: OutlinedButton(
                                            onPressed: () async {
                                              try {
                                                await imgProvider
                                                    .getImageFromGallery();
                                                if (!context.mounted) return;
                                              } on NoImageSelectedException {
                                                await showErrorDialog(
                                                    context,
                                                    NoImageSelectedException()
                                                        .toString());
                                              } on ManyOrNoFacesException {
                                                await showErrorDialog(
                                                    context,
                                                    ManyOrNoFacesException()
                                                        .toString());
                                              } on IncorrectHeadPositionException {
                                                await showErrorDialog(
                                                    context,
                                                    IncorrectHeadPositionException()
                                                        .toString());
                                              } on DimEnvironmentException {
                                                await showErrorDialog(
                                                    context,
                                                    DimEnvironmentException()
                                                        .toString());
                                              }
                                            },
                                            child: const Text(
                                                'Upload gallery photo'),
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: SpaceSize.small),
                    Divider(
                      thickness: 1.25,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(.25),
                    ),
                    const SizedBox(height: SpaceSize.small),
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
                    const Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: 3.2,
                      child: Text(
                        'Year of Study',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: SpaceSize.small),
                    AppDropdownButton<int>(
                      items: List.generate(4, (index) => index + 1)
                          .map((number) => DropdownMenuItem(
                                value: number,
                                child: Text(number.toString()),
                              ))
                          .toList(),
                      value: _yearOfStudy,
                      onChanged: (newValue) {
                        setState(() {
                          _yearOfStudy = newValue!;
                        });
                      },
                    ),
                    const SizedBox(height: SpaceSize.medium),
                    Consumer<StudentImageProvider>(
                      builder: (_, imgProvider, __) {
                        return Consumer<DatabaseProvider>(
                            builder: (_, databaseProvider, __) {
                          if (databaseProvider.isLoading) {
                            return const CircularProgressIndicator();
                          } else {
                            return SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (imgProvider.studImage == null) {
                                    await showErrorDialog(
                                        context, 'Please add a student image!');
                                  }

                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  final email = _email.text;
                                  final name = _name.text;
                                  final regNo = _regNo.text;
                                  final password = _password.text;
                                  final course = _selectedCourse;
                                  final yearOfStudy = _yearOfStudy;
                                  final studentImage = imgProvider.studImage;

                                  try {
                                    await databaseProvider.addStudent({
                                      'name': name,
                                      'email': email,
                                      'reg_no': regNo,
                                      'course': course,
                                      'password': password,
                                      'year_of_study': yearOfStudy,
                                      'student_image': studentImage
                                    });
                                    if (!context.mounted) return;
                                    await showSuccessDialog(
                                      context,
                                      'Student added successfully',
                                    ).then((_) {
                                      _resetForm();
                                      imgProvider.resetStudImage();
                                    });

                                  } on EmailAlreadyInUseException {
                                    if (!context.mounted) return;
                                    showErrorDialog(
                                      context,
                                      EmailAlreadyInUseException().toString(),
                                    );
                                  } on RegNoAlreadyInUseException {
                                    if (!context.mounted) return;
                                    showErrorDialog(
                                      context,
                                      RegNoAlreadyInUseException().toString(),
                                    );
                                  } on GenericException {
                                    if (!context.mounted) return;
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
                        });
                      },
                    ),
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
