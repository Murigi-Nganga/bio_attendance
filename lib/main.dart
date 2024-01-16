import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/screens/admin/admin_home_screen.dart';
import 'package:bio_attendance/screens/lecturer/lecturer_home_screen.dart';
import 'package:bio_attendance/services/crud/local_storage.dart';
import 'package:bio_attendance/utilities/theme/app_theme.dart';
import 'package:bio_attendance/firebase_options.dart';
import 'package:bio_attendance/screens/auth/user_selection_screen.dart';
import 'package:bio_attendance/screens/student/student_home_screen.dart';
import 'package:bio_attendance/services/auth/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
      ],
      child: MaterialApp(
        title: 'Biometric Attendance Application',
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        home: const MainPage(),
        routes: appRoutes,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              return FutureBuilder(
                future: LocalStorage().getUserRole(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    switch (snapshot.data) {
                      case 'admin':
                        return const AdminHomeScreen();
                      case 'student':
                        return const StudentHomeScreen();
                      case 'lecturer':
                        return const LecturerHomeScreen();
                    }
                  }
                  return const UserSelectionScreen();
                },
              );
            } else {
              return const UserSelectionScreen();
            }

          default:
            return const Scaffold();
        }
      },
    );
  }
}
