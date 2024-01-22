import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  final LocalAuthentication auth = LocalAuthentication();
  bool? isAuthenticated;

  Future<void> _authenticate() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;

    if (canAuthenticateWithBiometrics) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();

      if (availableBiometrics.isNotEmpty) {
        try {
          final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to sign your attendance',
            options: const AuthenticationOptions(
              biometricOnly: true,
              stickyAuth: true,
            ),
          );
          if (!mounted) return;
          if (didAuthenticate) {
            setState(() {
              isAuthenticated = true;
            });
            showSuccessDialog(context, 'Authentication successful');
          } else {
            setState(() {
              isAuthenticated = false;
            });
            showErrorDialog(context, 'Authentication failed');
          }
        } catch (e) {
          if (!mounted) return;
          setState(() {
              isAuthenticated = null;
            });
          showErrorDialog(context, 'Could not do authentication');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: _authenticate,
          child: const Text('Authenticate'),
        ),
        const SizedBox(height: 20),
        Text(
          isAuthenticated == null
              ? 'Authentication not done'
              : (isAuthenticated! == true
                  ? 'Authentication successful'
                  : 'Authentication failed'),
        ),
      ],
    );
  }
}
