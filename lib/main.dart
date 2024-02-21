import 'package:bio_attendance/models/auth_user.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/router/app_router.dart';
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
import 'package:hive_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //* Request for location permissions if not granted
  await Permission.location.request();

  //* Initialize hive
  await Hive.initFlutter();

  //* Register hive adaptors
  Hive.registerAdapter(AuthUserAdapter());

  //* Initialize hive boxes
  await Hive.openBox<AuthUser>('app_user');
  await Hive.openLazyBox<String>('course_name');

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
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthUser? authUser = LocalStorage().getUser();

    return authUser == null
        ? const UserSelectionScreen()
        : switch (authUser.role) {
            Role.admin => const AdminHomeScreen(),
            Role.lecturer => const LecturerHomeScreen(),
            Role.student => const StudentHomeScreen()
          };
  }
}
