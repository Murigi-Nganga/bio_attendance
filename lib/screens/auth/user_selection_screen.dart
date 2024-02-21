import 'package:bio_attendance/router/app_router.dart';
import 'package:bio_attendance/models/role.dart';
import 'package:bio_attendance/utilities/extenstions/string_extensions.dart';
import 'package:bio_attendance/utilities/theme/sizes.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatelessWidget {
  const UserSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpaceSize.medium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Log In As',
              style: TextStyle(
                fontSize: FontSize.large,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SpaceSize.large * 2),
            Wrap(
              alignment: WrapAlignment.spaceEvenly,
              runSpacing: SpaceSize.medium,
              spacing: SpaceSize.large,
              children: Role.values.map((Role role) => SelectionWidget(role: role)).toList(),
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
            AppRouter.loginRoute,
            arguments: {'role': role},
          ),
          child: CircleAvatar(
            radius: SpaceSize.large * 2.3,
            backgroundColor: Colors.indigo.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset('assets/images/${role.name}.png'),
            ),
          ),
        ),
        const SizedBox(height: SpaceSize.medium),
        Text(role.name.capitalizeFirstChar())
      ],
    );
  }
}
