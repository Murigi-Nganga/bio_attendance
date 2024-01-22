import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/screens/admin/admin_home_screen.dart';
import 'package:bio_attendance/screens/lecturer/lecturer_home_screen.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:bio_attendance/utilities/theme/app_theme.dart';
import 'package:bio_attendance/firebase_options.dart';
import 'package:bio_attendance/screens/auth/user_selection_screen.dart';
import 'package:bio_attendance/screens/student/student_home_screen.dart';
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
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: MaterialApp(
          title: 'Biometric Attendance Application',
          theme: appTheme,
          debugShowCheckedModeBanner: false,
          home: const MainPage(),
          routes: appRoutes,
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocalStorage().getUser(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          switch (snapshot.data!.role) {
            case Role.admin:
              return const AdminHomeScreen();
            case Role.student:
              return const StudentHomeScreen();
            case Role.lecturer:
              return const LecturerHomeScreen();
          }
        }
        return const UserSelectionScreen();
      },
    );
  }
}
