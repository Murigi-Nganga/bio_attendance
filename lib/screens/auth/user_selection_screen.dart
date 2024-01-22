import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:bio_attendance/utilities/extenstions/string_extensions.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: SpaceSize.medium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Log In As',
              style: TextStyle(
                fontSize: FontSize.large,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: SpaceSize.large * 2),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: SpaceSize.medium,
              spacing: SpaceSize.large,
              children: [
                SelectionWidget(role: Role.admin),
                SelectionWidget(role: Role.lecturer),
                SelectionWidget(role: Role.student)
              ],
            )
          ],
        ),
      ),
    );
  }
}

class SelectionWidget extends StatelessWidget {
  const SelectionWidget({super.key, required this.role});

  final Role role;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            loginRoute,
            arguments: {'role': role},
          ),
          child: CircleAvatar(
            radius: SpaceSize.large * 2,
            backgroundColor: Colors.blue.shade200,
            child: Image.asset('assets/images/${role.name}.png'),
          ),
        ),
        const SizedBox(height: SpaceSize.medium),
        Text(role.name.capitalizeFirstChar())
      ],
    );
  }
}
